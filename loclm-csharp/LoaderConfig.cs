public sealed class LoaderConfig
{
    private LoaderConfig(string[] args, string loaderDirectory, GameProfile gameProfile)
    {
        Args = args;
        OriginalDataWinPath = args[0];
        GameExecutable = args[1];
        LoaderDirectory = loaderDirectory;
        GameProfile = gameProfile;
        DataDirectory = Path.GetDirectoryName(OriginalDataWinPath) ?? Directory.GetCurrentDirectory();
        OutputDataWinPath = Path.Combine(DataDirectory, LoaderConstants.CacheDataWinFileName);
        ModsDirectory = Path.Combine(LoaderDirectory, "mods");
        LogsDirectory = Path.Combine(LoaderDirectory, "Logs");
        CacheManifestPath = Path.Combine(LogsDirectory, LoaderConstants.CacheManifestFileName);
        DisabledModsDirectory = Path.Combine(LoaderDirectory, "disabled_mods");
        QuarantineDirectory = Path.Combine(LoaderDirectory, "quarantine");
        SecurityAllowlistPath = Path.Combine(LoaderDirectory, "security_allowlist.json");
        LoaderLogPath = Path.Combine(LogsDirectory, "ANTENNI.log");
        ConflictReportPath = Path.Combine(LogsDirectory, "mod_conflicts.json");
    }

    public string[] Args { get; }
    public string OriginalDataWinPath { get; }
    public string GameExecutable { get; }
    public string LoaderDirectory { get; }
    public GameProfile GameProfile { get; }
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

    public static LoaderResult<LoaderConfig> Create(string[] args, string loaderDirectory)
    {
        if (args.Length < 2)
        {
            return LoaderResult<LoaderConfig>.Fail(
                "missing_arguments",
                $"Usage: {LoaderConstants.ManagedExecutableName} <data.win> <game executable> [game args...]");
        }

        GameProfile? gameProfile = GameProfile.Detect(args[1]);
        if (gameProfile is null)
        {
            return LoaderResult<LoaderConfig>.Fail(
                "unsupported_game",
                $"Unsupported game executable '{Path.GetFileName(args[1])}'. Supported executables: {GameProfile.SupportedExecutableList()}.");
        }

        return LoaderResult<LoaderConfig>.Ok(new LoaderConfig(args, loaderDirectory, gameProfile));
    }
}
