public sealed class LoaderConfig
{
    private LoaderConfig(string[] args, string loclmDirectory)
    {
        Args = args;
        OriginalDataWinPath = args[0];
        GameExecutable = args[1];
        LoclmDirectory = loclmDirectory;
        DataDirectory = Path.GetDirectoryName(OriginalDataWinPath) ?? Directory.GetCurrentDirectory();
        OutputDataWinPath = Path.Combine(DataDirectory, LoaderConstants.CacheDataWinFileName);
        ModsDirectory = Path.Combine(LoclmDirectory, "mods");
        LogsDirectory = Path.Combine(LoclmDirectory, "Logs");
        CacheManifestPath = Path.Combine(LogsDirectory, LoaderConstants.CacheManifestFileName);
        DisabledModsDirectory = Path.Combine(LoclmDirectory, "disabled_mods");
        QuarantineDirectory = Path.Combine(LoclmDirectory, "quarantine");
        SecurityAllowlistPath = Path.Combine(LoclmDirectory, "security_allowlist.json");
        LoaderLogPath = Path.Combine(LogsDirectory, "LOCLM.log");
        ConflictReportPath = Path.Combine(LogsDirectory, "mod_conflicts.json");
    }

    public string[] Args { get; }
    public string OriginalDataWinPath { get; }
    public string GameExecutable { get; }
    public string LoclmDirectory { get; }
    public string DataDirectory { get; }
    public string OutputDataWinPath { get; }
    public string ModsDirectory { get; }
    public string LogsDirectory { get; }
    public string CacheManifestPath { get; }
    public string DisabledModsDirectory { get; }
    public string QuarantineDirectory { get; }
    public string SecurityAllowlistPath { get; }
    public string LoaderLogPath { get; }
    public string ConflictReportPath { get; }

    public static LoaderResult<LoaderConfig> Create(string[] args, string loclmDirectory)
    {
        if (args.Length < 2)
        {
            return LoaderResult<LoaderConfig>.Fail("missing_arguments", "Usage: loclm-csharp.exe <data.win> <game executable> [game args...]");
        }

        return LoaderResult<LoaderConfig>.Ok(new LoaderConfig(args, loclmDirectory));
    }
}
