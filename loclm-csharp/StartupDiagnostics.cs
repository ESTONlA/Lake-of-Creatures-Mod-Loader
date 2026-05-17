using System.Security.Cryptography;
using System.Text.Json;

public static class StartupDiagnostics
{
    private static readonly HashSet<string> FrameworkAssemblyPrefixes = new(StringComparer.OrdinalIgnoreCase)
    {
        "System",
        "Microsoft",
        "netstandard",
        "mscorlib",
        "WindowsBase",
        "PresentationCore",
        "PresentationFramework"
    };

    private static readonly HashSet<string> KnownLoaderDependencies = new(StringComparer.OrdinalIgnoreCase)
    {
        "ICSharpCode.SharpZipLib",
        "Magick.NET.Core",
        "Magick.NET-Q8-AnyCPU",
        "PropertyChanged",
        "Underanalyzer",
        "UndertaleModLib"
    };

    public static void Run(
        string originalDataWinPath,
        string gameExecutable,
        string loclmDirectory,
        string logsDirectory,
        string modsDirectory,
        string loaderVersion,
        Action<string> info,
        Action<string> warn)
    {
        WarnForInstallLayout(originalDataWinPath, gameExecutable, loclmDirectory, warn);
        WarnForGameUpdate(originalDataWinPath, gameExecutable, logsDirectory, loaderVersion, info, warn);
        WarnForDuplicateModDlls(modsDirectory, warn);
        WarnForMissingModDependencies(modsDirectory, loclmDirectory, warn);
        WarnForBlockedFiles(modsDirectory, warn);
    }

    private static void WarnForInstallLayout(
        string originalDataWinPath,
        string gameExecutable,
        string loclmDirectory,
        Action<string> warn)
    {
        string gameDirectory = Path.GetFullPath(Path.GetDirectoryName(gameExecutable) ?? "");
        string dataDirectory = Path.GetFullPath(Path.GetDirectoryName(originalDataWinPath) ?? "");
        string loclmFullPath = Path.GetFullPath(loclmDirectory)
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);

        if (!string.Equals(gameDirectory, dataDirectory, StringComparison.OrdinalIgnoreCase))
        {
            warn($"LOCLM launch paths look wrong. Game EXE folder is '{gameDirectory}', but data.win folder is '{dataDirectory}'.");
        }

        if (!string.Equals(Path.GetFileName(loclmFullPath), "loclm", StringComparison.OrdinalIgnoreCase))
        {
            warn($"LOCLM appears to be installed in the wrong folder. Expected a folder named 'loclm', got '{loclmFullPath}'.");
        }

        string expectedLoclmParent = Path.GetFullPath(Path.Combine(gameDirectory, "loclm"))
            .TrimEnd(Path.DirectorySeparatorChar, Path.AltDirectorySeparatorChar);
        if (!string.Equals(loclmFullPath, expectedLoclmParent, StringComparison.OrdinalIgnoreCase))
        {
            warn($"LOCLM folder is not inside the game folder. Expected '{expectedLoclmParent}', got '{loclmFullPath}'.");
        }

        string proxyPath = Path.Combine(gameDirectory, "version.dll");
        if (!File.Exists(proxyPath))
        {
            warn($"version.dll is not next to LakeOfCreatures.exe. Expected: {proxyPath}");
        }

        string executableName = Path.GetFileName(gameExecutable);
        if (!string.Equals(executableName, "LakeOfCreatures.exe", StringComparison.OrdinalIgnoreCase))
        {
            warn($"Steam or the proxy launched an unexpected executable: {executableName}. Expected LakeOfCreatures.exe.");
        }
    }

    private static void WarnForGameUpdate(
        string originalDataWinPath,
        string gameExecutable,
        string logsDirectory,
        string loaderVersion,
        Action<string> info,
        Action<string> warn)
    {
        string baselinePath = Path.Combine(logsDirectory, "game_baseline.json");
        GameBaseline current = new()
        {
            loaderVersion = loaderVersion,
            dataWinPath = originalDataWinPath,
            dataWinLength = new FileInfo(originalDataWinPath).Length,
            dataWinSha256 = ComputeFileHash(originalDataWinPath),
            gameExecutablePath = gameExecutable,
            gameExecutableLength = new FileInfo(gameExecutable).Length,
            gameExecutableSha256 = ComputeFileHash(gameExecutable),
            updatedUtc = DateTime.UtcNow.ToString("O")
        };

        try
        {
            if (File.Exists(baselinePath))
            {
                GameBaseline? previous = JsonSerializer.Deserialize<GameBaseline>(File.ReadAllText(baselinePath));
                if (previous is not null &&
                    (!string.Equals(previous.dataWinSha256, current.dataWinSha256, StringComparison.OrdinalIgnoreCase) ||
                     !string.Equals(previous.gameExecutableSha256, current.gameExecutableSha256, StringComparison.OrdinalIgnoreCase)))
                {
                    warn("Lake of Creatures appears to have updated since the last LOCLM run. Mods may break until they are updated.");
                    warn("LOCLM will regenerate the cache automatically, but mod compatibility is not guaranteed after game updates.");
                }
            }
            else
            {
                info("Created game baseline for future update detection.");
            }

            JsonSerializerOptions options = new() { WriteIndented = true };
            File.WriteAllText(baselinePath, JsonSerializer.Serialize(current, options));
        }
        catch (Exception ex)
        {
            warn($"Could not update game baseline: {ex.Message}");
        }
    }

    private static void WarnForDuplicateModDlls(string modsDirectory, Action<string> warn)
    {
        if (!Directory.Exists(modsDirectory))
        {
            return;
        }

        Dictionary<string, List<string>> mainDllsByHash = new(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, List<string>> mainDllsByName = new(StringComparer.OrdinalIgnoreCase);

        foreach (string modDirectory in Directory.GetDirectories(modsDirectory))
        {
            string folderName = Path.GetFileName(modDirectory);
            string expectedMainDll = Path.Combine(modDirectory, folderName + ".dll");
            if (!File.Exists(expectedMainDll))
            {
                continue;
            }

            string displayPath = Path.GetRelativePath(modsDirectory, expectedMainDll).Replace('\\', '/');
            AddGrouped(mainDllsByHash, ComputeFileHash(expectedMainDll), displayPath);
            AddGrouped(mainDllsByName, Path.GetFileName(expectedMainDll), displayPath);
        }

        foreach ((string _, List<string> paths) in mainDllsByHash.Where(pair => pair.Value.Count > 1))
        {
            warn("Duplicate mod DLL content detected: " + string.Join(", ", paths));
        }

        foreach ((string fileName, List<string> paths) in mainDllsByName.Where(pair => pair.Value.Count > 1))
        {
            warn($"Multiple mods use the same main DLL filename '{fileName}': {string.Join(", ", paths)}");
        }
    }

    private static void WarnForMissingModDependencies(string modsDirectory, string loclmDirectory, Action<string> warn)
    {
        if (!Directory.Exists(modsDirectory))
        {
            return;
        }

        foreach (string depsPath in Directory.GetFiles(modsDirectory, "*.deps.json", SearchOption.AllDirectories))
        {
            string modDirectory = Path.GetDirectoryName(depsPath) ?? modsDirectory;
            string relativeDeps = Path.GetRelativePath(modsDirectory, depsPath).Replace('\\', '/');

            try
            {
                foreach (string dependencyFileName in ReadRuntimeDependencyFileNames(depsPath))
                {
                    if (ShouldIgnoreDependency(Path.GetFileNameWithoutExtension(dependencyFileName)))
                    {
                        continue;
                    }

                    if (DependencyExists(dependencyFileName, modDirectory, loclmDirectory))
                    {
                        continue;
                    }

                    warn($"Possible missing dependency from '{relativeDeps}': {dependencyFileName}");
                }
            }
            catch (Exception ex)
            {
                warn($"Could not inspect dependency file '{relativeDeps}': {ex.Message}");
            }
        }
    }

    private static IEnumerable<string> ReadRuntimeDependencyFileNames(string depsPath)
    {
        using JsonDocument document = JsonDocument.Parse(File.ReadAllText(depsPath));
        if (!document.RootElement.TryGetProperty("targets", out JsonElement targets) ||
            targets.ValueKind != JsonValueKind.Object)
        {
            yield break;
        }

        foreach (JsonProperty target in targets.EnumerateObject())
        {
            if (target.Value.ValueKind != JsonValueKind.Object)
            {
                continue;
            }

            foreach (JsonProperty library in target.Value.EnumerateObject())
            {
                if (library.Value.ValueKind != JsonValueKind.Object ||
                    !library.Value.TryGetProperty("runtime", out JsonElement runtime) ||
                    runtime.ValueKind != JsonValueKind.Object)
                {
                    continue;
                }

                foreach (JsonProperty runtimeAsset in runtime.EnumerateObject())
                {
                    string fileName = Path.GetFileName(runtimeAsset.Name.Replace('/', Path.DirectorySeparatorChar));
                    if (fileName.EndsWith(".dll", StringComparison.OrdinalIgnoreCase))
                    {
                        yield return fileName;
                    }
                }
            }
        }
    }

    private static void WarnForBlockedFiles(string modsDirectory, Action<string> warn)
    {
        if (!Directory.Exists(modsDirectory) || !OperatingSystem.IsWindows())
        {
            return;
        }

        string[] extensions = { ".dll", ".exe", ".json", ".gml" };
        foreach (string filePath in Directory.GetFiles(modsDirectory, "*", SearchOption.AllDirectories)
                     .Where(path => extensions.Contains(Path.GetExtension(path), StringComparer.OrdinalIgnoreCase)))
        {
            if (!HasZoneIdentifier(filePath))
            {
                continue;
            }

            string relativePath = Path.GetRelativePath(modsDirectory, filePath).Replace('\\', '/');
            warn($"Windows marked this mod file as downloaded/blocked: {relativePath}. If the mod is trusted, unblock it in file Properties.");
        }
    }

    private static bool ShouldIgnoreDependency(string referenceName)
    {
        if (KnownLoaderDependencies.Contains(referenceName))
        {
            return true;
        }

        return FrameworkAssemblyPrefixes.Any(prefix =>
            referenceName.Equals(prefix, StringComparison.OrdinalIgnoreCase) ||
            referenceName.StartsWith(prefix + ".", StringComparison.OrdinalIgnoreCase));
    }

    private static bool DependencyExists(string dependencyFileName, string dllDirectory, string loclmDirectory)
    {
        string[] searchDirectories =
        {
            dllDirectory,
            loclmDirectory,
            AppContext.BaseDirectory
        };

        return searchDirectories.Any(directory => File.Exists(Path.Combine(directory, dependencyFileName)));
    }

    private static bool HasZoneIdentifier(string filePath)
    {
        try
        {
            using FileStream stream = File.Open(filePath + ":Zone.Identifier", FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            return stream.Length > 0;
        }
        catch
        {
            return false;
        }
    }

    private static void AddGrouped(Dictionary<string, List<string>> groups, string key, string value)
    {
        if (!groups.TryGetValue(key, out List<string>? values))
        {
            values = new List<string>();
            groups[key] = values;
        }

        values.Add(value);
    }

    private static string ComputeFileHash(string path)
    {
        using SHA256 sha = SHA256.Create();
        using FileStream stream = File.OpenRead(path);
        return Convert.ToHexString(sha.ComputeHash(stream));
    }
}

public sealed class GameBaseline
{
    public string loaderVersion { get; set; } = "";
    public string dataWinPath { get; set; } = "";
    public long dataWinLength { get; set; }
    public string dataWinSha256 { get; set; } = "";
    public string gameExecutablePath { get; set; } = "";
    public long gameExecutableLength { get; set; }
    public string gameExecutableSha256 { get; set; } = "";
    public string updatedUtc { get; set; } = "";
}
