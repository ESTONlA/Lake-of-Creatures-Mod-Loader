using System.Text.Json;

public sealed class ModSecurityHashHistoryEntry
{
    public string ModId { get; set; } = "";
    public string ModName { get; set; } = "";
    public string FolderName { get; set; } = "";
    public string LastSecurityHash { get; set; } = "";
    public string UpdatedUtc { get; set; } = "";
}

public static class ModSecurityHashHistory
{
    public static void ApplyAndSave(
        string logsDirectory,
        IReadOnlyList<ModStatus> statuses,
        SecurityAllowlist allowlist,
        Action<string> warn)
    {
        Directory.CreateDirectory(logsDirectory);
        string path = Path.Combine(logsDirectory, "mod_security_hash_history.json");
        Dictionary<string, ModSecurityHashHistoryEntry> history = Load(path, warn);

        foreach (ModStatus status in statuses.Where(status => !string.IsNullOrWhiteSpace(status.Security.Hash)))
        {
            string key = string.IsNullOrWhiteSpace(status.ModId) ? status.FolderName : status.ModId;
            if (history.TryGetValue(key, out ModSecurityHashHistoryEntry? previous) &&
                !string.Equals(previous.LastSecurityHash, status.Security.Hash, StringComparison.OrdinalIgnoreCase) &&
                allowlist.HasHash(previous.LastSecurityHash) &&
                !allowlist.HasHash(status.Security.Hash))
            {
                string warning = $"Previously allowlisted mod hash changed for '{status.ModName}'. Review the mod before allowlisting the new hash.";
                status.Security.AllowlistWarning = warning;
                status.Warnings.Add(warning);
                warn(warning);
            }

            history[key] = new ModSecurityHashHistoryEntry
            {
                ModId = key,
                ModName = status.ModName,
                FolderName = status.FolderName,
                LastSecurityHash = status.Security.Hash,
                UpdatedUtc = DateTime.UtcNow.ToString("O")
            };
        }

        File.WriteAllText(path, JsonSerializer.Serialize(history.Values.OrderBy(entry => entry.ModId).ToList(), JsonUtil.IndentedOptions));
    }

    private static Dictionary<string, ModSecurityHashHistoryEntry> Load(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return new Dictionary<string, ModSecurityHashHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }

        try
        {
            List<ModSecurityHashHistoryEntry> entries = JsonSerializer.Deserialize<List<ModSecurityHashHistoryEntry>>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions) ?? new();
            return entries
                .Where(entry => !string.IsNullOrWhiteSpace(entry.ModId))
                .GroupBy(entry => entry.ModId, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);
        }
        catch (Exception ex)
        {
            warn("Could not read mod security hash history. It will be recreated. " + ex.Message);
            return new Dictionary<string, ModSecurityHashHistoryEntry>(StringComparer.OrdinalIgnoreCase);
        }
    }
}
