using System.Diagnostics;
using System.Reflection;
using System.Text.Json;

public sealed class ModLoadOptions
{
    public bool StrictMode { get; init; }
    public bool SecurityWarnOnlyDeveloperMode { get; init; }
    public long SecurityScanSizeLimitBytes { get; init; } = 16 * 1024 * 1024;
    public TimeSpan SlowLoadWarningThreshold { get; init; } = TimeSpan.FromSeconds(10);

    public static ModLoadOptions FromSettings(LoaderSettings settings) =>
        new()
        {
            StrictMode = settings.StrictMode,
            SecurityWarnOnlyDeveloperMode = settings.SecurityWarnOnlyDeveloperMode,
            SecurityScanSizeLimitBytes = Math.Max(1024 * 1024, settings.SecurityScanSizeLimitBytes)
        };
}

public sealed class GameCompatibilityInfo
{
    public string DataWinSha256 { get; init; } = "";
    public string GameExecutableSha256 { get; init; } = "";

    public static GameCompatibilityInfo Create(string dataWinPath, string gameExecutablePath, FileHashCache? hashCache = null) =>
        new()
        {
            DataWinSha256 = ComputeFileHash(dataWinPath, hashCache),
            GameExecutableSha256 = ComputeFileHash(gameExecutablePath, hashCache)
        };

    public bool MatchesSupportedVersion(string version)
    {
        string normalized = version.Trim();
        if (normalized.Length == 0 ||
            normalized.Equals("*", StringComparison.OrdinalIgnoreCase) ||
            normalized.Equals("any", StringComparison.OrdinalIgnoreCase))
        {
            return true;
        }

        return DataWinSha256.StartsWith(normalized, StringComparison.OrdinalIgnoreCase) ||
            GameExecutableSha256.StartsWith(normalized, StringComparison.OrdinalIgnoreCase);
    }

    private static string ComputeFileHash(string path, FileHashCache? hashCache) => HashUtil.ComputeFileSha256(path, hashCache);
}

public sealed class ModLoadPlan
{
    public List<ModInfo> Mods { get; init; } = new();
    public List<ModStatus> Statuses { get; init; } = new();
}

public static class ModLoadPlanner
{
    public static ModLoadPlan Build(
        string modsDirectory,
        string disabledModsDirectory,
        string loaderVersion,
        GameCompatibilityInfo gameCompatibility,
        IReadOnlyCollection<string> whitelist,
        IReadOnlyCollection<string> blacklist,
        Action<string> info,
        Action<string> warn,
        Action<string> error,
        FileHashCache? hashCache = null,
        ModProfile? profile = null)
    {
        Directory.CreateDirectory(modsDirectory);
        Directory.CreateDirectory(disabledModsDirectory);

        List<ModInfo> candidates = new();
        List<ModStatus> statuses = new();

        WarnForDuplicateFolders(modsDirectory, warn);
        WarnForDisabledMods(disabledModsDirectory, info);

        foreach (string modDirectory in ModScanner.FindModDirectories(modsDirectory))
        {
            string folderName = Path.GetFileName(modDirectory);
            ModStatus status = ModStatus.Create(folderName, modDirectory);
            statuses.Add(status);

            if (File.Exists(Path.Combine(modDirectory, ".disabled")))
            {
                status.State = "disabled";
                status.CompatibilityStatus = "Disabled by .disabled marker.";
                info($"Skipping \"{folderName}\" because it has a .disabled marker.");
                continue;
            }

            ModManifestResult manifest = ModMetadataValidator.Load(modDirectory);
            if (!manifest.Success || manifest.ModInfo is null)
            {
                status.State = "failed";
                status.Error = manifest.Error ?? "invalid modinfo.json.";
                error($"Skipping mod \"{folderName}\": {status.Error}");
                continue;
            }

            ModInfo mod = manifest.ModInfo;
            foreach (string warning in mod.manifestWarnings)
            {
                status.Warnings.Add(warning);
                warn($"Manifest warning for \"{mod.modName}\": {warning}");
            }

            status.ModId = mod.id;
            status.Version = mod.version;
            status.ModName = mod.modName;
            status.Priority = mod.priority;
            status.TestedOn = mod.testedOn.ToList();
            status.Tags = mod.tags.ToList();

            string profileSkip = GetProfileSkipReason(mod, profile);
            if (!string.IsNullOrWhiteSpace(profileSkip))
            {
                status.State = "disabled";
                status.CompatibilityStatus = profileSkip;
                status.SkipReason = profileSkip;
                info($"Skipping \"{mod.modName}\" because {profileSkip}");
                continue;
            }

            string validationError = ValidateCompatibility(mod, loaderVersion, gameCompatibility);
            if (!string.IsNullOrWhiteSpace(validationError))
            {
                status.State = "skipped";
                status.CompatibilityStatus = validationError;
                status.SkipReason = validationError;
                warn($"Skipping \"{mod.modName}\": {validationError}");
                continue;
            }

            if (!mod.enabled)
            {
                status.State = "disabled";
                status.CompatibilityStatus = "Disabled by modinfo.json enabled=false.";
                status.SkipReason = status.CompatibilityStatus;
                info($"Skipping \"{mod.modName}\" because modinfo.json has enabled=false.");
                continue;
            }

            if (mod.testedOn.Length > 0 && !mod.testedOn.Any(gameCompatibility.MatchesSupportedVersion))
            {
                string message = $"\"{mod.modName}\" has not listed this game build in testedOn.";
                status.Warnings.Add(message);
                warn(message);
            }

            if (whitelist.Count != 0 && !ContainsModId(whitelist, mod))
            {
                status.State = "skipped";
                status.CompatibilityStatus = "Not in whitelist.txt.";
                status.SkipReason = status.CompatibilityStatus;
                warn($"Skipping \"{mod.modName}\" because it is not in whitelist.txt.");
                continue;
            }

            if (ContainsModId(blacklist, mod))
            {
                status.State = "skipped";
                status.CompatibilityStatus = "Listed in blacklist.txt.";
                status.SkipReason = status.CompatibilityStatus;
                warn($"Skipping \"{mod.modName}\" because it is in blacklist.txt.");
                continue;
            }

            status.State = "planned";
            status.CompatibilityStatus = "Compatible";
            status.DllPath = Path.Combine(modDirectory, folderName + ".dll");
            status.DllSha256 = File.Exists(status.DllPath) ? HashUtil.ComputeFileSha256(status.DllPath, hashCache) : "";
            status.DllArchitecture = PortableExecutableInspector.GetArchitecture(status.DllPath);
            status.TargetFramework = ModFrameworkInspector.GetTargetFramework(modDirectory, folderName);
            candidates.Add(mod);
        }

        WarnForDuplicateModNames(candidates, statuses, warn);
        WarnForPriorityConflicts(candidates, warn);
        WarnForDuplicateDllHashes(candidates, statuses, warn);
        WarnForDllCompatibility(statuses, warn);
        ApplyIncompatibilities(candidates, statuses, warn);
        ApplyMissingDependencies(candidates, statuses, warn);
        ApplyDependencyVersionRules(candidates, statuses, warn);

        List<ModInfo> ordered = ResolveLoadOrder(candidates, statuses, warn, error);
        for (int i = 0; i < ordered.Count; i++)
        {
            ModStatus status = RequireStatus(statuses, ordered[i]);
            status.LoadOrder = i + 1;
            if (status.LoadOrderReasons.Count == 0)
            {
                status.LoadOrderReasons.Add($"Priority {ordered[i].priority} with stable tie-break by mod name.");
            }
        }

        return new ModLoadPlan
        {
            Mods = ordered,
            Statuses = statuses
        };
    }

    private static string GetProfileSkipReason(ModInfo mod, ModProfile? profile)
    {
        if (profile is null)
        {
            return "";
        }

        if (profile.DisabledMods.Any(id => ContainsSingleModId(id, mod)))
        {
            return $"disabled by profile '{profile.Name}'.";
        }

        if (profile.EnabledMods.Count > 0 && !profile.EnabledMods.Any(id => ContainsSingleModId(id, mod)))
        {
            return $"not listed in active profile '{profile.Name}'.";
        }

        return "";
    }

    private static string ValidateCompatibility(ModInfo mod, string loaderVersion, GameCompatibilityInfo gameCompatibility)
    {
        if (!string.IsNullOrWhiteSpace(mod.minLoaderVersion) &&
            VersionRules.Compare(loaderVersion, mod.minLoaderVersion) < 0)
        {
            return $"Requires LOCLM >= {mod.minLoaderVersion}. Current: {loaderVersion}.";
        }

        if (!string.IsNullOrWhiteSpace(mod.maxLoaderVersion) &&
            VersionRules.Compare(loaderVersion, mod.maxLoaderVersion) > 0)
        {
            return $"Requires LOCLM <= {mod.maxLoaderVersion}. Current: {loaderVersion}.";
        }

        if (mod.supportedGameVersions.Length > 0 &&
            !mod.supportedGameVersions.Any(gameCompatibility.MatchesSupportedVersion))
        {
            return "Current game build is not listed in supportedGameVersions.";
        }

        return "";
    }

    private static void ApplyIncompatibilities(List<ModInfo> candidates, List<ModStatus> statuses, Action<string> warn)
    {
        Dictionary<string, ModInfo> active = BuildModLookup(candidates);
        foreach (ModInfo mod in candidates.ToArray())
        {
            ModDependency? incompatible = mod.incompatibleRules.FirstOrDefault(rule =>
                active.TryGetValue(rule.id, out ModInfo? other) &&
                VersionConstraint.SatisfiedBy(other.version, rule.version));
            if (incompatible is null)
            {
                continue;
            }

            candidates.Remove(mod);
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "skipped";
            string versionText = string.IsNullOrWhiteSpace(incompatible.version) ? "" : " " + incompatible.version;
            status.CompatibilityStatus = $"Incompatible with installed mod '{incompatible.id}{versionText}'.";
            status.SkipReason = status.CompatibilityStatus;
            warn($"Skipping \"{mod.modName}\" because it is incompatible with \"{incompatible.id}{versionText}\".");
        }
    }

    private static void ApplyMissingDependencies(List<ModInfo> candidates, List<ModStatus> statuses, Action<string> warn)
    {
        Dictionary<string, ModInfo> active = BuildModLookup(candidates);
        foreach (ModInfo mod in candidates.ToArray())
        {
            List<string> missing = mod.dependencyRules
                .Where(dependency => !active.ContainsKey(dependency.id))
                .Select(dependency => dependency.id)
                .ToList();
            if (missing.Count == 0)
            {
                continue;
            }

            candidates.Remove(mod);
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "failed";
            status.CompatibilityStatus = "Missing required dependencies.";
            status.Error = "Missing dependencies: " + string.Join(", ", missing);
            status.SkipReason = status.Error;
            warn($"Skipping \"{mod.modName}\" because required dependencies are missing: {string.Join(", ", missing)}");
        }
    }

    private static void ApplyDependencyVersionRules(List<ModInfo> candidates, List<ModStatus> statuses, Action<string> warn)
    {
        Dictionary<string, ModInfo> active = BuildModLookup(candidates);
        foreach (ModInfo mod in candidates.ToArray())
        {
            List<string> invalid = new();
            foreach (ModDependency dependency in mod.dependencyRules)
            {
                if (string.IsNullOrWhiteSpace(dependency.version))
                {
                    continue;
                }

                if (active.TryGetValue(dependency.id, out ModInfo? installed) &&
                    !VersionConstraint.SatisfiedBy(installed.version, dependency.version))
                {
                    invalid.Add($"{dependency.id} {dependency.version} (installed {installed.version})");
                }
            }

            if (invalid.Count == 0)
            {
                foreach (ModDependency optional in mod.optionalDependencyRules.Where(optional => !string.IsNullOrWhiteSpace(optional.version)))
                {
                    if (active.TryGetValue(optional.id, out ModInfo? installed) &&
                        !VersionConstraint.SatisfiedBy(installed.version, optional.version))
                    {
                        string warning = $"Optional dependency version mismatch: {optional.id} {optional.version} (installed {installed.version}).";
                        RequireStatus(statuses, mod).Warnings.Add(warning);
                        warn($"\"{mod.modName}\" {warning}");
                    }
                }

                continue;
            }

            candidates.Remove(mod);
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "failed";
            status.CompatibilityStatus = "Dependency version constraint failed.";
            status.Error = "Dependency version mismatch: " + string.Join(", ", invalid);
            status.SkipReason = status.Error;
            warn($"Skipping \"{mod.modName}\" because dependency version constraints failed: {string.Join(", ", invalid)}");
        }
    }

    private static List<ModInfo> ResolveLoadOrder(List<ModInfo> candidates, List<ModStatus> statuses, Action<string> warn, Action<string> error)
    {
        Dictionary<string, ModInfo> byId = new(StringComparer.OrdinalIgnoreCase);
        foreach (ModInfo mod in candidates.OrderBy(mod => mod.priority).ThenBy(mod => mod.modName, StringComparer.OrdinalIgnoreCase))
        {
            foreach (string id in GetModIds(mod))
            {
                byId.TryAdd(id, mod);
            }
        }

        Dictionary<ModInfo, HashSet<ModInfo>> edges = candidates.ToDictionary(mod => mod, _ => new HashSet<ModInfo>());
        foreach (ModInfo mod in candidates)
        {
            foreach (string dependency in mod.dependencies.Concat(mod.optionalDependencies).Concat(mod.loadAfter))
            {
                if (byId.TryGetValue(dependency, out ModInfo? before) && before != mod)
                {
                    edges[before].Add(mod);
                    RequireStatus(statuses, mod).LoadOrderReasons.Add($"Loaded after {before.modName} because of dependency/loadAfter '{dependency}'.");
                }
            }

            foreach (string target in mod.loadBefore)
            {
                if (byId.TryGetValue(target, out ModInfo? after) && after != mod)
                {
                    edges[mod].Add(after);
                    RequireStatus(statuses, after).LoadOrderReasons.Add($"Loaded after {mod.modName} because {mod.modName} declared loadBefore '{target}'.");
                }
            }
        }

        List<ModInfo> ordered = new();
        Dictionary<ModInfo, int> indegree = candidates.ToDictionary(mod => mod, _ => 0);
        foreach (HashSet<ModInfo> targets in edges.Values)
        {
            foreach (ModInfo target in targets)
            {
                indegree[target]++;
            }
        }

        PriorityQueue<ModInfo, (int Priority, string Name)> ready = new();
        foreach (ModInfo mod in candidates.Where(mod => indegree[mod] == 0))
        {
            ready.Enqueue(mod, (mod.priority, mod.modName));
        }

        while (ready.Count > 0)
        {
            ModInfo mod = ready.Dequeue();
            ordered.Add(mod);
            foreach (ModInfo target in edges[mod].OrderBy(target => target.priority).ThenBy(target => target.modName, StringComparer.OrdinalIgnoreCase))
            {
                indegree[target]--;
                if (indegree[target] == 0)
                {
                    ready.Enqueue(target, (target.priority, target.modName));
                }
            }
        }

        if (ordered.Count == candidates.Count)
        {
            return ordered;
        }

        List<ModInfo> cycleMods = candidates.Except(ordered).ToList();
        string cycle = string.Join(", ", cycleMods.Select(mod => mod.modName));
        error("Circular mod dependency/load order detected: " + cycle);
        foreach (ModInfo mod in cycleMods)
        {
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "failed";
            status.CompatibilityStatus = "Circular dependency/load order.";
            status.Error = "Circular dependency/load order involving: " + cycle;
            status.SkipReason = status.Error;
        }

        warn("Mods in the circular dependency were skipped.");
        return ordered;
    }

    private static void WarnForDuplicateFolders(string modsDirectory, Action<string> warn)
    {
        foreach (IGrouping<string, string> group in Directory.GetDirectories(modsDirectory)
                     .GroupBy(path => Path.GetFileName(path), StringComparer.OrdinalIgnoreCase)
                     .Where(group => group.Count() > 1))
        {
            warn("Duplicate mod folder names detected: " + string.Join(", ", group.Select(Path.GetFileName)));
        }
    }

    private static void WarnForDisabledMods(string disabledModsDirectory, Action<string> info)
    {
        string[] disabled = Directory.Exists(disabledModsDirectory)
            ? Directory.GetDirectories(disabledModsDirectory)
            : Array.Empty<string>();
        if (disabled.Length > 0)
        {
            info($"Found {disabled.Length} mod(s) in disabled_mods/. They will not be loaded.");
        }
    }

    private static void WarnForDuplicateModNames(List<ModInfo> mods, List<ModStatus> statuses, Action<string> warn)
    {
        foreach (IGrouping<string, ModInfo> group in mods.GroupBy(mod => mod.modName, StringComparer.OrdinalIgnoreCase).Where(group => group.Count() > 1))
        {
            string message = "Duplicate mod name detected: " + group.Key;
            warn(message);
            foreach (ModInfo mod in group)
            {
                RequireStatus(statuses, mod).Warnings.Add(message);
            }
        }
    }

    private static void WarnForPriorityConflicts(List<ModInfo> mods, Action<string> warn)
    {
        foreach (IGrouping<int, ModInfo> group in mods.GroupBy(mod => mod.priority).Where(group => group.Count() > 1))
        {
            warn($"Multiple mods use priority {group.Key}: {string.Join(", ", group.Select(mod => mod.modName))}");
        }
    }

    private static void WarnForDuplicateDllHashes(List<ModInfo> mods, List<ModStatus> statuses, Action<string> warn)
    {
        foreach (IGrouping<string, ModStatus> group in statuses
                     .Where(status => !string.IsNullOrWhiteSpace(status.DllSha256))
                     .GroupBy(status => status.DllSha256, StringComparer.OrdinalIgnoreCase)
                     .Where(group => group.Count() > 1))
        {
            string message = "Duplicate DLL hash detected: " + string.Join(", ", group.Select(status => status.ModName));
            warn(message);
            foreach (ModStatus status in group)
            {
                status.Warnings.Add(message);
            }
        }
    }

    private static void WarnForDllCompatibility(List<ModStatus> statuses, Action<string> warn)
    {
        foreach (ModStatus status in statuses.Where(status => status.State == "planned"))
        {
            if (status.DllArchitecture is "x86" or "native-unknown")
            {
                string message = $"Invalid or risky DLL architecture for \"{status.ModName}\": {status.DllArchitecture}. LOCLM is x64.";
                warn(message);
                status.Warnings.Add(message);
            }

            if (!string.IsNullOrWhiteSpace(status.TargetFramework) &&
                !status.TargetFramework.Contains("net10.0", StringComparison.OrdinalIgnoreCase) &&
                !status.TargetFramework.Contains(".NETCoreApp,Version=v10.0", StringComparison.OrdinalIgnoreCase))
            {
                string message = $"\"{status.ModName}\" appears built for {status.TargetFramework}; LOCLM runs on .NET 10.";
                warn(message);
                status.Warnings.Add(message);
            }
        }
    }

    private static bool ContainsModId(IReadOnlyCollection<string> ids, ModInfo mod) =>
        GetModIds(mod).Any(modId => ids.Any(id => string.Equals(id, modId, StringComparison.OrdinalIgnoreCase)));

    private static bool ContainsSingleModId(string id, ModInfo mod) =>
        GetModIds(mod).Any(modId => string.Equals(id, modId, StringComparison.OrdinalIgnoreCase));

    private static Dictionary<string, ModInfo> BuildModLookup(IEnumerable<ModInfo> mods)
    {
        Dictionary<string, ModInfo> lookup = new(StringComparer.OrdinalIgnoreCase);
        foreach (ModInfo mod in mods)
        {
            foreach (string id in GetModIds(mod))
            {
                if (!string.IsNullOrWhiteSpace(id))
                {
                    lookup.TryAdd(id, mod);
                }
            }
        }

        return lookup;
    }

    private static IEnumerable<string> GetModIds(ModInfo mod)
    {
        yield return mod.id;
        yield return mod.modName;
        yield return mod.folderName;
        yield return Path.GetFileName(mod.modPath);
    }

    private static ModStatus RequireStatus(List<ModStatus> statuses, ModInfo mod) =>
        statuses.First(status => string.Equals(status.FolderName, mod.folderName, StringComparison.OrdinalIgnoreCase));

}

public static class PortableExecutableInspector
{
    public static string GetArchitecture(string path)
    {
        if (!File.Exists(path))
        {
            return "missing";
        }

        try
        {
            try
            {
                _ = AssemblyName.GetAssemblyName(path);
                return "managed";
            }
            catch (BadImageFormatException)
            {
                // Fall through and inspect native PE headers.
            }

            using FileStream stream = File.OpenRead(path);
            using BinaryReader reader = new(stream);
            if (reader.ReadUInt16() != 0x5A4D)
            {
                return "not-pe";
            }

            stream.Position = 0x3C;
            int peOffset = reader.ReadInt32();
            stream.Position = peOffset;
            if (reader.ReadUInt32() != 0x00004550)
            {
                return "not-pe";
            }

            ushort machine = reader.ReadUInt16();
            return machine switch
            {
                0x8664 => "x64",
                0x014C => "x86",
                0xAA64 => "arm64",
                0x0200 => "ia64",
                _ => "native-unknown"
            };
        }
        catch
        {
            return "unknown";
        }
    }
}

public static class ModFrameworkInspector
{
    public static string GetTargetFramework(string modDirectory, string folderName)
    {
        string runtimeConfig = Path.Combine(modDirectory, folderName + ".runtimeconfig.json");
        if (File.Exists(runtimeConfig))
        {
            try
            {
                using JsonDocument document = JsonDocument.Parse(File.ReadAllText(runtimeConfig));
                if (document.RootElement.TryGetProperty("runtimeOptions", out JsonElement runtimeOptions) &&
                    runtimeOptions.TryGetProperty("tfm", out JsonElement tfm) &&
                    tfm.ValueKind == JsonValueKind.String)
                {
                    return tfm.GetString() ?? "";
                }
            }
            catch
            {
                return "invalid-runtimeconfig";
            }
        }

        string deps = Path.Combine(modDirectory, folderName + ".deps.json");
        if (File.Exists(deps))
        {
            try
            {
                using JsonDocument document = JsonDocument.Parse(File.ReadAllText(deps));
                if (document.RootElement.TryGetProperty("runtimeTarget", out JsonElement runtimeTarget) &&
                    runtimeTarget.TryGetProperty("name", out JsonElement name) &&
                    name.ValueKind == JsonValueKind.String)
                {
                    return name.GetString() ?? "";
                }
            }
            catch
            {
                return "invalid-deps";
            }
        }

        return "";
    }
}

public static class VersionRules
{
    public static int Compare(string left, string right)
    {
        int[] leftParts = Parse(left);
        int[] rightParts = Parse(right);
        for (int i = 0; i < Math.Max(leftParts.Length, rightParts.Length); i++)
        {
            int leftValue = i < leftParts.Length ? leftParts[i] : 0;
            int rightValue = i < rightParts.Length ? rightParts[i] : 0;
            int comparison = leftValue.CompareTo(rightValue);
            if (comparison != 0)
            {
                return comparison;
            }
        }

        return 0;
    }

    private static int[] Parse(string version) =>
        version.Split('-', '+')[0]
            .Split('.', StringSplitOptions.RemoveEmptyEntries)
            .Select(part => int.TryParse(part, out int value) ? value : 0)
            .ToArray();
}

public sealed class ModStatus
{
    public string FolderName { get; set; } = "";
    public string ModId { get; set; } = "";
    public string ModName { get; set; } = "";
    public string Version { get; set; } = "";
    public string ModPath { get; set; } = "";
    public string State { get; set; } = "unknown";
    public int LoadOrder { get; set; }
    public int Priority { get; set; }
    public string CompatibilityStatus { get; set; } = "";
    public string SkipReason { get; set; } = "";
    public string DllPath { get; set; } = "";
    public string DllSha256 { get; set; } = "";
    public string PreviousDllSha256 { get; set; } = "";
    public bool HashChangedSinceLastRun { get; set; }
    public string DllArchitecture { get; set; } = "";
    public string TargetFramework { get; set; } = "";
    public long LoadDurationMs { get; set; }
    public long DllLoadDurationMs { get; set; }
    public long PatchDurationMs { get; set; }
    public string Error { get; set; } = "";
    public string StackTrace { get; set; } = "";
    public List<string> Warnings { get; set; } = new();
    public List<string> TestedOn { get; set; } = new();
    public List<string> Tags { get; set; } = new();
    public List<string> LoadOrderReasons { get; set; } = new();
    public List<string> ChangedResources { get; set; } = new();
    public SecurityStatus Security { get; set; } = new();

    public static ModStatus Create(string folderName, string modPath) =>
        new()
        {
            FolderName = folderName,
            ModName = folderName,
            ModPath = modPath
        };
}

public sealed class SecurityStatus
{
    public string Hash { get; set; } = "";
    public string Result { get; set; } = "not_scanned";
    public string HighestSeverity { get; set; } = "none";
    public string Summary { get; set; } = "";
    public long ScanDurationMs { get; set; }
    public long TotalBytesScanned { get; set; }
    public bool WarnOnlyDeveloperMode { get; set; }
    public string AllowlistWarning { get; set; } = "";
    public List<SecurityFinding> Findings { get; set; } = new();
    public List<string> SkippedLargeFiles { get; set; } = new();
    public List<string> SuspiciousFiles { get; set; } = new();
    public List<string> NativeDlls { get; set; } = new();
    public List<string> NetworkStrings { get; set; } = new();
}

public sealed class ModStatusReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public bool StrictMode { get; set; }
    public List<ModStatus> Mods { get; set; } = new();
}

public sealed class SecurityReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public int ModCount { get; set; }
    public int BlockedCount { get; set; }
    public List<SecurityReportEntry> Entries { get; set; } = new();
}

public sealed class SecurityReportEntry
{
    public string FolderName { get; set; } = "";
    public string ModName { get; set; } = "";
    public string State { get; set; } = "";
    public string DllPath { get; set; } = "";
    public string DllSha256 { get; set; } = "";
    public SecurityStatus Security { get; set; } = new();
}

public sealed class SecurityFindingsReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public int FindingCount { get; set; }
    public List<SecurityFindingReportEntry> Findings { get; set; } = new();
}

public sealed class SecurityFindingReportEntry
{
    public string ModId { get; set; } = "";
    public string ModName { get; set; } = "";
    public string FolderName { get; set; } = "";
    public string ModHash { get; set; } = "";
    public string RuleId { get; set; } = "";
    public string Rule { get; set; } = "";
    public string Severity { get; set; } = "";
    public string File { get; set; } = "";
    public string Description { get; set; } = "";
    public string Evidence { get; set; } = "";
}

public static class ModStatusWriter
{
    public static void WriteAll(string loclmDirectory, string loaderVersion, bool strictMode, IReadOnlyList<ModStatus> statuses)
    {
        Directory.CreateDirectory(loclmDirectory);
        ModStatusReport report = new()
        {
            GeneratedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = loaderVersion,
            StrictMode = strictMode,
            Mods = statuses.ToList()
        };

        File.WriteAllText(Path.Combine(loclmDirectory, "mod_status.json"), JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
        WriteList(Path.Combine(loclmDirectory, "loaded_mods.json"), statuses.Where(status => status.State == "loaded"));
        WriteList(Path.Combine(loclmDirectory, "failed_mods.json"), statuses.Where(status => status.State == "failed"));
        WriteList(Path.Combine(loclmDirectory, "blocked_mods.json"), statuses.Where(status => status.State == "blocked"));
        WriteLoadOrder(Path.Combine(loclmDirectory, "load_order.json"), statuses);
        WriteResolvedMods(Path.Combine(loclmDirectory, "resolved_mods.json"), loaderVersion, statuses);
        WriteSecurityReport(Path.Combine(loclmDirectory, "security_report.json"), loaderVersion, statuses);
        WriteSecurityFindings(Path.Combine(loclmDirectory, "security_findings.json"), loaderVersion, statuses);
        SecurityScanner.WriteRuleDocumentation(Path.Combine(loclmDirectory, "security_rules.json"));
    }

    private static void WriteList(string path, IEnumerable<ModStatus> statuses) =>
        File.WriteAllText(path, JsonSerializer.Serialize(statuses.ToList(), JsonUtil.IndentedOptions));

    private static void WriteSecurityReport(string path, string loaderVersion, IReadOnlyList<ModStatus> statuses)
    {
        SecurityReport report = new()
        {
            GeneratedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = loaderVersion,
            ModCount = statuses.Count,
            BlockedCount = statuses.Count(status => status.State == "blocked"),
            Entries = statuses.Select(status => new SecurityReportEntry
            {
                FolderName = status.FolderName,
                ModName = status.ModName,
                State = status.State,
                DllPath = status.DllPath,
                DllSha256 = status.DllSha256,
                Security = status.Security
            }).ToList()
        };

        File.WriteAllText(path, JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
    }

    private static void WriteSecurityFindings(string path, string loaderVersion, IReadOnlyList<ModStatus> statuses)
    {
        List<SecurityFindingReportEntry> findings = statuses
            .SelectMany(status => status.Security.Findings.Select(finding => new SecurityFindingReportEntry
            {
                ModId = status.ModId,
                ModName = status.ModName,
                FolderName = status.FolderName,
                ModHash = status.Security.Hash,
                RuleId = finding.RuleId,
                Rule = finding.Rule,
                Severity = finding.Severity,
                File = finding.File,
                Description = finding.Description,
                Evidence = finding.Evidence
            }))
            .ToList();

        SecurityFindingsReport report = new()
        {
            GeneratedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = loaderVersion,
            FindingCount = findings.Count,
            Findings = findings
        };

        File.WriteAllText(path, JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
    }

    private static void WriteLoadOrder(string path, IReadOnlyList<ModStatus> statuses)
    {
        var report = statuses
            .Where(status => status.LoadOrder > 0)
            .OrderBy(status => status.LoadOrder)
            .Select(status => new
            {
                order = status.LoadOrder,
                id = status.ModId,
                name = status.ModName,
                version = status.Version,
                priority = status.Priority,
                reasons = status.LoadOrderReasons
            })
            .ToList();
        File.WriteAllText(path, JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
    }

    private static void WriteResolvedMods(string path, string loaderVersion, IReadOnlyList<ModStatus> statuses)
    {
        var report = new
        {
            generatedUtc = DateTime.UtcNow.ToString("O"),
            loaderVersion,
            loaded = statuses.Where(status => status.State == "loaded").ToList(),
            planned = statuses.Where(status => status.State == "planned").ToList(),
            skipped = statuses.Where(status => status.State is "skipped" or "disabled" or "failed" or "blocked")
                .Select(status => new
                {
                    status.FolderName,
                    status.ModId,
                    status.ModName,
                    status.Version,
                    status.State,
                    reason = string.IsNullOrWhiteSpace(status.SkipReason)
                        ? FirstNonEmpty(status.Error, status.CompatibilityStatus)
                        : status.SkipReason,
                    status.Warnings,
                    status.Tags
                })
                .ToList()
        };
        File.WriteAllText(path, JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
    }

    private static string FirstNonEmpty(params string[] values) =>
        values.FirstOrDefault(value => !string.IsNullOrWhiteSpace(value)) ?? "";
}
