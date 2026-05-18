using System.Text;
using System.Text.Json;

public static class CacheManager
{
    public static bool IsCacheValid(string outputDataWinPath, string cacheManifestPath, string cacheFingerprint, Action<string> warn)
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
            warn($"Could not read cache manifest: {ex.Message}");
            return false;
        }
    }

    public static void WriteCacheManifest(string cacheManifestPath, string cacheFingerprint, Action<string> info)
    {
        CacheManifest manifest = new()
        {
            loaderVersion = LoaderConstants.LoaderVersion,
            injectionVersion = LoaderConstants.MenuInjectionVersion,
            fingerprint = cacheFingerprint,
            createdUtc = DateTime.UtcNow.ToString("O")
        };
        File.WriteAllText(cacheManifestPath, JsonSerializer.Serialize(manifest, JsonUtil.IndentedOptions));
        info($"Wrote cache manifest: {cacheManifestPath}");
    }

    public static string BuildCacheFingerprint(
        string originalDataWinPath,
        string gameExecutable,
        string loclmDirectory,
        string modsDirectory,
        FileHashCache? hashCache = null)
    {
        StringBuilder builder = new();
        builder.AppendLine("loclm-cache-v1");
        builder.AppendLine("loader-version=" + LoaderConstants.LoaderVersion);
        builder.AppendLine("menu-injection-version=" + LoaderConstants.MenuInjectionVersion);
        builder.AppendLine("logs=excluded");

        AppendFileMetadata(builder, "data.win", originalDataWinPath);
        AppendFileHash(builder, "game-executable", gameExecutable, hashCache);
        AppendFileHash(builder, "loader-exe", Environment.ProcessPath ?? "", hashCache);
        AppendFileHash(builder, "loader-dll", Path.Combine(loclmDirectory, "loclm-csharp.dll"), hashCache);
        AppendFileHash(builder, "proxy-dll", Path.Combine(Path.GetDirectoryName(originalDataWinPath) ?? "", "version.dll"), hashCache);
        AppendFileHash(builder, "blacklist", Path.Combine(loclmDirectory, "blacklist.txt"), hashCache);
        AppendFileHash(builder, "whitelist", Path.Combine(loclmDirectory, "whitelist.txt"), hashCache);
        AppendFileHash(builder, "security-allowlist", Path.Combine(loclmDirectory, "security_allowlist.json"), hashCache);
        AppendFileHash(builder, "supported-game-builds", Path.Combine(loclmDirectory, "supported_game_builds.json"), hashCache);
        AppendDirectoryFingerprint(builder, "gml-assets", Path.Combine(loclmDirectory, "assets", "gml"), hashCache);
        AppendDirectoryFingerprint(builder, "mods", modsDirectory, hashCache);

        return HashUtil.ComputeStringSha256(builder.ToString());
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

    private static void AppendFileHash(StringBuilder builder, string label, string path, FileHashCache? hashCache)
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
        builder.AppendLine($"{label}.sha256={HashUtil.ComputeFileSha256(path, hashCache)}");
    }

    private static void AppendDirectoryFingerprint(StringBuilder builder, string label, string directory, FileHashCache? hashCache)
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
            string relativePath = PathUtil.NormalizeRelativePath(Path.GetRelativePath(directory, file));
            builder.AppendLine($"{label}.file={relativePath}");
            AppendFileHash(builder, $"{label}.{relativePath}", file, hashCache);
        }
    }
}
