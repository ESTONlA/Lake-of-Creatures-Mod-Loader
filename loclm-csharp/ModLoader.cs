using System.Diagnostics;
using System.Reflection;
using UndertaleModLib;

public sealed class ModLoader
{
    private readonly ModLoadOptions options;
    private readonly Action<string> info;
    private readonly Action<string> step;
    private readonly Action<string> success;
    private readonly Action<string> warn;
    private readonly Action<string> error;
    private readonly Action<string> plain;

    public ModLoader(
        ModLoadOptions options,
        Action<string> info,
        Action<string> step,
        Action<string> success,
        Action<string> warn,
        Action<string> error,
        Action<string> plain)
    {
        this.options = options;
        this.info = info;
        this.step = step;
        this.success = success;
        this.warn = warn;
        this.error = error;
        this.plain = plain;
    }

    public ModLoadExecutionResult LoadMods(
        UndertaleData data,
        string modsDirectory,
        string disabledModsDirectory,
        string quarantineDirectory,
        string loaderVersion,
        GameCompatibilityInfo gameCompatibility,
        SecurityAllowlist securityAllowlist,
        IReadOnlyCollection<string> whitelisted,
        IReadOnlyCollection<string> blacklisted,
        ResourceChangeTracker changeTracker)
    {
        ModLoadPlan loadPlan = ModLoadPlanner.Build(
            modsDirectory,
            disabledModsDirectory,
            loaderVersion,
            gameCompatibility,
            whitelisted,
            blacklisted,
            info,
            warn,
            error);

        info(options.StrictMode
            ? "Mod failure mode: strict. First load failure stops remaining mods."
            : "Mod failure mode: relaxed. Failed mods are skipped when safe.");

        List<string> loadedMods = new();
        List<string> failedMods = loadPlan.Statuses
            .Where(status => status.State is "failed" or "blocked")
            .Select(status => $"{status.ModName}: {status.Error}".TrimEnd(':', ' '))
            .ToList();
        List<string> securityBlockedMods = new();
        bool hasErrored = false;

        foreach (ModInfo mod in loadPlan.Mods)
        {
            if (hasErrored && options.StrictMode)
            {
                break;
            }

            LoadSingleMod(
                data,
                modsDirectory,
                quarantineDirectory,
                securityAllowlist,
                changeTracker,
                mod,
                FindStatus(loadPlan.Statuses, mod),
                loadedMods,
                failedMods,
                securityBlockedMods,
                ref hasErrored);
        }

        return new ModLoadExecutionResult(
            loadPlan,
            loadedMods,
            failedMods,
            securityBlockedMods,
            hasErrored);
    }

    private void LoadSingleMod(
        UndertaleData data,
        string modsDirectory,
        string quarantineDirectory,
        SecurityAllowlist securityAllowlist,
        ResourceChangeTracker changeTracker,
        ModInfo mod,
        ModStatus modStatus,
        List<string> loadedMods,
        List<string> failedMods,
        List<string> securityBlockedMods,
        ref bool hasErrored)
    {
        string modPath = Path.Combine(modsDirectory, Path.GetFileName(mod.modPath));
        string modDisplayName = GetModDisplayName(mod);
        string modFolderName = Path.GetFileName(mod.modPath);
        string dllPath = Path.Combine(modPath, modFolderName + ".dll");

        step($"Loading mod \"{modFolderName}\"");
        if (!File.Exists(dllPath))
        {
            error($"DLL file does not exist: {dllPath}");
            warn(options.StrictMode ? "Strict mode is enabled. Stopping mod loading." : "Relaxed mode is enabled. Skipping to next mod.");
            failedMods.Add($"{modDisplayName}: missing DLL");
            modStatus.State = "failed";
            modStatus.Error = "Missing DLL: " + dllPath;
            hasErrored = true;
            return;
        }

        Stopwatch loadStopwatch = Stopwatch.StartNew();
        SecurityScanResult securityScan = SecurityScanner.ScanMod(modPath, dllPath, securityAllowlist);
        modStatus.Security = new SecurityStatus
        {
            Hash = securityScan.ModHash,
            Result = securityScan.IsBlocked ? "blocked" : securityScan.IsAllowedByAllowlist ? "allowlisted" : "clean",
            Summary = securityScan.Summary,
            Findings = securityScan.Findings.ToList()
        };
        info($"\"{modDisplayName}\" Hash \"{securityScan.ModHash}\"");

        if (securityScan.IsBlocked)
        {
            string reason = securityScan.Summary;
            error($"Security scan blocked \"{modDisplayName}\": {reason}");
            warn($"Allowlist hash for review only: {securityScan.ModHash}");
            warn("This can be a false positive, but it is not always false. The mod was not loaded.");
            securityBlockedMods.Add($"{modDisplayName}: {reason}");
            failedMods.Add($"{modDisplayName}: blocked by security scan");
            modStatus.State = "blocked";
            modStatus.Error = "Blocked by security scan: " + reason;
            modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
            WriteQuarantineMarker(quarantineDirectory, modDisplayName, modPath, securityScan.ModHash, reason);
            return;
        }

        if (securityScan.IsAllowedByAllowlist)
        {
            warn($"Security scan found suspicious code in \"{modDisplayName}\", but its mod hash is allowlisted.");
        }

        ResourceSnapshot beforeModSnapshot = ResourceSnapshot.Capture(data);
        info("DLL: " + dllPath);
        try
        {
            InvokeModLoad(data, dllPath);
            ResourceSnapshot afterModSnapshot = ResourceSnapshot.Capture(data);
            ResourceDelta delta = changeTracker.LogChanges(modDisplayName, beforeModSnapshot, afterModSnapshot, data, info, warn);
            loadStopwatch.Stop();
            modStatus.State = "loaded";
            modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
            modStatus.ChangedResources = delta.Describe().ToList();
            if (loadStopwatch.Elapsed > options.SlowLoadWarningThreshold)
            {
                string warning = $"Mod load timeout warning: \"{modDisplayName}\" took {loadStopwatch.ElapsedMilliseconds} ms to load.";
                warn(warning);
                modStatus.Warnings.Add(warning);
            }

            success($"Loaded mod \"{modFolderName}\"");
            loadedMods.Add(modDisplayName);
        }
        catch (TargetInvocationException tie)
        {
            HandleLoadException(tie.InnerException ?? tie, modFolderName, modDisplayName, modStatus, loadStopwatch, failedMods);
            hasErrored = true;
        }
        catch (Exception ex)
        {
            HandleLoadException(ex, modFolderName, modDisplayName, modStatus, loadStopwatch, failedMods);
            hasErrored = true;
        }
    }

    private static void InvokeModLoad(UndertaleData data, string dllPath)
    {
        Assembly assembly = Assembly.LoadFrom(dllPath);
        Type[] types = assembly.GetTypes();
        if (types.Length == 0)
        {
            throw new InvalidOperationException("Assembly has no loadable types.");
        }

        Type? entryType = null;
        MethodInfo? loadMethod = null;
        foreach (Type type in types)
        {
            loadMethod = type.GetMethod("Load");
            if (loadMethod is not null)
            {
                entryType = type;
                break;
            }
        }

        if (entryType is null || loadMethod is null)
        {
            throw new InvalidOperationException("Mod does not expose a public Load method.");
        }

        object? instance = Activator.CreateInstance(entryType);
        if (instance is null)
        {
            throw new InvalidOperationException("Could not create mod entry point instance.");
        }

        loadMethod.Invoke(instance, new object[] { 0, data });
    }

    private void HandleLoadException(
        Exception exception,
        string modFolderName,
        string modDisplayName,
        ModStatus modStatus,
        Stopwatch loadStopwatch,
        List<string> failedMods)
    {
        error($"Error while loading \"{modFolderName}\": {exception.Message}");
        error($"This mod caused the patch failure: {modDisplayName}");
        plain(exception.StackTrace ?? "");
        warn(options.StrictMode ? "Strict mode is enabled. Stopping mod loading." : "Relaxed mode is enabled. Skipping to next mod.");
        failedMods.Add($"{modDisplayName}: {exception.Message}");
        loadStopwatch.Stop();
        modStatus.State = "failed";
        modStatus.Error = exception.Message;
        modStatus.StackTrace = exception.StackTrace ?? "";
        modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
    }

    private static string GetModDisplayName(ModInfo modInfo)
    {
        if (!string.IsNullOrWhiteSpace(modInfo.modName))
        {
            return modInfo.modName;
        }

        if (!string.IsNullOrWhiteSpace(modInfo.modPath))
        {
            return Path.GetFileName(modInfo.modPath);
        }

        return "Unknown Mod";
    }

    private static ModStatus FindStatus(IReadOnlyList<ModStatus> statuses, ModInfo modInfo) =>
        statuses.First(status => string.Equals(status.FolderName, modInfo.folderName, StringComparison.OrdinalIgnoreCase));

    private static void WriteQuarantineMarker(
        string quarantineDirectory,
        string modDisplayName,
        string modPath,
        string modHash,
        string reason)
    {
        Directory.CreateDirectory(quarantineDirectory);
        string safeName = string.Join("_", modDisplayName.Split(Path.GetInvalidFileNameChars(), StringSplitOptions.RemoveEmptyEntries));
        if (string.IsNullOrWhiteSpace(safeName))
        {
            safeName = "blocked_mod";
        }

        string markerPath = Path.Combine(quarantineDirectory, safeName + ".blocked.txt");
        File.WriteAllText(
            markerPath,
            "LOCLM blocked this mod during security scanning." + Environment.NewLine +
            "Mod: " + modDisplayName + Environment.NewLine +
            "Path: " + modPath + Environment.NewLine +
            "Hash: " + modHash + Environment.NewLine +
            "Reason: " + reason + Environment.NewLine +
            "Created UTC: " + DateTime.UtcNow.ToString("O") + Environment.NewLine);
    }
}

public sealed record ModLoadExecutionResult(
    ModLoadPlan LoadPlan,
    IReadOnlyList<string> LoadedMods,
    IReadOnlyList<string> FailedMods,
    IReadOnlyList<string> SecurityBlockedMods,
    bool HasErrored);
