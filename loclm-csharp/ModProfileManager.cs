using System.Text.Json;

public sealed class ModProfile
{
    public string Name { get; set; } = "default";
    public string Description { get; set; } = "Default LOCLM mod profile.";
    public List<string> EnabledMods { get; set; } = new();
    public List<string> DisabledMods { get; set; } = new();
}

public static class ModProfileManager
{
    public static string GetProfilePath(LoaderConfig config, LoaderSettings settings)
    {
        string safeName = string.Join("_", settings.ActiveProfile.Split(Path.GetInvalidFileNameChars(), StringSplitOptions.RemoveEmptyEntries));
        if (string.IsNullOrWhiteSpace(safeName))
        {
            safeName = "default";
        }

        return Path.Combine(config.ProfilesDirectory, safeName + ".json");
    }

    public static ModProfile LoadOrCreate(LoaderConfig config, LoaderSettings settings, Action<string> info, Action<string> warn)
    {
        Directory.CreateDirectory(config.ProfilesDirectory);
        string path = GetProfilePath(config, settings);
        if (!File.Exists(path))
        {
            ModProfile created = new()
            {
                Name = settings.ActiveProfile
            };
            Save(path, created);
            info($"Created LOCLM mod profile: {path}");
            return created;
        }

        try
        {
            return JsonSerializer.Deserialize<ModProfile>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions) ?? new ModProfile();
        }
        catch (Exception ex)
        {
            warn("Could not read mod profile. Recreating default profile. " + ex.Message);
            ModProfile fallback = new()
            {
                Name = settings.ActiveProfile
            };
            Save(path, fallback);
            return fallback;
        }
    }

    public static bool SetModEnabled(LoaderConfig config, LoaderSettings settings, string modIdOrName, bool enabled, Action<string> info, Action<string> warn)
    {
        ModProfile profile = LoadOrCreate(config, settings, info, warn);
        string normalized = modIdOrName.Trim();
        if (normalized.Length == 0)
        {
            return false;
        }

        profile.DisabledMods.RemoveAll(value => value.Equals(normalized, StringComparison.OrdinalIgnoreCase));
        profile.EnabledMods.RemoveAll(value => value.Equals(normalized, StringComparison.OrdinalIgnoreCase));

        if (enabled)
        {
            profile.EnabledMods.Add(normalized);
            info($"Enabled '{normalized}' in profile '{profile.Name}'.");
        }
        else
        {
            profile.DisabledMods.Add(normalized);
            info($"Disabled '{normalized}' in profile '{profile.Name}'.");
        }

        Save(GetProfilePath(config, settings), profile);
        return true;
    }

    public static void EnsureDefaultProfile(LoaderConfig config, LoaderSettings settings, Action<string> info, Action<string> warn) =>
        LoadOrCreate(config, settings, info, warn);

    private static void Save(string path, ModProfile profile)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        File.WriteAllText(path, JsonSerializer.Serialize(profile, JsonUtil.IndentedOptions));
    }
}
