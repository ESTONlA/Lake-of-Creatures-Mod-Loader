public static class SetupManager
{
    public static void EnsureLayout(LoaderConfig config, LoaderSettings settings, bool repair, Action<string> info, Action<string> warn)
    {
        EnsureDirectory(config.LoclmDirectory, info);
        EnsureDirectory(config.ModsDirectory, info);
        EnsureDirectory(config.LogsDirectory, info);
        EnsureDirectory(config.DisabledModsDirectory, info);
        EnsureDirectory(config.QuarantineDirectory, info);
        EnsureDirectory(config.ProfilesDirectory, info);

        EnsureJsonFile(config.SecurityAllowlistPath, "{\n  \"allowedModHashes\": [\n    {\n      \"hash\": \"PUT_TRUSTED_MOD_SHA256_HASH_HERE\",\n      \"reason\": \"Explain why this mod hash is trusted.\",\n      \"addedBy\": \"Your name\",\n      \"addedUtc\": \"YYYY-MM-DDTHH:MM:SSZ\"\n    }\n  ]\n}\n", repair, info, warn);
        EnsureJsonFile(Path.Combine(config.LoclmDirectory, "supported_game_builds.json"), "{\n  \"builds\": []\n}\n", repair, info, warn);
        EnsureJsonFile(config.ConfigPath, System.Text.Json.JsonSerializer.Serialize(settings, JsonUtil.IndentedOptions), repair, info, warn);
        EnsureJsonFile(Path.Combine(config.LoclmDirectory, "config", "steam_mp.json"), "{\n  \"enabled\": true,\n  \"localBridgePort\": 38470,\n  \"protocolVersion\": 1,\n  \"debug\": true,\n  \"sendRate\": 20\n}\n", repair, info, warn);
        EnsureJsonFile(Path.Combine(config.ProfilesDirectory, "default.json"), "{\n  \"name\": \"default\",\n  \"description\": \"Default LOCLM mod profile.\",\n  \"enabledMods\": [],\n  \"disabledMods\": []\n}\n", repair, info, warn);
        EnsureSchemaFile(config, repair, info, warn);
        ModProfileManager.EnsureDefaultProfile(config, settings, info, warn);

        if (!settings.FirstRunComplete)
        {
            info("First-run setup complete. LOCLM folders and default config are ready.");
            settings.MarkFirstRunComplete(config.ConfigPath);
        }
        else if (repair)
        {
            info("Repair check complete. Missing LOCLM folders/files were recreated.");
        }
    }

    private static void EnsureDirectory(string path, Action<string> info)
    {
        if (Directory.Exists(path))
        {
            return;
        }

        Directory.CreateDirectory(path);
        info($"Created folder: {path}");
    }

    private static void EnsureJsonFile(string path, string contents, bool repair, Action<string> info, Action<string> warn)
    {
        if (File.Exists(path) && !repair)
        {
            return;
        }

        if (File.Exists(path))
        {
            try
            {
                _ = System.Text.Json.JsonDocument.Parse(File.ReadAllText(path));
                return;
            }
            catch (Exception ex)
            {
                warn($"Repairing invalid JSON file '{path}': {ex.Message}");
            }
        }

        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        File.WriteAllText(path, contents);
        info($"Created default file: {path}");
    }

    private static void EnsureSchemaFile(LoaderConfig config, bool repair, Action<string> info, Action<string> warn)
    {
        string source = Path.Combine(AppContext.BaseDirectory, "modinfo.schema.json");
        string destination = Path.Combine(config.LoclmDirectory, "modinfo.schema.json");
        if (File.Exists(destination) && !repair)
        {
            return;
        }

        if (!File.Exists(source))
        {
            warn("Could not find bundled modinfo.schema.json.");
            return;
        }

        File.Copy(source, destination, overwrite: true);
        info($"Created default file: {destination}");
    }
}
