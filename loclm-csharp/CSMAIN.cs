using UndertaleModLib;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Text.Json;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UndertaleModLib.Models;

class LOCLM
{
    private const string LoaderVersion = "0.6.0-beta";

    private static bool SupportsColor => !Console.IsOutputRedirected;
    private static readonly List<string> WarningSummary = new();
    private static readonly List<string> ErrorSummary = new();

    private static void WriteColored(string text, ConsoleColor color, bool newline = true)
    {
        if (newline)
        {
            LoaderLogger.WriteRaw(text);
        }

        if (SupportsColor)
        {
            ConsoleColor previous = Console.ForegroundColor;
            Console.ForegroundColor = color;
            if (newline)
            {
                Console.WriteLine(text);
            }
            else
            {
                Console.Write(text);
            }
            Console.ForegroundColor = previous;
            return;
        }

        if (newline)
        {
            Console.WriteLine(text);
        }
        else
        {
            Console.Write(text);
        }
    }

    private static void LogBanner()
    {
        WriteColored("==================================================", ConsoleColor.DarkCyan);
        WriteColored(" LOCLM - Lake of Creatures Loader", ConsoleColor.Cyan);
        WriteColored("==================================================", ConsoleColor.DarkCyan);
    }

    private static void LogInfo(string message) => WriteColored($"[INFO] {message}", ConsoleColor.Gray);
    private static void LogStep(string message) => WriteColored($"[STEP] {message}", ConsoleColor.Cyan);
    private static void LogSuccess(string message) => WriteColored($"[ OK ] {message}", ConsoleColor.Green);
    private static void LogWarn(string message)
    {
        WarningSummary.Add(message);
        WriteColored($"[WARN] {message}", ConsoleColor.Yellow);
    }

    private static void LogError(string message)
    {
        ErrorSummary.Add(message);
        WriteColored($"[ERR ] {message}", ConsoleColor.Red);
    }
    private static void LogPlain(string message) => WriteColored(message, ConsoleColor.White);

    public static void Main(string[] args)
    {
        if (args.Length < 2)
        {
            LogBanner();
            LogError("Missing launch arguments.");
            LogInfo("Usage: loclm-csharp.exe <data.win> <game executable> [game args...]");
            return;
        }

        void handler(string e, bool isImportant)
        {
            if (isImportant)
            {
                LogError("Exception while reading data.win:");
                LogPlain(e);
            }
            return;
        }
        void handler2(string e)
        {
            //Console.WriteLine(e);
            return;
        }
        string originalDataWinPath = args[0];
        string gameExecutable = args[1];
        string loclmDirectory = AppContext.BaseDirectory;
        string dataDirectory = Path.GetDirectoryName(originalDataWinPath) ?? Directory.GetCurrentDirectory();
        string outputDataWinPath = Path.Combine(dataDirectory, "LOCLM_CACHE_data.win");
        string modsDirectory = Path.Combine(loclmDirectory, "mods");
        string logsDirectory = Path.Combine(loclmDirectory, "Logs");
        string cacheManifestPath = Path.Combine(logsDirectory, "LOCLM_CACHE_manifest.json");
        string disabledModsDirectory = Path.Combine(loclmDirectory, "disabled_mods");
        string quarantineDirectory = Path.Combine(loclmDirectory, "quarantine");
        string securityAllowlistPath = Path.Combine(loclmDirectory, "security_allowlist.json");
        string loaderLogPath = Path.Combine(logsDirectory, "LOCLM.log");
        string conflictReportPath = Path.Combine(logsDirectory, "mod_conflicts.json");
        ModLoadOptions loadOptions = ModLoadOptions.FromEnvironment();

        Directory.CreateDirectory(logsDirectory);
        LoaderLogger.Initialize(loaderLogPath, LoaderVersion);
        LogBanner();
        LogInfo($"Game executable: {gameExecutable}");
        LogInfo($"Source data.win: {originalDataWinPath}");
        LogInfo($"Output cache: {outputDataWinPath}");
        LogInfo($"Loader log: {loaderLogPath}");

        if (!File.Exists(originalDataWinPath))
        {
            LogError($"data.win was not found: {originalDataWinPath}");
            return;
        }

        if (!File.Exists(gameExecutable))
        {
            LogError($"Game executable was not found: {gameExecutable}");
            return;
        }

        if (!Directory.Exists(modsDirectory))
        {
            Directory.CreateDirectory(modsDirectory);
            LogWarn($"Created missing mods folder: {modsDirectory}");
        }
        Directory.CreateDirectory(disabledModsDirectory);
        Directory.CreateDirectory(quarantineDirectory);

        StartupDiagnostics.Run(
            originalDataWinPath,
            gameExecutable,
            loclmDirectory,
            logsDirectory,
            modsDirectory,
            LoaderVersion,
            LogInfo,
            LogWarn);

        GameCompatibilityInfo gameCompatibility = GameCompatibilityInfo.Create(originalDataWinPath, gameExecutable);
        SecurityAllowlist securityAllowlist = SecurityAllowlist.Load(securityAllowlistPath, LogWarn);
        string cacheFingerprint = BuildCacheFingerprint(originalDataWinPath, gameExecutable, loclmDirectory, modsDirectory);
        if (IsCacheValid(outputDataWinPath, cacheManifestPath, cacheFingerprint))
        {
            LogSuccess("Cache is up to date. Skipping regeneration.");
            WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, false);
            LogStep("Launching game");
            LogInfo("Executable: " + gameExecutable);
            LaunchGame(gameExecutable, outputDataWinPath, args);
            return;
        }

        LogStep("Cache is missing or outdated. Regenerating patched data.win.");

        LogStep("Opening data.win");
        LogStep($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        UndertaleData unmodifiedData;
        using (FileStream readStream = File.OpenRead(originalDataWinPath))
        {
            unmodifiedData = UndertaleIO.Read(
                readStream,
                (UndertaleReader.WarningHandlerDelegate)handler,
                (UndertaleReader.MessageHandlerDelegate)handler2);
        }

        UndertaleData data = unmodifiedData;

        LogStep("Scanning mods directory");
        LogInfo(modsDirectory);
        bool hasErrored = false;
        string[] blacklisted = {};
        string[] whitelisted = {};
        if (File.Exists(Path.Combine(loclmDirectory, "blacklist.txt")))
        {
            blacklisted = File.ReadAllLines(Path.Combine(loclmDirectory, "blacklist.txt"));
        }
        if (File.Exists(Path.Combine(loclmDirectory, "whitelist.txt")))
        {
            whitelisted = File.ReadAllLines(Path.Combine(loclmDirectory, "whitelist.txt"));
        }
        List<ModInfo> modDataList = new List<ModInfo>();
        List<string> loadedMods = new List<string>();
        List<string> failedMods = new List<string>();
        List<string> securityBlockedMods = new List<string>();
        ModLoadPlan loadPlan = ModLoadPlanner.Build(
            modsDirectory,
            disabledModsDirectory,
            LoaderVersion,
            gameCompatibility,
            whitelisted,
            blacklisted,
            LogInfo,
            LogWarn,
            LogError);
        LogInfo(loadOptions.StrictMode
            ? "Mod failure mode: strict. First load failure stops remaining mods."
            : "Mod failure mode: relaxed. Failed mods are skipped when safe.");
        modDataList.AddRange(loadPlan.Mods);
        foreach (ModStatus status in loadPlan.Statuses.Where(status => status.State is "failed" or "blocked"))
        {
            failedMods.Add($"{status.ModName}: {status.Error}".TrimEnd(':', ' '));
        }

        List<ModInfo> prioritizedModInfo = loadPlan.Mods;
        ResourceChangeTracker changeTracker = new();
        for (int i = 0; i < prioritizedModInfo.Count; i++)
        {
            if (hasErrored && loadOptions.StrictMode) break;
            string modPath =  Path.Combine(modsDirectory, Path.GetFileName(prioritizedModInfo[i].modPath));
            string modDisplayName = GetModDisplayName(prioritizedModInfo[i]);
            ModStatus modStatus = FindStatus(loadPlan.Statuses, prioritizedModInfo[i]);
            LogStep($"Loading mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
            string dllPath = Path.Combine(modPath, Path.GetFileName(prioritizedModInfo[i].modPath) + ".dll");
            if (File.Exists(dllPath))
            {
                Stopwatch loadStopwatch = Stopwatch.StartNew();
                SecurityScanResult securityScan = SecurityScanner.ScanMod(modPath, dllPath, securityAllowlist);
                modStatus.Security = new SecurityStatus
                {
                    Hash = securityScan.ModHash,
                    Result = securityScan.IsBlocked ? "blocked" : securityScan.IsAllowedByAllowlist ? "allowlisted" : "clean",
                    Summary = securityScan.Summary,
                    Findings = securityScan.Findings.ToList()
                };
                LogInfo($"\"{modDisplayName}\" Hash \"{securityScan.ModHash}\"");
                if (securityScan.IsBlocked)
                {
                    string reason = securityScan.Summary;
                    LogError($"Security scan blocked \"{modDisplayName}\": {reason}");
                    LogWarn($"Allowlist hash for review only: {securityScan.ModHash}");
                    LogWarn("This can be a false positive, but it is not always false. The mod was not loaded.");
                    securityBlockedMods.Add($"{modDisplayName}: {reason}");
                    failedMods.Add($"{modDisplayName}: blocked by security scan");
                    modStatus.State = "blocked";
                    modStatus.Error = "Blocked by security scan: " + reason;
                    modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
                    WriteQuarantineMarker(quarantineDirectory, modDisplayName, modPath, securityScan.ModHash, reason);
                    continue;
                }
                if (securityScan.IsAllowedByAllowlist)
                {
                    LogWarn($"Security scan found suspicious code in \"{GetModDisplayName(prioritizedModInfo[i])}\", but its mod hash is allowlisted.");
                }

                UndertaleData backupOfBeforeData = data;
                ResourceSnapshot beforeModSnapshot = ResourceSnapshot.Capture(data);
                LogInfo("DLL: " + dllPath);
                try
                {
                    Assembly assembly = Assembly.LoadFrom(dllPath);

                    Type[] types = assembly.GetTypes();
                    if (types.Length == 0)
                    {
                        throw new InvalidOperationException("Assembly has no loadable types.");
                    }

                    Type type = types[0];
                    MethodInfo? loadMethod = type.GetMethod("Load");
                    for (var t = 0; t < types.Length; t++)
                    {
                        if (loadMethod != null)
                        {
                            break;
                        }
                        type = types[t];
                        loadMethod = type.GetMethod("Load");
                    }
                    if (loadMethod is null)
                    {
                        throw new InvalidOperationException("Mod does not expose a public Load method.");
                    }

                    object? instanceOfType = Activator.CreateInstance(type);
                    if (instanceOfType is null)
                    {
                        throw new InvalidOperationException("Could not create mod entry point instance.");
                    }

                    LogInfo("Number of types: " + types.Length.ToString());

                    int audioGroup = 0;
                    loadMethod.Invoke(instanceOfType, new object[] { audioGroup, data });
                    ResourceSnapshot afterModSnapshot = ResourceSnapshot.Capture(data);
                    ResourceDelta delta = changeTracker.LogChanges(modDisplayName, beforeModSnapshot, afterModSnapshot, data, LogInfo, LogWarn);
                    loadStopwatch.Stop();
                    modStatus.State = "loaded";
                    modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
                    modStatus.ChangedResources = delta.Describe().ToList();
                    if (loadStopwatch.Elapsed > loadOptions.SlowLoadWarningThreshold)
                    {
                        string warning = $"Mod load timeout warning: \"{modDisplayName}\" took {loadStopwatch.ElapsedMilliseconds} ms to load.";
                        LogWarn(warning);
                        modStatus.Warnings.Add(warning);
                    }
                    LogSuccess($"Loaded mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
                    loadedMods.Add(GetModDisplayName(prioritizedModInfo[i]));
                }
                catch (TargetInvocationException tie)
                {
                    Exception e = tie.InnerException ?? tie;
                    LogError($"Error while loading \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\": {e.Message}");
                    LogError($"This mod caused the patch failure: {modDisplayName}");
                    LogPlain(e.StackTrace ?? "");
                    LogWarn(loadOptions.StrictMode ? "Strict mode is enabled. Stopping mod loading." : "Relaxed mode is enabled. Skipping to next mod.");
                    failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: {e.Message}");
                    loadStopwatch.Stop();
                    modStatus.State = "failed";
                    modStatus.Error = e.Message;
                    modStatus.StackTrace = e.StackTrace ?? "";
                    modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
                    data = backupOfBeforeData;
                    hasErrored = true;
                }
                catch (Exception ex)
                {
                    LogError($"Error while loading \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\": {ex.Message}");
                    LogError($"This mod caused the patch failure: {modDisplayName}");
                    LogPlain(ex.StackTrace ?? "");
                    LogWarn(loadOptions.StrictMode ? "Strict mode is enabled. Stopping mod loading." : "Relaxed mode is enabled. Skipping to next mod.");
                    failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: {ex.Message}");
                    loadStopwatch.Stop();
                    modStatus.State = "failed";
                    modStatus.Error = ex.Message;
                    modStatus.StackTrace = ex.StackTrace ?? "";
                    modStatus.LoadDurationMs = loadStopwatch.ElapsedMilliseconds;
                    data = backupOfBeforeData;
                    hasErrored = true;
                }
            }
            else
            {
                LogError($"DLL file does not exist: {dllPath}");
                LogWarn(loadOptions.StrictMode ? "Strict mode is enabled. Stopping mod loading." : "Relaxed mode is enabled. Skipping to next mod.");
                failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: missing DLL");
                modStatus.State = "failed";
                modStatus.Error = "Missing DLL: " + dllPath;
                hasErrored = true;
            }
        }

        ModStatusWriter.WriteAll(logsDirectory, LoaderVersion, loadOptions.StrictMode, loadPlan.Statuses);
        changeTracker.WriteReport(conflictReportPath);
        IReadOnlyList<string> modConflicts = changeTracker.BuildMenuSummaries();
        if (changeTracker.Conflicts.Count > 0)
        {
            LogWarn($"Detected {changeTracker.Conflicts.Count} possible mod conflict(s). Report: {conflictReportPath}");
        }
        else
        {
            LogSuccess($"No mod conflicts detected. Report: {conflictReportPath}");
        }

        InstallLoaderAboutButton(data, modsDirectory, loadedMods, failedMods, securityBlockedMods, modConflicts);

        if(hasErrored){
            WriteColored(
@" 

********************
There was an error during the mod loading process!
Please review the above error!

If you wish to continue launching the game, type 'y' and press enter.
This console will stay open until you type 'y' or close it manually.

If you continue to launch the game, the mods you have added may not work as expected, or even may not work at all.
********************
Continue? (type y and press Enter)
", ConsoleColor.Yellow);
            WaitForYes();
        }

        UndertaleData outputData = data;
        if (File.Exists(outputDataWinPath))
        {
            File.Delete(outputDataWinPath);
        }
        LogStep("Creating output stream");
        LogStep($"Writing modified data.win to \"{outputDataWinPath}\"...");
        using (FileStream writeStream = File.OpenWrite(outputDataWinPath))
        {
            UndertaleIO.Write(writeStream, outputData);
        }
        if (!hasErrored)
        {
            WriteCacheManifest(cacheManifestPath, cacheFingerprint);
        }
        LogSuccess("Done.");
        WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, hasErrored);
        LogStep("Launching game");
        LogInfo("Executable: " + gameExecutable);
        LaunchGame(gameExecutable, outputDataWinPath, args);
    }

    private static void WriteRunSummary(
        string logsDirectory,
        string originalDataWinPath,
        string gameExecutable,
        string outputDataWinPath,
        string cacheManifestPath,
        GameCompatibilityInfo gameCompatibility,
        bool hadPatchError)
    {
        Directory.CreateDirectory(logsDirectory);
        string summaryPath = Path.Combine(logsDirectory, "LOCLM_summary.txt");
        StringBuilder builder = new();
        builder.AppendLine("LOCLM troubleshooting summary");
        builder.AppendLine("============================");
        builder.AppendLine("Created UTC: " + DateTime.UtcNow.ToString("O"));
        builder.AppendLine("Loader version: " + LoaderVersion);
        builder.AppendLine("OS version: " + Environment.OSVersion);
        builder.AppendLine(".NET version: " + Environment.Version);
        builder.AppendLine("Install path: " + AppContext.BaseDirectory);
        builder.AppendLine("Game executable: " + gameExecutable);
        builder.AppendLine("Game exe hash: " + gameCompatibility.GameExecutableSha256);
        builder.AppendLine("data.win: " + originalDataWinPath);
        builder.AppendLine("data.win hash: " + gameCompatibility.DataWinSha256);
        builder.AppendLine("Cache file: " + outputDataWinPath);
        builder.AppendLine("Cache manifest: " + cacheManifestPath);
        builder.AppendLine("Patch error this run: " + hadPatchError);
        builder.AppendLine();
        AppendSummarySection(builder, "Warnings", WarningSummary);
        AppendSummarySection(builder, "Errors", ErrorSummary);
        builder.AppendLine("Common next steps");
        builder.AppendLine("-----------------");
        foreach (string step in BuildNextSteps())
        {
            builder.AppendLine("- " + step);
        }

        File.WriteAllText(summaryPath, builder.ToString());

        LogPlain("");
        WriteColored("LOCLM final summary", ConsoleColor.Cyan);
        LogInfo($"Support logs folder: {logsDirectory}");
        LogInfo($"Summary file: {summaryPath}");
        LogInfo($"Warnings this run: {WarningSummary.Count}");
        LogInfo($"Errors this run: {ErrorSummary.Count}");
        if (WarningSummary.Count > 0)
        {
            LogPlain("Recent warnings:");
            foreach (string warning in WarningSummary.TakeLast(5))
            {
                WriteColored("  - " + warning, ConsoleColor.Yellow);
            }
        }

        if (ErrorSummary.Count > 0)
        {
            LogPlain("Recent errors:");
            foreach (string error in ErrorSummary.TakeLast(5))
            {
                WriteColored("  - " + error, ConsoleColor.Red);
            }
            LogPlain("Next steps:");
            foreach (string step in BuildNextSteps())
            {
                LogPlain("  - " + step);
            }
        }
    }

    private static void AppendSummarySection(StringBuilder builder, string title, IReadOnlyList<string> values)
    {
        builder.AppendLine(title);
        builder.AppendLine(new string('-', title.Length));
        builder.AppendLine("Count: " + values.Count);
        foreach (string value in values)
        {
            builder.AppendLine("- " + value);
        }

        builder.AppendLine();
    }

    private static IReadOnlyList<string> BuildNextSteps()
    {
        List<string> steps = new();
        string combined = string.Join("\n", ErrorSummary.Concat(WarningSummary));
        if (combined.Contains("data.win", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Verify the game files in Steam, then delete LOCLM_CACHE_data.win and launch again.");
        }
        if (combined.Contains("version.dll", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("proxy", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Make sure version.dll is in the same folder as LakeOfCreatures.exe.");
        }
        if (combined.Contains("Missing DLL", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("dependency", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Reinstall the affected mod as a full folder, not only the mod DLL.");
        }
        if (combined.Contains("security scan", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("blocked", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Remove the blocked mod, or only allowlist its hash if you trust the mod author and understand the risk.");
        }
        if (combined.Contains(".NET", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("TargetFramework", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Install the Microsoft .NET 10 Desktop Runtime x64, then try again.");
        }
        if (combined.Contains("conflict", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Open Logs/mod_conflicts.json and test the conflicting mods one at a time.");
        }
        if (steps.Count == 0)
        {
            steps.Add("Zip the whole loclm/Logs folder and share it with the mod/loader developer.");
            steps.Add("If the game does not open at all, check loclm/Logs/LOCLM_proxy.log first.");
        }
        else
        {
            steps.Add("Zip the whole loclm/Logs folder if you need support.");
        }

        return steps;
    }

    private static void LaunchGame(string gameExecutable, string outputDataWinPath, string[] args)
    {
        if (string.Equals(Environment.GetEnvironmentVariable("LOCLM_SKIP_LAUNCH"), "1", StringComparison.Ordinal))
        {
            LogWarn("LOCLM_SKIP_LAUNCH=1 is set. Not launching the game.");
            return;
        }

        WriteColored("", ConsoleColor.White);
        WriteColored("LOCLM is ready to relaunch the game.", ConsoleColor.Yellow);
        WriteColored("Type 'y' and press Enter to continue. This window will stay open until then.", ConsoleColor.Yellow);
        WaitForYes();

        string argstring = "";
        for(int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }
        Process? process = Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
        if (process is null)
        {
            LogError("Game process did not start.");
            return;
        }

        LogSuccess($"Game process started. PID: {process.Id}");
    }

    private static void WaitForYes()
    {
        while (true)
        {
            WriteColored("> ", ConsoleColor.Yellow, false);
            string? input = Console.ReadLine();
            if (string.Equals(input?.Trim(), "y", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            LogWarn("Type 'y' and press Enter to continue.");
        }
    }

    private static bool IsCacheValid(string outputDataWinPath, string cacheManifestPath, string cacheFingerprint)
    {
        if (!File.Exists(outputDataWinPath) || !File.Exists(cacheManifestPath))
        {
            return false;
        }

        try
        {
            CacheManifest? manifest = JsonSerializer.Deserialize<CacheManifest>(File.ReadAllText(cacheManifestPath));
            return manifest?.fingerprint == cacheFingerprint;
        }
        catch (Exception ex)
        {
            LogWarn($"Could not read cache manifest: {ex.Message}");
            return false;
        }
    }

    private static void WriteCacheManifest(string cacheManifestPath, string cacheFingerprint)
    {
        CacheManifest manifest = new()
        {
            loaderVersion = LoaderVersion,
            fingerprint = cacheFingerprint,
            createdUtc = DateTime.UtcNow.ToString("O")
        };
        JsonSerializerOptions options = new() { WriteIndented = true };
        File.WriteAllText(cacheManifestPath, JsonSerializer.Serialize(manifest, options));
        LogInfo($"Wrote cache manifest: {cacheManifestPath}");
    }

    private static string BuildCacheFingerprint(
        string originalDataWinPath,
        string gameExecutable,
        string loclmDirectory,
        string modsDirectory)
    {
        StringBuilder builder = new();
        builder.AppendLine("loclm-cache-v1");
        builder.AppendLine("loader-version=" + LoaderVersion);

        AppendFileMetadata(builder, "data.win", originalDataWinPath);
        AppendFileHash(builder, "game-executable", gameExecutable);
        AppendFileHash(builder, "loader-exe", Environment.ProcessPath ?? "");
        AppendFileHash(builder, "loader-dll", Path.Combine(loclmDirectory, "loclm-csharp.dll"));
        AppendFileHash(builder, "proxy-dll", Path.Combine(Path.GetDirectoryName(originalDataWinPath) ?? "", "version.dll"));
        AppendFileHash(builder, "blacklist", Path.Combine(loclmDirectory, "blacklist.txt"));
        AppendFileHash(builder, "whitelist", Path.Combine(loclmDirectory, "whitelist.txt"));
        AppendFileHash(builder, "security-allowlist", Path.Combine(loclmDirectory, "security_allowlist.json"));
        AppendDirectoryFingerprint(builder, "gml-assets", Path.Combine(loclmDirectory, "assets", "gml"));
        AppendDirectoryFingerprint(builder, "mods", modsDirectory);

        using SHA256 sha = SHA256.Create();
        return Convert.ToHexString(sha.ComputeHash(Encoding.UTF8.GetBytes(builder.ToString())));
    }

    private static void AppendFileMetadata(StringBuilder builder, string label, string path)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        builder.AppendLine($"{label}.length={file.Length}");
        builder.AppendLine($"{label}.writeUtc={file.LastWriteTimeUtc.Ticks}");
    }

    private static void AppendFileHash(StringBuilder builder, string label, string path)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        builder.AppendLine($"{label}.length={file.Length}");
        builder.AppendLine($"{label}.sha256={ComputeFileHash(path)}");
    }

    private static void AppendDirectoryFingerprint(StringBuilder builder, string label, string directory)
    {
        if (!Directory.Exists(directory))
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        string[] files = Directory.GetFiles(directory, "*", SearchOption.AllDirectories)
            .OrderBy(path => Path.GetRelativePath(directory, path), StringComparer.OrdinalIgnoreCase)
            .ToArray();
        builder.AppendLine($"{label}.fileCount={files.Length}");
        foreach (string file in files)
        {
            string relativePath = Path.GetRelativePath(directory, file).Replace('\\', '/');
            builder.AppendLine($"{label}.file={relativePath}");
            AppendFileHash(builder, $"{label}.{relativePath}", file);
        }
    }

    private static string ComputeFileHash(string path)
    {
        using SHA256 sha = SHA256.Create();
        using FileStream stream = File.OpenRead(path);
        return Convert.ToHexString(sha.ComputeHash(stream));
    }

    private static void InstallLoaderAboutButton(
        UndertaleData data,
        string modsDirectory,
        IReadOnlyList<string> loadedMods,
        IReadOnlyList<string> failedMods,
        IReadOnlyList<string> securityBlockedMods,
        IReadOnlyList<string> modConflicts)
    {
        UndertaleGameObject buttonMenu = data.GameObjects.ByName("obj_button_menu");
        if (buttonMenu is null)
        {
            LogError("Could not find obj_button_menu; LOCLM menu button was not installed.");
            return;
        }

        UndertaleGameObject loclmButton = EnsureClonedMenuButton(data, buttonMenu);
        string loadedModsSetup = BuildGmlStringArraySetup("loclm_loaded_mods", "loclm_loaded_mod_count", loadedMods);
        string failedModsSetup = BuildGmlStringArraySetup("loclm_failed_mods", "loclm_failed_mod_count", failedMods);
        string conflictsSetup = BuildGmlStringArraySetup("loclm_mod_conflicts", "loclm_mod_conflict_count", modConflicts);
        string securityWarningTitle = securityBlockedMods.Count == 1
            ? "LOCLM blocked a suspicious mod"
            : "LOCLM blocked suspicious mods";
        string securityWarningBody = securityBlockedMods.Count == 0
            ? ""
            : BuildSecurityWarningBody(securityBlockedMods);

        UndertaleModLib.Compiler.CodeImportGroup importGroup = new(data);

        importGroup.QueueReplace(
            "gml_GlobalScript_loclm_runtime_log",
            LoadGmlAsset("runtime_logger.gml"));

        importGroup.QueueFindReplace(
            "gml_GlobalScript_main_menu_spawn_buttons",
            "btn_yy = 4;",
            LoadGmlAsset(
                "main_menu_spawn_buttons.patch.gml",
                ("__SECURITY_BLOCK_COUNT__", securityBlockedMods.Count.ToString()),
                ("__SECURITY_WARNING_TITLE__", QuoteGmlString(securityWarningTitle)),
                ("__SECURITY_WARNING_BODY__", QuoteGmlString(securityWarningBody))));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Create, data),
            LoadGmlAsset("loclm_button_create.gml"));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 0u, data),
            LoadGmlAsset("loclm_button_alarm0.gml"));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 2u, data),
            LoadGmlAsset(
                "loclm_button_alarm2.gml",
                ("__LOADED_MODS_SETUP__", loadedModsSetup),
                ("__FAILED_MODS_SETUP__", failedModsSetup),
                ("__CONFLICTS_SETUP__", conflictsSetup),
                ("__MODS_DIRECTORY__", QuoteGmlString(modsDirectory))));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
            LoadGmlAsset("loclm_button_draw.gml", ("__LOADER_VERSION__", QuoteGmlString(LoaderVersion))));

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Draw_0",
            LoadGmlAsset("main_menu_draw_security_warning.gml"));

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Step_0",
            LoadGmlAsset("main_menu_step.gml"));

        importGroup.Import();
        LogSuccess("Installed LOCLM about button clone and info panel.");
    }

    private static string LoadGmlAsset(string fileName, params (string Token, string Value)[] replacements)
    {
        string path = Path.Combine(AppContext.BaseDirectory, "assets", "gml", fileName);
        if (!File.Exists(path))
        {
            throw new FileNotFoundException("Missing LOCLM GML asset.", path);
        }

        string code = File.ReadAllText(path);
        foreach ((string token, string value) in replacements)
        {
            code = code.Replace(token, value);
        }

        return code;
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

    private static string BuildGmlStringArraySetup(string arrayName, string countName, IReadOnlyList<string> values)
    {
        string setup = $"                    global.{arrayName} = [];\n" +
            $"                    global.{countName} = {values.Count};\n";
        for (int i = 0; i < values.Count; i++)
        {
            setup += $"                    global.{arrayName}[{i}] = {QuoteGmlString(values[i])};\n";
        }

        return setup;
    }

    private static string BuildSecurityWarningBody(IReadOnlyList<string> securityBlockedMods)
    {
        string firstBlockedMod = TrimForMenu(securityBlockedMods[0], 46);
        string extra = securityBlockedMods.Count > 1
            ? $" +{securityBlockedMods.Count - 1} more"
            : "";
        return "Blocked: " + firstBlockedMod + extra +
            "\nThis can be a false positive, but it is not always false. The mod was not loaded.";
    }

    private static string TrimForMenu(string value, int maxLength)
    {
        if (value.Length <= maxLength)
        {
            return value;
        }

        return value[..Math.Max(0, maxLength - 3)] + "...";
    }

    private static string QuoteGmlString(string value) =>
        "\"" + value
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("\r", "")
            .Replace("\n", "\\n") + "\"";

    private static UndertaleGameObject EnsureClonedMenuButton(UndertaleData data, UndertaleGameObject buttonMenu)
    {
        if (data.GameObjects.ByName("obj_loclm_button") is UndertaleGameObject existingButton)
        {
            return existingButton;
        }

        UndertaleGameObject loclmButton = new()
        {
            Name = data.Strings.MakeString("obj_loclm_button"),
            ParentId = buttonMenu,
            Sprite = buttonMenu.Sprite,
            TextureMaskId = buttonMenu.TextureMaskId,
            Visible = buttonMenu.Visible,
            Managed = buttonMenu.Managed,
            Solid = buttonMenu.Solid,
            Depth = buttonMenu.Depth,
            Persistent = buttonMenu.Persistent,
            UsesPhysics = buttonMenu.UsesPhysics,
            IsSensor = buttonMenu.IsSensor,
            CollisionShape = buttonMenu.CollisionShape,
            Density = buttonMenu.Density,
            Restitution = buttonMenu.Restitution,
            Group = buttonMenu.Group,
            LinearDamping = buttonMenu.LinearDamping,
            AngularDamping = buttonMenu.AngularDamping,
            Friction = buttonMenu.Friction,
            Awake = buttonMenu.Awake,
            Kinematic = buttonMenu.Kinematic
        };

        foreach (var vertex in buttonMenu.PhysicsVertices)
        {
            loclmButton.PhysicsVertices.Add(new UndertaleGameObject.UndertalePhysicsVertex
            {
                X = vertex.X,
                Y = vertex.Y
            });
        }

        data.GameObjects.Add(loclmButton);
        return loclmButton;
    }

}
