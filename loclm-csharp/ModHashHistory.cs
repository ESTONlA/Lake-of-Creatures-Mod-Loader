using System.Text.Json;

public sealed class ModHashHistoryEntry
{
    public string ModId { get; set; } = "";
    public string ModName { get; set; } = "";
    public string FolderName { get; set; } = "";
    public string LastHash { get; set; } = "";
    public string UpdatedUtc { get; set; } = "";
}

public static class ModHashHistory
{
    public static void ApplyAndSave(string logsDirectory, IReadOnlyList<ModStatus> statuses, Action<string> warn)
    {
        Directory.CreateDirectory(logsDirectory);
        string path = Path.Combine(logsDirectory, "mod_hash_history.json");
        Dictionary<string, ModHashHistoryEntry> history = Load(path, warn);
        List<ModStatus> changed = new();

        foreach (ModStatus status in statuses.Where(status => !string.IsNullOrWhiteSpace(status.DllSha256)))
        {
            string key = string.IsNullOrWhiteSpace(status.ModId) ? status.FolderName : status.ModId;
            if (history.TryGetValue(key, out ModHashHistoryEntry? previous) &&
                !string.Equals(previous.LastHash, status.DllSha256, StringComparison.OrdinalIgnoreCase))
            {
                status.HashChangedSinceLastRun = true;
                status.PreviousDllSha256 = previous.LastHash;
                changed.Add(status);
            }

            history[key] = new ModHashHistoryEntry
            {
                ModId = key,
                ModName = status.ModName,
                FolderName = status.FolderName,
                LastHash = status.DllSha256,
                UpdatedUtc = DateTime.UtcNow.ToString("O")
            };
        }

        File.WriteAllText(path, JsonSerializer.Serialize(history.Values.OrderBy(entry => entry.ModId).ToList(), JsonUtil.IndentedOptions));
        File.WriteAllText(Path.Combine(logsDirectory, "changed_mods.json"), JsonSerializer.Serialize(changed, JsonUtil.IndentedOptions));
    }

    private static Dictionary<string, ModHashHistoryEntry> Load(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return new Dictionary<string, ModHashHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }

        try
        {
            List<ModHashHistoryEntry> entries = JsonSerializer.Deserialize<List<ModHashHistoryEntry>>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions) ?? new();
            return entries
                .Where(entry => !string.IsNullOrWhiteSpace(entry.ModId))
                .GroupBy(entry => entry.ModId, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);
        }
        catch (Exception ex)
        {
            warn("Could not read mod hash history. It will be recreated. " + ex.Message);
            return new Dictionary<string, ModHashHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }
    }
}
