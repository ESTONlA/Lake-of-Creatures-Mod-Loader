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
        Run("dependency detection skips missing dependency", DependencyDetectionSkipsMissingDependency);
        Run("install layout detects mismatched game/data folders", InstallLayoutDetectsWrongFolder);
        Run("game profiles detect both supported games", GameProfilesDetectSupportedGames);
        Run("game profiles reject unsupported executable", GameProfilesRejectUnsupportedExecutable);
        Run("Ogre rejects legacy and Lake-only mods", OgreRejectsUnsupportedMods);
        Run("Ogre accepts explicitly supported mods", OgreAcceptsSupportedMods);
        Run("cache output validation rejects empty file", CacheOutputValidationRejectsEmptyFile);
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
        string loaderDirectory = Directory.CreateDirectory(Path.Combine(temp.Path, "antenni")).FullName;
        string mods = Directory.CreateDirectory(Path.Combine(loaderDirectory, "mods")).FullName;
        string mod = Directory.CreateDirectory(Path.Combine(mods, "ModA")).FullName;
        WriteFile(mod, "ModA.dll", "one");

        string first = CacheManager.BuildCacheFingerprint(data, exe, loaderDirectory, mods, GameProfile.LakeOfCreatures);
        WriteFile(mod, "ModA.dll", "two");
        string second = CacheManager.BuildCacheFingerprint(data, exe, loaderDirectory, mods, GameProfile.LakeOfCreatures);
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

    private static void InstallLayoutDetectsWrongFolder()
    {
        using TempDir temp = new();
        string dataFolder = Directory.CreateDirectory(Path.Combine(temp.Path, "data-folder")).FullName;
        string exeFolder = Directory.CreateDirectory(Path.Combine(temp.Path, "exe-folder")).FullName;
        string data = WriteFile(dataFolder, "data.win", "data");
        string exe = WriteFile(exeFolder, "LakeOfCreatures.exe", "exe");
        LoaderConfig config = LoaderConfig.Create(new[] { data, exe }, Path.Combine(temp.Path, "antenni")).Value!;

        LoaderResult result = InstallValidator.Validate(config);
        AssertFalse(result.Success, "different data/exe folder should fail");
        AssertEqual("wrong_game_folder", result.Error?.Code, "wrong folder code should be stable");
    }

    private static void CacheOutputValidationRejectsEmptyFile()
    {
        using TempDir temp = new();
        string cachePath = WriteFile(temp.Path, "ANTENNI_CACHE_data.win", "");
        LoaderResult result = new GamePatcher().ValidateWrittenDataWin(cachePath);
        AssertFalse(result.Success, "empty generated cache should fail validation");
        AssertEqual("empty_cache_output", result.Error?.Code, "empty cache error code should be stable");
    }

    private static void GameProfilesDetectSupportedGames()
    {
        AssertEqual(
            GameProfile.LakeOfCreatures.Id,
            GameProfile.Detect(@"C:\Games\LakeOfCreatures.exe")?.Id,
            "Lake of Creatures profile should be detected");
        AssertEqual(
            GameProfile.OgreChambers2222.Id,
            GameProfile.Detect(@"C:\Games\ogre chambers 2.exe")?.Id,
            "Ogre Chambers 2222 profile should be detected");
    }

    private static void GameProfilesRejectUnsupportedExecutable()
    {
        LoaderResult<LoaderConfig> result = LoaderConfig.Create(
            new[] { @"C:\Games\data.win", @"C:\Games\unknown.exe" },
            @"C:\Games\antenni");
        AssertFalse(result.Success, "unknown executables should be rejected");
        AssertEqual("unsupported_game", result.Error?.Code, "unsupported game code should be stable");
    }

    private static void OgreRejectsUnsupportedMods()
    {
        using TempDir temp = new();
        string mods = Directory.CreateDirectory(Path.Combine(temp.Path, "mods")).FullName;
        string disabled = Directory.CreateDirectory(Path.Combine(temp.Path, "disabled_mods")).FullName;
        CreateMod(mods, "LegacyMod", "Legacy Mod");
        CreateMod(mods, "LakeMod", "Lake Mod", supportedGames: new[] { GameProfile.LakeOfCreatures.Id });

        ModLoadPlan plan = ModLoadPlanner.Build(
            mods,
            disabled,
            LoaderConstants.LoaderVersion,
            CreateCompatibility(temp.Path, GameProfile.OgreChambers2222),
            Array.Empty<string>(),
            Array.Empty<string>(),
            _ => { },
            _ => { },
            _ => { });

        AssertEqual(0, plan.Mods.Count, "Ogre should reject mods that do not declare Ogre support");
        AssertEqual(2, plan.Statuses.Count(status => status.State == "skipped"), "both unsupported mods should be skipped");
    }

    private static void OgreAcceptsSupportedMods()
    {
        using TempDir temp = new();
        string mods = Directory.CreateDirectory(Path.Combine(temp.Path, "mods")).FullName;
        string disabled = Directory.CreateDirectory(Path.Combine(temp.Path, "disabled_mods")).FullName;
        CreateMod(mods, "OgreMod", "Ogre Mod", supportedGames: new[] { GameProfile.OgreChambers2222.Id });

        ModLoadPlan plan = ModLoadPlanner.Build(
            mods,
            disabled,
            LoaderConstants.LoaderVersion,
            CreateCompatibility(temp.Path, GameProfile.OgreChambers2222),
            Array.Empty<string>(),
            Array.Empty<string>(),
            _ => { },
            _ => { },
            _ => { });

        AssertEqual(1, plan.Mods.Count, "explicitly compatible Ogre mod should be planned");
        AssertEqual("Ogre Mod", plan.Mods[0].modName, "planned Ogre mod should be preserved");
    }

    private static void ZipPackagingScriptValidatesSupportedBuildFile()
    {
        string script = File.ReadAllText(Path.Combine(RepositoryRoot(), "scripts", "build-release.ps1"));
        AssertContains(script, "supported_game_builds.json", "release script should include supported_game_builds.json");
        AssertContains(script, "antenni/supported_game_builds.json", "zip validation should include supported build list");
    }

    private static string CreateMod(
        string modsRoot,
        string folderName,
        string modName,
        string[]? dependencies = null,
        string[]? supportedGames = null)
    {
        string mod = Directory.CreateDirectory(Path.Combine(modsRoot, folderName)).FullName;
        WriteFile(mod, folderName + ".dll", "fake dll");
        string manifest = JsonSerializer.Serialize(new
        {
            modName,
            authors = new[] { "Tester" },
            description = "Test mod",
            priority = 100,
            dependencies = dependencies ?? Array.Empty<string>(),
            supportedGames = supportedGames ?? Array.Empty<string>()
        });
        WriteFile(mod, "modinfo.json", manifest);
        return mod;
    }

    private static GameCompatibilityInfo CreateCompatibility(string root, GameProfile? gameProfile = null)
    {
        string data = WriteFile(root, "compat-data.win", "data");
        string exeName = gameProfile?.ExecutableName ?? "compat.exe";
        string exe = WriteFile(root, exeName, "exe");
        return GameCompatibilityInfo.Create(data, exe, gameProfile);
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
            Path = System.IO.Path.Combine(System.IO.Path.GetTempPath(), "antenni-tests-" + Guid.NewGuid().ToString("N"));
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
