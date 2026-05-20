using System.IO.Compression;
using System.Text.Json;

public static class Program
{
    private static readonly List<string> Failures = new();

    public static int Main()
    {
        Run("metadata validation rejects missing modinfo", MetadataValidationRejectsMissingManifest);
        Run("metadata validation accepts valid mod folder", MetadataValidationAcceptsValidModFolder);
        Run("cache fingerprint changes when mod file changes", CacheFingerprintChangesWhenModFileChanges);
        Run("file hash cache persists hashes", FileHashCachePersistsHashes);
        Run("security allowlist parses hashes", SecurityAllowlistParsesHashes);
        Run("security allowlist parses metadata", SecurityAllowlistParsesMetadata);
        Run("security scanner reports rule severity", SecurityScannerReportsRuleSeverity);
        Run("dependency detection skips missing dependency", DependencyDetectionSkipsMissingDependency);
        Run("dependency version constraint skips incompatible version", DependencyVersionConstraintSkipsIncompatibleVersion);
        Run("manifest warnings include unknown fields", ManifestWarningsIncludeUnknownFields);
        Run("profile disables mod by id", ProfileDisablesModById);
        Run("install layout detects mismatched game/data folders", InstallLayoutDetectsWrongFolder);
        Run("cache output validation rejects empty file", CacheOutputValidationRejectsEmptyFile);
        Run("loader keeps menu patch path when no mods are active", LoaderKeepsMenuPatchPathWhenNoModsAreActive);
        Run("loader config creates defaults and applies flags", LoaderConfigCreatesDefaultsAndAppliesFlags);
        Run("command line separates loader flags from game args", CommandLineSeparatesLoaderFlagsFromGameArgs);
        Run("cache rollback restores last known good", CacheRollbackRestoresLastKnownGood);
        Run("zip packaging script validates supported build file", ZipPackagingScriptValidatesSupportedBuildFile);

        if (Failures.Count == 0)
        {
            Console.WriteLine("All tests passed.");
            return 0;
        }

        Console.Error.WriteLine("Tests failed:");
        foreach (string failure in Failures)
        {
            Console.Error.WriteLine("- " + failure);
        }

        return 1;
    }

    private static void Run(string name, Action test)
    {
        try
        {
            test();
            Console.WriteLine("[PASS] " + name);
        }
        catch (Exception ex)
        {
            Failures.Add(name + ": " + ex.Message);
            Console.WriteLine("[FAIL] " + name);
        }
    }

    private static void MetadataValidationRejectsMissingManifest()
    {
        using TempDir temp = new();
        string mod = Directory.CreateDirectory(Path.Combine(temp.Path, "MissingManifest")).FullName;
        ModManifestResult result = ModMetadataValidator.Load(mod);
        AssertFalse(result.Success, "missing modinfo should fail");
        AssertContains(result.Error ?? "", "missing modinfo", "error should mention missing modinfo");
    }

    private static void MetadataValidationAcceptsValidModFolder()
    {
        using TempDir temp = new();
        string mod = CreateMod(temp.Path, "GoodMod", "Good Mod");
        ModManifestResult result = ModMetadataValidator.Load(mod);
        AssertTrue(result.Success, "valid mod should pass");
        AssertEqual("Good Mod", result.ModInfo?.modName, "modName should deserialize");
    }

    private static void CacheFingerprintChangesWhenModFileChanges()
    {
        using TempDir temp = new();
        string data = WriteFile(temp.Path, "data.win", "data");
        string exe = WriteFile(temp.Path, "LakeOfCreatures.exe", "exe");
        string loclm = Directory.CreateDirectory(Path.Combine(temp.Path, "loclm")).FullName;
        string mods = Directory.CreateDirectory(Path.Combine(loclm, "mods")).FullName;
        string mod = Directory.CreateDirectory(Path.Combine(mods, "ModA")).FullName;
        WriteFile(mod, "ModA.dll", "one");

        string first = CacheManager.BuildCacheFingerprint(data, exe, loclm, mods);
        WriteFile(mod, "ModA.dll", "two");
        string second = CacheManager.BuildCacheFingerprint(data, exe, loclm, mods);
        AssertNotEqual(first, second, "fingerprint should change when mod file changes");
    }

    private static void FileHashCachePersistsHashes()
    {
        using TempDir temp = new();
        string file = WriteFile(temp.Path, "large.bin", new string('x', 4096));
        string cachePath = Path.Combine(temp.Path, "file_hash_cache.json");

        FileHashCache first = FileHashCache.Load(cachePath, _ => { });
        string firstHash = first.GetSha256(file);
        first.Save(_ => { });

        FileHashCache second = FileHashCache.Load(cachePath, _ => { });
        string secondHash = second.GetSha256(file);
        AssertEqual(firstHash, secondHash, "persisted file hash should be reused for unchanged file metadata");
    }

    private static void SecurityAllowlistParsesHashes()
    {
        using TempDir temp = new();
        string hash = new string('A', 64);
        string allowlistPath = WriteFile(temp.Path, "security_allowlist.json", JsonSerializer.Serialize(new
        {
            allowedModHashes = new[] { hash.ToLowerInvariant() }
        }));

        SecurityAllowlist allowlist = SecurityAllowlist.Load(allowlistPath, _ => { });
        AssertTrue(allowlist.Allows(hash), "allowlist should match normalized hash");
    }

    private static void SecurityAllowlistParsesMetadata()
    {
        using TempDir temp = new();
        string hash = new string('B', 64);
        string allowlistPath = WriteFile(temp.Path, "security_allowlist.json", JsonSerializer.Serialize(new
        {
            allowedModHashes = new object[]
            {
                new
                {
                    hash,
                    reason = "trusted test",
                    addedBy = "tester",
                    addedUtc = "2026-05-19T00:00:00Z"
                }
            }
        }));

        SecurityAllowlist allowlist = SecurityAllowlist.Load(allowlistPath, _ => { });
        AssertTrue(allowlist.Allows(hash), "metadata allowlist entry should match hash");
        AssertEqual("trusted test", allowlist.GetEntry(hash)?.Reason, "metadata reason should load");
    }

    private static void SecurityScannerReportsRuleSeverity()
    {
        using TempDir temp = new();
        string mod = Directory.CreateDirectory(Path.Combine(temp.Path, "Suspicious")).FullName;
        WriteFile(mod, "Suspicious.dll", "System.Diagnostics.Process Process.Start cmd.exe");

        SecurityScanResult result = SecurityScanner.ScanMod(mod, Path.Combine(mod, "Suspicious.dll"), SecurityAllowlist.Empty, options: new SecurityScanOptions());
        AssertTrue(result.Findings.Any(finding => finding.RuleId == "SEC-PROC-001" && finding.Severity == "critical"), "process spawn should report critical rule id");
        AssertTrue(result.IsBlocked, "suspicious non-allowlisted mod should block");
    }

    private static void DependencyDetectionSkipsMissingDependency()
    {
        using TempDir temp = new();
        string mods = Directory.CreateDirectory(Path.Combine(temp.Path, "mods")).FullName;
        string disabled = Directory.CreateDirectory(Path.Combine(temp.Path, "disabled_mods")).FullName;
        CreateMod(mods, "NeedsOther", "Needs Other", dependencies: new[] { "OtherMod" });
        GameCompatibilityInfo compatibility = CreateCompatibility(temp.Path);

        ModLoadPlan plan = ModLoadPlanner.Build(
            mods,
            disabled,
            LoaderConstants.LoaderVersion,
            compatibility,
            Array.Empty<string>(),
            Array.Empty<string>(),
            _ => { },
            _ => { },
            _ => { });

        AssertEqual(0, plan.Mods.Count, "missing dependency should remove mod from load list");
        AssertTrue(plan.Statuses.Any(status => status.State == "failed" && status.Error.Contains("Missing dependencies")), "status should report missing dependency");
    }

    private static void DependencyVersionConstraintSkipsIncompatibleVersion()
    {
        using TempDir temp = new();
        string mods = Directory.CreateDirectory(Path.Combine(temp.Path, "mods")).FullName;
        string disabled = Directory.CreateDirectory(Path.Combine(temp.Path, "disabled_mods")).FullName;
        CreateMod(mods, "CoreMod", "Core Mod", id: "core.mod", version: "1.0.0");
        CreateMod(mods, "NeedsCore", "Needs Core", id: "needs.core", version: "1.0.0", dependencyObjects: new[] { ("core.mod", ">=2.0.0") });
        GameCompatibilityInfo compatibility = CreateCompatibility(temp.Path);

        ModLoadPlan plan = ModLoadPlanner.Build(
            mods,
            disabled,
            LoaderConstants.LoaderVersion,
            compatibility,
            Array.Empty<string>(),
            Array.Empty<string>(),
            _ => { },
            _ => { },
            _ => { });

        AssertTrue(plan.Statuses.Any(status => status.ModId == "needs.core" && status.State == "failed" && status.Error.Contains("Dependency version mismatch")), "version constraint should fail");
    }

    private static void ManifestWarningsIncludeUnknownFields()
    {
        using TempDir temp = new();
        string mod = CreateMod(temp.Path, "WarnMod", "Warn Mod", id: "warn.mod", version: "1.0.0", includeUnknownField: true);
        ModManifestResult result = ModMetadataValidator.Load(mod);
        AssertTrue(result.Success, "manifest should still load with unknown fields");
        AssertTrue(result.Warnings?.Any(warning => warning.Contains("Unknown modinfo.json field")) == true, "unknown fields should warn");
    }

    private static void ProfileDisablesModById()
    {
        using TempDir temp = new();
        string mods = Directory.CreateDirectory(Path.Combine(temp.Path, "mods")).FullName;
        string disabled = Directory.CreateDirectory(Path.Combine(temp.Path, "disabled_mods")).FullName;
        CreateMod(mods, "Profiled", "Profiled", id: "profiled.mod", version: "1.0.0");
        GameCompatibilityInfo compatibility = CreateCompatibility(temp.Path);
        ModProfile profile = new()
        {
            Name = "test",
            DisabledMods = new List<string> { "profiled.mod" }
        };

        ModLoadPlan plan = ModLoadPlanner.Build(
            mods,
            disabled,
            LoaderConstants.LoaderVersion,
            compatibility,
            Array.Empty<string>(),
            Array.Empty<string>(),
            _ => { },
            _ => { },
            _ => { },
            profile: profile);

        AssertEqual(0, plan.Mods.Count, "profile disabled mod should not be planned");
        AssertTrue(plan.Statuses.Any(status => status.State == "disabled" && status.CompatibilityStatus.Contains("profile")), "status should mention profile");
    }

    private static void InstallLayoutDetectsWrongFolder()
    {
        using TempDir temp = new();
        string dataFolder = Directory.CreateDirectory(Path.Combine(temp.Path, "data-folder")).FullName;
        string exeFolder = Directory.CreateDirectory(Path.Combine(temp.Path, "exe-folder")).FullName;
        string data = WriteFile(dataFolder, "data.win", "data");
        string exe = WriteFile(exeFolder, "LakeOfCreatures.exe", "exe");
        LoaderConfig config = LoaderConfig.Create(new[] { data, exe }, Path.Combine(temp.Path, "loclm")).Value!;

        LoaderResult result = InstallValidator.Validate(config);
        AssertFalse(result.Success, "different data/exe folder should fail");
        AssertEqual("wrong_game_folder", result.Error?.Code, "wrong folder code should be stable");
    }

    private static void CacheOutputValidationRejectsEmptyFile()
    {
        using TempDir temp = new();
        string cachePath = WriteFile(temp.Path, "LOCLM_CACHE_data.win", "");
        LoaderResult result = new GamePatcher().ValidateWrittenDataWin(cachePath);
        AssertFalse(result.Success, "empty generated cache should fail validation");
        AssertEqual("empty_cache_output", result.Error?.Code, "empty cache error code should be stable");
    }

    private static void ZipPackagingScriptValidatesSupportedBuildFile()
    {
        string script = File.ReadAllText(Path.Combine(RepositoryRoot(), "scripts", "build-release.ps1"));
        AssertContains(script, "supported_game_builds.json", "release script should include supported_game_builds.json");
        AssertContains(script, "loclm/supported_game_builds.json", "zip validation should include supported build list");
        AssertContains(script, "modinfo.schema.json", "release script should include manifest schema");
    }

    private static void LoaderKeepsMenuPatchPathWhenNoModsAreActive()
    {
        string source = File.ReadAllText(Path.Combine(RepositoryRoot(), "loclm-csharp", "CSMAIN.cs"));
        AssertContains(source, "LOCLM will still generate/use a patched cache", "no-active-mod path should keep patched cache for menu injection");
        if (source.Contains("original game data directly", StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException("loader should not launch original data.win when no mods are active because that hides the LOCLM menu");
        }
    }

    private static void LoaderConfigCreatesDefaultsAndAppliesFlags()
    {
        using TempDir temp = new();
        string configPath = Path.Combine(temp.Path, "loclm", "config.json");
        LoaderSettings settings = LoaderSettings.LoadOrCreate(configPath, repair: false, _ => { }, _ => { });
        AssertTrue(File.Exists(configPath), "config.json should be created");
        AssertFalse(settings.StrictMode, "default mode should be relaxed");

        LoaderCommandLine commandLine = LoaderCommandLine.Parse(new[] { "data.win", "game.exe", "--strict", "--quiet", "--disable-menu" });
        settings.ApplyCommandLine(commandLine);
        AssertTrue(settings.StrictMode, "--strict should enable strict mode");
        AssertTrue(settings.Quiet, "--quiet should apply");
        AssertTrue(settings.DisableInGameMenu, "--disable-menu should apply");
    }

    private static void CommandLineSeparatesLoaderFlagsFromGameArgs()
    {
        LoaderCommandLine commandLine = LoaderCommandLine.Parse(new[] { "data.win", "game.exe", "--diagnose", "-steam", "--safe-mode", "abc" });
        AssertTrue(commandLine.Diagnose, "--diagnose should be parsed");
        AssertTrue(commandLine.SafeMode, "--safe-mode should be parsed");
        AssertEqual(2, commandLine.GameArgs.Length, "unknown args should be forwarded to the game");
        AssertEqual("-steam", commandLine.GameArgs[0], "first game arg should be preserved");
        AssertEqual("abc", commandLine.GameArgs[1], "second game arg should be preserved");
    }

    private static void CacheRollbackRestoresLastKnownGood()
    {
        using TempDir temp = new();
        string data = WriteFile(temp.Path, "data.win", "data");
        string exe = WriteFile(temp.Path, "LakeOfCreatures.exe", "exe");
        string loclm = Directory.CreateDirectory(Path.Combine(temp.Path, "loclm")).FullName;
        LoaderConfig config = LoaderConfig.Create(new[] { data, exe }, loclm).Value!;
        Directory.CreateDirectory(config.LogsDirectory);
        WriteFile(config.DataDirectory, LoaderConstants.LastKnownGoodDataWinFileName, "good-cache");
        WriteFile(config.LogsDirectory, LoaderConstants.LastKnownGoodManifestFileName, "good-manifest");

        LoaderResult result = CacheManager.RollbackLastKnownGood(config);
        AssertTrue(result.Success, "rollback should succeed when backup exists");
        AssertEqual("good-cache", File.ReadAllText(config.OutputDataWinPath), "cache should be restored from last known good");
        AssertEqual("good-manifest", File.ReadAllText(config.CacheManifestPath), "manifest should be restored from last known good");
    }

    private static string CreateMod(
        string modsRoot,
        string folderName,
        string modName,
        string[]? dependencies = null,
        string id = "",
        string version = "",
        (string id, string version)[]? dependencyObjects = null,
        bool includeUnknownField = false)
    {
        string mod = Directory.CreateDirectory(Path.Combine(modsRoot, folderName)).FullName;
        WriteFile(mod, folderName + ".dll", "fake dll");
        Dictionary<string, object> manifest = new()
        {
            ["modName"] = modName,
            ["authors"] = new[] { "Tester" },
            ["description"] = "Test mod",
            ["priority"] = 100,
            ["dependencies"] = dependencyObjects is not null
                ? dependencyObjects.Select(dependency => new Dictionary<string, string>
                {
                    ["id"] = dependency.id,
                    ["version"] = dependency.version
                }).ToArray()
                : dependencies ?? Array.Empty<string>()
        };
        if (!string.IsNullOrWhiteSpace(id))
        {
            manifest["id"] = id;
        }
        if (!string.IsNullOrWhiteSpace(version))
        {
            manifest["version"] = version;
        }
        if (includeUnknownField)
        {
            manifest["mysteryField"] = true;
        }

        WriteFile(mod, "modinfo.json", JsonSerializer.Serialize(manifest));
        return mod;
    }

    private static GameCompatibilityInfo CreateCompatibility(string root)
    {
        string data = WriteFile(root, "compat-data.win", "data");
        string exe = WriteFile(root, "compat.exe", "exe");
        return GameCompatibilityInfo.Create(data, exe);
    }

    private static string WriteFile(string directory, string fileName, string contents)
    {
        Directory.CreateDirectory(directory);
        string path = Path.Combine(directory, fileName);
        File.WriteAllText(path, contents);
        return path;
    }

    private static string RepositoryRoot()
    {
        string directory = AppContext.BaseDirectory;
        while (!string.IsNullOrWhiteSpace(directory))
        {
            if (File.Exists(Path.Combine(directory, "CMakeLists.txt")) &&
                Directory.Exists(Path.Combine(directory, "loclm-csharp")))
            {
                return directory;
            }

            directory = Directory.GetParent(directory)?.FullName ?? "";
        }

        throw new InvalidOperationException("Could not find repository root.");
    }

    private static void AssertTrue(bool condition, string message)
    {
        if (!condition)
        {
            throw new InvalidOperationException(message);
        }
    }

    private static void AssertFalse(bool condition, string message) => AssertTrue(!condition, message);

    private static void AssertEqual<T>(T expected, T actual, string message)
    {
        if (!EqualityComparer<T>.Default.Equals(expected, actual))
        {
            throw new InvalidOperationException($"{message}. Expected '{expected}', got '{actual}'.");
        }
    }

    private static void AssertNotEqual<T>(T first, T second, string message)
    {
        if (EqualityComparer<T>.Default.Equals(first, second))
        {
            throw new InvalidOperationException(message);
        }
    }

    private static void AssertContains(string value, string expected, string message)
    {
        if (!value.Contains(expected, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException(message);
        }
    }

    private sealed class TempDir : IDisposable
    {
        public TempDir()
        {
            Path = System.IO.Path.Combine(System.IO.Path.GetTempPath(), "loclm-tests-" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(Path);
        }

        public string Path { get; }

        public void Dispose()
        {
            if (Directory.Exists(Path))
            {
                Directory.Delete(Path, recursive: true);
            }
        }
    }
}
