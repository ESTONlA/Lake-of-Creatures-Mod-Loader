using System.Diagnostics;
using System.Reflection;
using System.Text.Json;

public sealed class ModLoadOptions
{
    public bool StrictMode { get; init; }
    public TimeSpan SlowLoadWarningThreshold { get; init; } = TimeSpan.FromSeconds(10);

    public static ModLoadOptions FromEnvironment()
    {
        string mode = Environment.GetEnvironmentVariable("ANTENNI_MOD_FAILURE_MODE")
            ?? Environment.GetEnvironmentVariable("LOCLM_MOD_FAILURE_MODE")
            ?? "";
        string strict = Environment.GetEnvironmentVariable("ANTENNI_STRICT_MOD_LOADING")
            ?? Environment.GetEnvironmentVariable("LOCLM_STRICT_MOD_LOADING")
            ?? "";
        return new ModLoadOptions
        {
            StrictMode = mode.Equals("strict", StringComparison.OrdinalIgnoreCase) ||
                strict.Equals("1", StringComparison.OrdinalIgnoreCase) ||
                strict.Equals("true", StringComparison.OrdinalIgnoreCase)
        };
    }
}

public sealed class GameCompatibilityInfo
{
    public string GameId { get; init; } = "";
    public string DataWinSha256 { get; init; } = "";
    public string GameExecutableSha256 { get; init; } = "";

    public static GameCompatibilityInfo Create(
        string dataWinPath,
        string gameExecutablePath,
        GameProfile? gameProfile = null,
        FileHashCache? hashCache = null) =>
        new()
        {
            GameId = gameProfile?.Id ?? GameProfile.Detect(gameExecutablePath)?.Id ?? "",
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
        FileHashCache? hashCache = null)
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
            status.ModName = mod.modName;
            status.Priority = mod.priority;
            status.TestedOn = mod.testedOn.ToList();

            string validationError = ValidateCompatibility(mod, loaderVersion, gameCompatibility);
            if (!string.IsNullOrWhiteSpace(validationError))
            {
                status.State = "skipped";
                status.CompatibilityStatus = validationError;
                warn($"Skipping \"{mod.modName}\": {validationError}");
                continue;
            }

            if (!mod.enabled)
            {
                status.State = "disabled";
                status.CompatibilityStatus = "Disabled by modinfo.json enabled=false.";
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
                warn($"Skipping \"{mod.modName}\" because it is not in whitelist.txt.");
                continue;
            }

            if (ContainsModId(blacklist, mod))
            {
                status.State = "skipped";
                status.CompatibilityStatus = "Listed in blacklist.txt.";
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

        List<ModInfo> ordered = ResolveLoadOrder(candidates, statuses, warn, error);
        return new ModLoadPlan
        {
            Mods = ordered,
            Statuses = statuses
        };
    }

    private static string ValidateCompatibility(ModInfo mod, string loaderVersion, GameCompatibilityInfo gameCompatibility)
    {
        if (!string.IsNullOrWhiteSpace(mod.minLoaderVersion) &&
            VersionRules.Compare(loaderVersion, mod.minLoaderVersion) < 0)
        {
            return $"Requires Antenni Loader >= {mod.minLoaderVersion}. Current: {loaderVersion}.";
        }

        if (!string.IsNullOrWhiteSpace(mod.maxLoaderVersion) &&
            VersionRules.Compare(loaderVersion, mod.maxLoaderVersion) > 0)
        {
            return $"Requires Antenni Loader <= {mod.maxLoaderVersion}. Current: {loaderVersion}.";
        }

        if (mod.supportedGames.Length == 0 &&
            gameCompatibility.GameId.Equals(GameProfile.OgreChambers2222.Id, StringComparison.OrdinalIgnoreCase))
        {
            return "Legacy manifest does not list Ogre Chambers 2222. Add supportedGames: [\"ogre-chambers-2222\"] or [\"*\"].";
        }

        if (mod.supportedGames.Length > 0 &&
            !mod.supportedGames.Any(game =>
                game.Equals("*", StringComparison.OrdinalIgnoreCase) ||
                game.Equals("any", StringComparison.OrdinalIgnoreCase) ||
                game.Equals(gameCompatibility.GameId, StringComparison.OrdinalIgnoreCase)))
        {
            return $"Mod does not support game profile '{gameCompatibility.GameId}'.";
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
        HashSet<string> activeIds = candidates.SelectMany(GetModIds).ToHashSet(StringComparer.OrdinalIgnoreCase);
        foreach (ModInfo mod in candidates.ToArray())
        {
            string? incompatible = mod.incompatibleWith.FirstOrDefault(activeIds.Contains);
            if (incompatible is null)
            {
                continue;
            }

            candidates.Remove(mod);
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "skipped";
            status.CompatibilityStatus = $"Incompatible with installed mod '{incompatible}'.";
            warn($"Skipping \"{mod.modName}\" because it is incompatible with \"{incompatible}\".");
        }
    }

    private static void ApplyMissingDependencies(List<ModInfo> candidates, List<ModStatus> statuses, Action<string> warn)
    {
        HashSet<string> activeIds = candidates.SelectMany(GetModIds).ToHashSet(StringComparer.OrdinalIgnoreCase);
        foreach (ModInfo mod in candidates.ToArray())
        {
            List<string> missing = mod.dependencies.Where(dependency => !activeIds.Contains(dependency)).ToList();
            if (missing.Count == 0)
            {
                continue;
            }

            candidates.Remove(mod);
            ModStatus status = RequireStatus(statuses, mod);
            status.State = "failed";
            status.CompatibilityStatus = "Missing required dependencies.";
            status.Error = "Missing dependencies: " + string.Join(", ", missing);
            warn($"Skipping \"{mod.modName}\" because required dependencies are missing: {string.Join(", ", missing)}");
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
                }
            }

            foreach (string target in mod.loadBefore)
            {
                if (byId.TryGetValue(target, out ModInfo? after) && after != mod)
                {
                    edges[mod].Add(after);
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
                string message = $"Invalid or risky DLL architecture for \"{status.ModName}\": {status.DllArchitecture}. Antenni Loader is x64.";
                warn(message);
                status.Warnings.Add(message);
            }

            if (!string.IsNullOrWhiteSpace(status.TargetFramework) &&
                !status.TargetFramework.Contains("net10.0", StringComparison.OrdinalIgnoreCase) &&
                !status.TargetFramework.Contains(".NETCoreApp,Version=v10.0", StringComparison.OrdinalIgnoreCase))
            {
                string message = $"\"{status.ModName}\" appears built for {status.TargetFramework}; Antenni Loader runs on .NET 10.";
                warn(message);
                status.Warnings.Add(message);
            }
        }
    }

    private static bool ContainsModId(IReadOnlyCollection<string> ids, ModInfo mod) =>
        GetModIds(mod).Any(modId => ids.Any(id => string.Equals(id, modId, StringComparison.OrdinalIgnoreCase)));

    private static IEnumerable<string> GetModIds(ModInfo mod)
    {
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
    public string ModName { get; set; } = "";
    public string ModPath { get; set; } = "";
    public string State { get; set; } = "unknown";
    public int Priority { get; set; }
    public string CompatibilityStatus { get; set; } = "";
    public string DllPath { get; set; } = "";
    public string DllSha256 { get; set; } = "";
    public string DllArchitecture { get; set; } = "";
    public string TargetFramework { get; set; } = "";
    public long LoadDurationMs { get; set; }
    public string Error { get; set; } = "";
    public string StackTrace { get; set; } = "";
    public List<string> Warnings { get; set; } = new();
    public List<string> TestedOn { get; set; } = new();
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
    public string Summary { get; set; } = "";
    public List<SecurityFinding> Findings { get; set; } = new();
    public List<string> SkippedLargeFiles { get; set; } = new();
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
        WriteSecurityReport(Path.Combine(loclmDirectory, "security_report.json"), loaderVersion, statuses);
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
}
