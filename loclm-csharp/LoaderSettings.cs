using System.Text.Json;

public sealed class LoaderSettings
{
    public string ModFailureMode { get; set; } = "relaxed";
    public bool Verbose { get; set; }
    public bool Quiet { get; set; }
    public bool DisableInGameMenu { get; set; }
    public bool PauseBeforeLaunch { get; set; } = true;
    public int LogRetentionDays { get; set; } = 14;
    public long LogRotationMaxBytes { get; set; } = 2 * 1024 * 1024;
    public string ActiveProfile { get; set; } = "default";
    public int AutoDisableAfterFailures { get; set; } = 3;
    public bool SecurityWarnOnlyDeveloperMode { get; set; }
    public long SecurityScanSizeLimitBytes { get; set; } = 16 * 1024 * 1024;
    public bool FirstRunComplete { get; set; }

    public bool StrictMode => ModFailureMode.Equals("strict", StringComparison.OrdinalIgnoreCase);

    public static LoaderSettings LoadOrCreate(string path, bool repair, Action<string> info, Action<string> warn)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        if (!File.Exists(path))
        {
            LoaderSettings created = new();
            Write(path, created);
            info($"Created default LOCLM config: {path}");
            return created;
        }

        try
        {
            LoaderSettings settings = JsonSerializer.Deserialize<LoaderSettings>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions) ?? new LoaderSettings();
            if (repair)
            {
                Write(path, settings);
                info($"Repaired LOCLM config: {path}");
            }

            return settings;
        }
        catch (Exception ex)
        {
            warn("Could not read loclm/config.json. Recreating defaults. " + ex.Message);
            LoaderSettings fallback = new();
            Write(path, fallback);
            return fallback;
        }
    }

    public void ApplyCommandLine(LoaderCommandLine commandLine)
    {
        if (commandLine.StrictMode)
        {
            ModFailureMode = "strict";
        }
        if (commandLine.RelaxedMode)
        {
            ModFailureMode = "relaxed";
        }
        if (commandLine.Verbose)
        {
            Verbose = true;
        }
        if (commandLine.Quiet)
        {
            Quiet = true;
        }
        if (commandLine.DisableMenu)
        {
            DisableInGameMenu = true;
        }
    }

    public void MarkFirstRunComplete(string path)
    {
        if (FirstRunComplete)
        {
            return;
        }

        FirstRunComplete = true;
        Write(path, this);
    }

    public static void Write(string path, LoaderSettings settings) =>
        File.WriteAllText(path, JsonSerializer.Serialize(settings, JsonUtil.IndentedOptions));
}
