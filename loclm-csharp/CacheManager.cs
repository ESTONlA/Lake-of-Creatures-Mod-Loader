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
        string modsDirectory)
    {
        StringBuilder builder = new();
        builder.AppendLine("loclm-cache-v1");
        builder.AppendLine("loader-version=" + LoaderConstants.LoaderVersion);
        builder.AppendLine("menu-injection-version=" + LoaderConstants.MenuInjectionVersion);

        AppendFileMetadata(builder, "data.win", originalDataWinPath);
        AppendFileHash(builder, "game-executable", gameExecutable);
        AppendFileHash(builder, "loader-exe", Environment.ProcessPath ?? "");
        AppendFileHash(builder, "loader-dll", Path.Combine(loclmDirectory, "loclm-csharp.dll"));
        AppendFileHash(builder, "proxy-dll", Path.Combine(Path.GetDirectoryName(originalDataWinPath) ?? "", "version.dll"));
        AppendFileHash(builder, "blacklist", Path.Combine(loclmDirectory, "blacklist.txt"));
        AppendFileHash(builder, "whitelist", Path.Combine(loclmDirectory, "whitelist.txt"));
        AppendFileHash(builder, "security-allowlist", Path.Combine(loclmDirectory, "security_allowlist.json"));
        AppendFileHash(builder, "supported-game-builds", Path.Combine(loclmDirectory, "supported_game_builds.json"));
        AppendDirectoryFingerprint(builder, "gml-assets", Path.Combine(loclmDirectory, "assets", "gml"));
        AppendDirectoryFingerprint(builder, "mods", modsDirectory);

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
        builder.AppendLine($"{label}.sha256={HashUtil.ComputeFileSha256(path)}");
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
            string relativePath = PathUtil.NormalizeRelativePath(Path.GetRelativePath(directory, file));
            builder.AppendLine($"{label}.file={relativePath}");
            AppendFileHash(builder, $"{label}.{relativePath}", file);
        }
    }
}
