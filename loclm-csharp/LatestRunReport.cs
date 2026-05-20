using System.Text.Json;

public sealed class LatestRunReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public string Mode { get; set; } = "";
    public string DataWinPath { get; set; } = "";
    public string GameExecutable { get; set; } = "";
    public string OutputCachePath { get; set; } = "";
    public bool MenuDisabled { get; set; }
    public bool SafeMode { get; set; }
    public bool StrictMode { get; set; }
    public int WarningCount { get; set; }
    public int ErrorCount { get; set; }
    public List<string> Warnings { get; set; } = new();
    public List<string> Errors { get; set; } = new();
    public List<ModStatus> Mods { get; set; } = new();

    public static void Write(
        string logsDirectory,
        string mode,
        LoaderConfig config,
        LoaderSettings settings,
        LoaderCommandLine commandLine,
        IReadOnlyList<ModStatus> statuses,
        IReadOnlyList<string> warnings,
        IReadOnlyList<string> errors,
        Action<string> warn)
    {
        try
        {
            Directory.CreateDirectory(logsDirectory);
            LatestRunReport report = new()
            {
                GeneratedUtc = DateTime.UtcNow.ToString("O"),
                LoaderVersion = LoaderConstants.LoaderVersion,
                Mode = mode,
                DataWinPath = config.OriginalDataWinPath,
                GameExecutable = config.GameExecutable,
                OutputCachePath = config.OutputDataWinPath,
                MenuDisabled = settings.DisableInGameMenu,
                SafeMode = commandLine.SafeMode,
                StrictMode = settings.StrictMode,
                WarningCount = warnings.Count,
                ErrorCount = errors.Count,
                Warnings = warnings.ToList(),
                Errors = errors.ToList(),
                Mods = statuses.ToList()
            };

            File.WriteAllText(Path.Combine(logsDirectory, "latest_run.json"), JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
        }
        catch (Exception ex)
        {
            warn("Could not write latest_run.json: " + ex.Message);
        }
    }
}
