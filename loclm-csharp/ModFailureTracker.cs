using System.Text.Json;

public sealed class ModFailureHistoryEntry
{
    public string ModId { get; set; } = "";
    public string ModName { get; set; } = "";
    public string FolderName { get; set; } = "";
    public int ConsecutiveFailures { get; set; }
    public string LastFailureUtc { get; set; } = "";
    public string LastError { get; set; } = "";
}

public static class ModFailureTracker
{
    public static void UpdateAndAutoDisable(
        LoaderConfig config,
        LoaderSettings settings,
        IReadOnlyList<ModStatus> statuses,
        Action<string> info,
        Action<string> warn)
    {
        int threshold = Math.Max(0, settings.AutoDisableAfterFailures);
        if (threshold == 0)
        {
            return;
        }

        string path = Path.Combine(config.LogsDirectory, "mod_failure_history.json");
        Dictionary<string, ModFailureHistoryEntry> history = Load(path, warn);
        foreach (ModStatus status in statuses.Where(status => !string.IsNullOrWhiteSpace(status.FolderName)))
        {
            string key = string.IsNullOrWhiteSpace(status.ModId) ? status.FolderName : status.ModId;
            history.TryGetValue(key, out ModFailureHistoryEntry? entry);
            entry ??= new ModFailureHistoryEntry
            {
                ModId = key,
                ModName = status.ModName,
                FolderName = status.FolderName
            };

            if (status.State is "failed" or "blocked")
            {
                entry.ConsecutiveFailures++;
                entry.LastFailureUtc = DateTime.UtcNow.ToString("O");
                entry.LastError = status.Error;
            }
            else if (status.State is "loaded" or "disabled")
            {
                entry.ConsecutiveFailures = 0;
                entry.LastError = "";
            }

            history[key] = entry;

            if (entry.ConsecutiveFailures >= threshold)
            {
                MoveToDisabledMods(config, status, info, warn);
                entry.ConsecutiveFailures = 0;
            }
        }

        Directory.CreateDirectory(config.LogsDirectory);
        File.WriteAllText(path, JsonSerializer.Serialize(history.Values.OrderBy(entry => entry.ModId).ToList(), JsonUtil.IndentedOptions));
    }

    private static void MoveToDisabledMods(LoaderConfig config, ModStatus status, Action<string> info, Action<string> warn)
    {
        string source = status.ModPath;
        if (!Directory.Exists(source))
        {
            return;
        }

        Directory.CreateDirectory(config.DisabledModsDirectory);
        string destination = Path.Combine(config.DisabledModsDirectory, status.FolderName);
        if (Directory.Exists(destination))
        {
            destination += "_" + DateTime.UtcNow.ToString("yyyyMMddHHmmss");
        }

        try
        {
            Directory.Move(source, destination);
            status.State = "disabled";
            status.CompatibilityStatus = "Moved to disabled_mods after repeated failures.";
            status.Warnings.Add("Moved to disabled_mods after repeated failures.");
            warn($"Moved '{status.ModName}' to disabled_mods after repeated failures.");
        }
        catch (Exception ex)
        {
            warn($"Could not move '{status.ModName}' to disabled_mods: {ex.Message}");
        }
    }

    private static Dictionary<string, ModFailureHistoryEntry> Load(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return new Dictionary<string, ModFailureHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }

        try
        {
            List<ModFailureHistoryEntry> entries = JsonSerializer.Deserialize<List<ModFailureHistoryEntry>>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions) ?? new();
            return entries
                .Where(entry => !string.IsNullOrWhiteSpace(entry.ModId))
                .GroupBy(entry => entry.ModId, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);
        }
        catch (Exception ex)
        {
            warn("Could not read mod failure history. It will be recreated. " + ex.Message);
            return new Dictionary<string, ModFailureHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }
    }
}
