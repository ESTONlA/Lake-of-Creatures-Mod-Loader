using System.Text.Json;

public static class LoaderUtilityModes
{
    public static bool TryRun(
        LoaderCommandLine commandLine,
        LoaderConfig config,
        LoaderSettings settings,
        ModLoadPlan loadPlan,
        Action<string> info,
        Action<string> success,
        Action<string> warn,
        Action<string> error)
    {
        bool handled = false;
        if (commandLine.ListMods)
        {
            handled = true;
            info("Installed mods:");
            foreach (ModStatus status in loadPlan.Statuses)
            {
                info($"- {status.FolderName}: {status.State} {status.ModName}".Trim());
            }
        }

        if (commandLine.ValidateMods || commandLine.Diagnose)
        {
            handled = true;
            int failed = loadPlan.Statuses.Count(status => status.State is "failed" or "blocked");
            info($"Validated {loadPlan.Statuses.Count} mod folder(s). Failed/blocked: {failed}.");
            foreach (ModStatus status in loadPlan.Statuses.Where(status => status.State is "failed" or "blocked" or "skipped"))
            {
                warn($"{status.FolderName}: {status.State} {status.Error} {status.CompatibilityStatus}".Trim());
            }
        }

        if (commandLine.ClearCache)
        {
            handled = true;
            CacheManager.ClearCache(config, info, warn);
        }

        if (commandLine.RollbackCache)
        {
            handled = true;
            LoaderResult rollback = CacheManager.RollbackLastKnownGood(config);
            if (rollback.Success)
            {
                success("Rolled back to the last-known-good LOCLM cache.");
            }
            else
            {
                error(rollback.Error?.Message ?? "Rollback failed.");
            }
        }

        foreach (string mod in commandLine.DisableMods)
        {
            handled = true;
            if (!ModProfileManager.SetModEnabled(config, settings, mod, enabled: false, info, warn))
            {
                warn($"Could not disable mod '{mod}'.");
            }
        }

        foreach (string mod in commandLine.EnableMods)
        {
            handled = true;
            if (!ModProfileManager.SetModEnabled(config, settings, mod, enabled: true, info, warn))
            {
                warn($"Could not enable mod '{mod}'.");
            }
        }

        foreach (string mod in commandLine.UnquarantineMods)
        {
            handled = true;
            int removed = RemoveQuarantineMarkers(config.QuarantineDirectory, mod);
            if (removed > 0)
            {
                success($"Removed {removed} quarantine marker(s) matching '{mod}'.");
            }
            else
            {
                warn($"No quarantine markers matched '{mod}'.");
            }
        }

        if (commandLine.Repair)
        {
            handled = true;
            SetupManager.EnsureLayout(config, settings, repair: true, info, warn);
        }

        if (commandLine.Diagnose)
        {
            handled = true;
            string diagnosePath = Path.Combine(config.LogsDirectory, "diagnose_result.json");
            File.WriteAllText(diagnosePath, JsonSerializer.Serialize(new
            {
                generatedUtc = DateTime.UtcNow.ToString("O"),
                loaderVersion = LoaderConstants.LoaderVersion,
                installPath = config.LoclmDirectory,
                dataWin = config.OriginalDataWinPath,
                gameExecutable = config.GameExecutable,
                mods = loadPlan.Statuses
            }, JsonUtil.IndentedOptions));
            success($"Wrote diagnose result: {diagnosePath}");
        }

        return handled;
    }

    private static int RemoveQuarantineMarkers(string quarantineDirectory, string mod)
    {
        if (!Directory.Exists(quarantineDirectory))
        {
            return 0;
        }

        int removed = 0;
        foreach (string file in Directory.GetFiles(quarantineDirectory, "*.blocked.txt"))
        {
            string text = File.ReadAllText(file);
            if (!Path.GetFileNameWithoutExtension(file).Contains(mod, StringComparison.OrdinalIgnoreCase) &&
                !text.Contains(mod, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            File.Delete(file);
            removed++;
        }

        return removed;
    }
}
