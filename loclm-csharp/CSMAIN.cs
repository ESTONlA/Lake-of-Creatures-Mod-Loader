using UndertaleModLib;
using System.IO;
using System.Linq;
using System.Text;

public static class LoaderApp
{
    private static readonly List<string> WarningSummary = new();
    private static readonly List<string> ErrorSummary = new();
    private static bool QuietMode;
    private static int LogRetentionDays = 14;

    private static void WriteColored(string text, ConsoleColor color, bool newline = true)
    {
        if (newline)
        {
            LoaderLogger.WriteRaw(text);
        }

        if (!QuietMode || color is ConsoleColor.Red or ConsoleColor.Yellow)
        {
            ConsoleTheme.WriteColored(text, color, newline);
        }
    }

    private static void LogBanner()
    {
        WriteColored("==================================================", ConsoleColor.DarkCyan);
        WriteColored(" LOCLM - Lake of Creatures Loader", ConsoleColor.Cyan);
        WriteColored("==================================================", ConsoleColor.DarkCyan);
    }

    private static void LogInfo(string message) => WriteColored($"[INFO] {message}", ConsoleColor.Gray);
    private static void LogStep(string message) => WriteColored($"[STEP] {message}", ConsoleColor.Cyan);
    private static void LogSuccess(string message) => WriteColored($"[ OK ] {message}", ConsoleColor.Green);
    private static void LogWarn(string message)
    {
        WarningSummary.Add(message);
        WriteColored($"[WARN] {message}", ConsoleColor.Yellow);
    }

    private static void LogError(string message)
    {
        ErrorSummary.Add(message);
        WriteColored($"[ERR ] {message}", ConsoleColor.Red);
    }
    private static void LogPlain(string message) => WriteColored(message, ConsoleColor.White);

    public static void Run(string[] args)
    {
        LoaderPhaseTimer phases = new();
        if (args.Any(arg => arg.Equals("--benchmark", StringComparison.OrdinalIgnoreCase)))
        {
            string benchmarkLogsDirectory = Path.Combine(AppContext.BaseDirectory, "Logs");
            Directory.CreateDirectory(benchmarkLogsDirectory);
            LoaderLogger.Initialize(Path.Combine(benchmarkLogsDirectory, "LOCLM.log"), LoaderConstants.LoaderVersion);
            LogBanner();
            LogInfo("Benchmark mode enabled. No game files will be patched or launched.");
            BenchmarkMode.Run(AppContext.BaseDirectory, phases, LogInfo, LogWarn, LogSuccess);
            phases.WriteReport(benchmarkLogsDirectory, "benchmark", LogInfo, LogWarn);
            ReportMaintenance.CompressOldReports(benchmarkLogsDirectory, TimeSpan.FromDays(14), LogInfo, LogWarn);
            return;
        }

        LoaderResult<LoaderConfig> configResult = LoaderConfig.Create(args, AppContext.BaseDirectory);
        if (!configResult.Success || configResult.Value is null)
        {
            LogBanner();
            LogError(configResult.Error?.Message ?? "Missing launch arguments.");
            return;
        }

        LoaderConfig config = configResult.Value;
        LoaderCommandLine commandLine = LoaderCommandLine.Parse(args);
        string originalDataWinPath = config.OriginalDataWinPath;
        string gameExecutable = config.GameExecutable;
        string loclmDirectory = config.LoclmDirectory;
        string outputDataWinPath = config.OutputDataWinPath;
        string modsDirectory = config.ModsDirectory;
        string logsDirectory = config.LogsDirectory;
        string cacheManifestPath = config.CacheManifestPath;
        string disabledModsDirectory = config.DisabledModsDirectory;
        string quarantineDirectory = config.QuarantineDirectory;
        string securityAllowlistPath = config.SecurityAllowlistPath;
        string loaderLogPath = config.LoaderLogPath;
        string conflictReportPath = config.ConflictReportPath;
        LoaderSettings settings = LoaderSettings.LoadOrCreate(config.ConfigPath, commandLine.Repair, message => { }, message => { });
        settings.ApplyCommandLine(commandLine);
        QuietMode = settings.Quiet;
        LogRetentionDays = Math.Max(1, settings.LogRetentionDays);
        ReportMaintenance.RotateLargeLogs(logsDirectory, settings.LogRotationMaxBytes, message => { }, message => { });
        ModLoadOptions loadOptions = ModLoadOptions.FromSettings(settings);

        Directory.CreateDirectory(logsDirectory);
        LoaderLogger.Initialize(loaderLogPath, LoaderConstants.LoaderVersion);
        LogBanner();
        LogInfo($"Game executable: {gameExecutable}");
        LogInfo($"Source data.win: {originalDataWinPath}");
        LogInfo($"Output cache: {outputDataWinPath}");
        LogInfo($"Loader log: {loaderLogPath}");

        LoaderResult installValidation = phases.Measure("install validation", () => InstallValidator.Validate(config));
        if (!installValidation.Success)
        {
            LogError(installValidation.Error?.Message ?? "Install validation failed.");
            FinishPerformance(logsDirectory, phases, null, "install_failed");
            return;
        }

        SetupManager.EnsureLayout(config, settings, commandLine.Repair, LogInfo, LogWarn);
        ModProfile activeProfile = ModProfileManager.LoadOrCreate(config, settings, LogInfo, LogWarn);

        FileHashCache hashCache = FileHashCache.Load(Path.Combine(logsDirectory, "file_hash_cache.json"), LogWarn);

        phases.Measure("startup diagnostics", () => StartupDiagnostics.Run(
            originalDataWinPath,
            gameExecutable,
            loclmDirectory,
            logsDirectory,
            modsDirectory,
            LoaderConstants.LoaderVersion,
            LogInfo,
            LogWarn));

        GameCompatibilityInfo gameCompatibility = phases.Measure("game compatibility hashes", () => GameCompatibilityInfo.Create(originalDataWinPath, gameExecutable, hashCache));
        SecurityAllowlist securityAllowlist = phases.Measure("security allowlist load", () => SecurityAllowlist.Load(securityAllowlistPath, LogWarn));

        string[] blacklisted = LoadOptionalList(Path.Combine(loclmDirectory, "blacklist.txt"));
        string[] whitelisted = LoadOptionalList(Path.Combine(loclmDirectory, "whitelist.txt"));
        ModLoadPlan loadPlan = phases.Measure("mod discovery and load order", () => ModLoadPlanner.Build(
            modsDirectory,
            disabledModsDirectory,
            LoaderConstants.LoaderVersion,
            gameCompatibility,
            whitelisted,
            blacklisted,
            LogInfo,
            LogWarn,
            LogError,
            hashCache,
            activeProfile));
        if (commandLine.SafeMode)
        {
            foreach (ModStatus status in loadPlan.Statuses.Where(status => status.State == "planned"))
            {
                status.State = "disabled";
                status.CompatibilityStatus = "Disabled by --safe-mode.";
                status.SkipReason = status.CompatibilityStatus;
            }
            loadPlan.Mods.Clear();
            LogWarn("Safe mode enabled. All mods are disabled for this launch.");
        }
        if (loadPlan.Mods.Count == 0)
        {
            LogInfo("No active mods found. LOCLM will still generate/use a patched cache so the in-game LOCLM menu stays available.");
        }

        phases.Measure("write planned mod reports", () =>
        {
            ModHashHistory.ApplyAndSave(logsDirectory, loadPlan.Statuses, LogWarn);
            ModStatusWriter.WriteAll(logsDirectory, LoaderConstants.LoaderVersion, loadOptions.StrictMode, loadPlan.Statuses);
        });

        if (LoaderUtilityModes.TryRun(commandLine, config, settings, loadPlan, LogInfo, LogSuccess, LogWarn, LogError))
        {
            LatestRunReport.Write(logsDirectory, "utility", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
            FinishPerformance(logsDirectory, phases, hashCache, "utility");
            return;
        }

        string cacheFingerprint = phases.Measure("cache fingerprint", () => CacheManager.BuildCacheFingerprint(originalDataWinPath, gameExecutable, loclmDirectory, modsDirectory, hashCache));
        if (phases.Measure("cache validation", () => CacheManager.IsCacheValid(outputDataWinPath, cacheManifestPath, cacheFingerprint, LogWarn)))
        {
            LogSuccess("Cache is up to date. Skipping regeneration.");
            WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, false);
            FinishPerformance(logsDirectory, phases, hashCache, "cache_reused");
            LogStep("Launching game");
            LogInfo("Executable: " + gameExecutable);
            LatestRunReport.Write(logsDirectory, "cache_reused", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
            GameLauncher.Launch(gameExecutable, outputDataWinPath, commandLine.GameArgs, settings.PauseBeforeLaunch, LogWarn, LogError, LogSuccess);
            return;
        }

        LogStep("Cache is missing or outdated. Regenerating patched data.win.");

        LogStep("Opening data.win");
        LogStep($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        GamePatcher gamePatcher = new();
        UndertaleData data = phases.Measure("read data.win", () => gamePatcher.ReadDataWin(originalDataWinPath, message =>
        {
            LogError("Exception while reading data.win:");
            LogPlain(message);
        }));
        phases.Measure("future proofing report", () => FutureProofing.Run(data, gameCompatibility, logsDirectory, loclmDirectory, LoaderConstants.LoaderVersion, LogInfo, LogWarn));

        LogStep("Scanning mods directory");
        LogInfo(modsDirectory);

        ResourceChangeTracker changeTracker = new();
        ModLoader modLoader = new(loadOptions, LogInfo, LogStep, LogSuccess, LogWarn, LogError, LogPlain);
        ModLoadExecutionResult modLoadResult = phases.Measure("load mods and security scan", () => modLoader.LoadMods(
            data,
            modsDirectory,
            disabledModsDirectory,
            quarantineDirectory,
            LoaderConstants.LoaderVersion,
            gameCompatibility,
            securityAllowlist,
            whitelisted,
            blacklisted,
            changeTracker,
            hashCache,
            loadPlan));
        loadPlan = modLoadResult.LoadPlan;
        IReadOnlyList<string> loadedMods = modLoadResult.LoadedMods;
        IReadOnlyList<string> failedMods = modLoadResult.FailedMods;
        IReadOnlyList<string> securityBlockedMods = modLoadResult.SecurityBlockedMods;
        bool hasErrored = modLoadResult.HasErrored;

        phases.Measure("update mod hash history", () => ModHashHistory.ApplyAndSave(logsDirectory, loadPlan.Statuses, LogWarn));
        phases.Measure("update security hash history", () => ModSecurityHashHistory.ApplyAndSave(logsDirectory, loadPlan.Statuses, securityAllowlist, LogWarn));
        phases.Measure("update mod failure history", () => ModFailureTracker.UpdateAndAutoDisable(config, settings, loadPlan.Statuses, LogInfo, LogWarn));
        phases.Measure("write mod status reports", () => ModStatusWriter.WriteAll(logsDirectory, LoaderConstants.LoaderVersion, loadOptions.StrictMode, loadPlan.Statuses));
        phases.Measure("write conflict report", () => changeTracker.WriteReport(conflictReportPath));
        IReadOnlyList<string> modConflicts = changeTracker.BuildMenuSummaries();
        if (changeTracker.Conflicts.Count > 0)
        {
            LogWarn($"Detected {changeTracker.Conflicts.Count} possible mod conflict(s). Report: {conflictReportPath}");
        }
        else
        {
            LogSuccess($"No mod conflicts detected. Report: {conflictReportPath}");
        }

        if (settings.DisableInGameMenu)
        {
            LogWarn("In-game LOCLM menu disabled by config or --disable-menu.");
        }
        else
        {
            InGameMenuInstaller menuInstaller = new(new GmlAssetLoader(loclmDirectory), LogInfo, LogWarn, LogSuccess);
            bool menuInstalled = phases.Measure("install in-game menu", () => menuInstaller.Install(data, modsDirectory, loadedMods, failedMods, securityBlockedMods, modConflicts));
            if (!menuInstalled)
            {
                LogWarn("LOCLM will continue without the in-game menu. Mods can still load and the generated cache can still launch.");
            }
        }

        if(hasErrored){
            WriteColored(
@" 

********************
There was an error during the mod loading process!
Please review the above error!

If you wish to continue launching the game, type 'y' and press enter.
This console will stay open until you type 'y' or close it manually.

If you continue to launch the game, the mods you have added may not work as expected, or even may not work at all.
********************
Continue? (type y and press Enter)
", ConsoleColor.Yellow);
            GameLauncher.WaitForYes(LogWarn);
        }

        LogStep("Creating output stream");
        LogStep($"Writing modified data.win to \"{outputDataWinPath}\"...");
        LoaderResult writeCheck = gamePatcher.CheckWritable(outputDataWinPath, new FileInfo(originalDataWinPath).Length * 2);
        if (!writeCheck.Success)
        {
            LogError(writeCheck.Error?.Message ?? "Cache write check failed.");
            LatestRunReport.Write(logsDirectory, "cache_write_check_failed", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
            FinishPerformance(logsDirectory, phases, hashCache, "cache_write_check_failed");
            return;
        }
        LoaderResult writeResult = phases.Measure("write patched data.win", () => gamePatcher.WriteDataWinAtomic(outputDataWinPath, data));
        if (!writeResult.Success)
        {
            LogError(writeResult.Error?.Message ?? "Atomic cache write failed.");
            LatestRunReport.Write(logsDirectory, "cache_write_failed", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
            FinishPerformance(logsDirectory, phases, hashCache, "cache_write_failed");
            return;
        }
        LoaderResult cacheValidation = phases.Measure("validate patched cache", () => gamePatcher.ValidateWrittenDataWin(outputDataWinPath));
        if (!cacheValidation.Success)
        {
            LogError(cacheValidation.Error?.Message ?? "Generated cache validation failed.");
            LatestRunReport.Write(logsDirectory, "cache_validation_failed", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
            FinishPerformance(logsDirectory, phases, hashCache, "cache_validation_failed");
            return;
        }

        if (!hasErrored)
        {
            phases.Measure("write cache manifest", () => CacheManager.WriteCacheManifest(cacheManifestPath, cacheFingerprint, LogInfo));
            CacheManager.SaveLastKnownGood(config, LogInfo, LogWarn);
        }
        LogSuccess("Done.");
        WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, hasErrored);
        LatestRunReport.Write(logsDirectory, hasErrored ? "patched_with_errors" : "patched", config, settings, commandLine, loadPlan.Statuses, WarningSummary, ErrorSummary, LogWarn);
        FinishPerformance(logsDirectory, phases, hashCache, hasErrored ? "patched_with_errors" : "patched");
        LogStep("Launching game");
        LogInfo("Executable: " + gameExecutable);
        GameLauncher.Launch(gameExecutable, outputDataWinPath, commandLine.GameArgs, settings.PauseBeforeLaunch, LogWarn, LogError, LogSuccess);
    }

    private static string[] LoadOptionalList(string path) =>
        File.Exists(path)
            ? File.ReadAllLines(path)
                .Where(line => !string.IsNullOrWhiteSpace(line))
                .Select(line => line.Trim())
                .ToArray()
            : Array.Empty<string>();

    private static void FinishPerformance(string logsDirectory, LoaderPhaseTimer phases, FileHashCache? hashCache, string mode)
    {
        hashCache?.Save(LogWarn);
        phases.WriteReport(logsDirectory, mode, LogInfo, LogWarn);
        ReportMaintenance.CompressOldReports(logsDirectory, TimeSpan.FromDays(LogRetentionDays), LogInfo, LogWarn);
    }

    private static void WriteRunSummary(
        string logsDirectory,
        string originalDataWinPath,
        string gameExecutable,
        string outputDataWinPath,
        string cacheManifestPath,
        GameCompatibilityInfo gameCompatibility,
        bool hadPatchError)
    {
        Directory.CreateDirectory(logsDirectory);
        string summaryPath = Path.Combine(logsDirectory, "LOCLM_summary.txt");
        StringBuilder builder = new();
        builder.AppendLine("LOCLM troubleshooting summary");
        builder.AppendLine("============================");
        builder.AppendLine("Created UTC: " + DateTime.UtcNow.ToString("O"));
        builder.AppendLine("Loader version: " + LoaderConstants.LoaderVersion);
        builder.AppendLine("Menu injection version: " + LoaderConstants.MenuInjectionVersion);
        builder.AppendLine("OS version: " + Environment.OSVersion);
        builder.AppendLine(".NET version: " + Environment.Version);
        builder.AppendLine("Install path: " + AppContext.BaseDirectory);
        builder.AppendLine("Game executable: " + gameExecutable);
        builder.AppendLine("Game exe hash: " + gameCompatibility.GameExecutableSha256);
        builder.AppendLine("data.win: " + originalDataWinPath);
        builder.AppendLine("data.win hash: " + gameCompatibility.DataWinSha256);
        builder.AppendLine("Cache file: " + outputDataWinPath);
        builder.AppendLine("Cache manifest: " + cacheManifestPath);
        builder.AppendLine("Patch error this run: " + hadPatchError);
        builder.AppendLine();
        AppendSummarySection(builder, "Warnings", WarningSummary);
        AppendSummarySection(builder, "Errors", ErrorSummary);
        builder.AppendLine("Common next steps");
        builder.AppendLine("-----------------");
        foreach (string step in BuildNextSteps())
        {
            builder.AppendLine("- " + step);
        }

        File.WriteAllText(summaryPath, builder.ToString());

        LogPlain("");
        WriteColored("LOCLM final summary", ConsoleColor.Cyan);
        LogInfo($"Support logs folder: {logsDirectory}");
        LogInfo($"Summary file: {summaryPath}");
        LogInfo($"Warnings this run: {WarningSummary.Count}");
        LogInfo($"Errors this run: {ErrorSummary.Count}");
        if (WarningSummary.Count > 0)
        {
            LogPlain("Recent warnings:");
            foreach (string warning in WarningSummary.TakeLast(5))
            {
                WriteColored("  - " + warning, ConsoleColor.Yellow);
            }
        }

        if (ErrorSummary.Count > 0)
        {
            LogPlain("Recent errors:");
            foreach (string error in ErrorSummary.TakeLast(5))
            {
                WriteColored("  - " + error, ConsoleColor.Red);
            }
            LogPlain("Next steps:");
            foreach (string step in BuildNextSteps())
            {
                LogPlain("  - " + step);
            }
        }
    }

    private static void AppendSummarySection(StringBuilder builder, string title, IReadOnlyList<string> values)
    {
        builder.AppendLine(title);
        builder.AppendLine(new string('-', title.Length));
        builder.AppendLine("Count: " + values.Count);
        foreach (string value in values)
        {
            builder.AppendLine("- " + value);
        }

        builder.AppendLine();
    }

    private static IReadOnlyList<string> BuildNextSteps()
    {
        List<string> steps = new();
        string combined = string.Join("\n", ErrorSummary.Concat(WarningSummary));
        if (combined.Contains("data.win", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Verify the game files in Steam, then delete LOCLM_CACHE_data.win and launch again.");
        }
        if (combined.Contains("version.dll", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("proxy", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Make sure version.dll is in the same folder as LakeOfCreatures.exe.");
        }
        if (combined.Contains("Missing DLL", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("dependency", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Reinstall the affected mod as a full folder, not only the mod DLL.");
        }
        if (combined.Contains("security scan", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("blocked", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Remove the blocked mod, or only allowlist its hash if you trust the mod author and understand the risk.");
        }
        if (combined.Contains(".NET", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("TargetFramework", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Install the Microsoft .NET 10 Desktop Runtime x64, then try again.");
        }
        if (combined.Contains("conflict", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Open Logs/mod_conflicts.json and test the conflicting mods one at a time.");
        }
        if (combined.Contains("Unknown game build", StringComparison.OrdinalIgnoreCase) ||
            combined.Contains("menu injection target changed", StringComparison.OrdinalIgnoreCase))
        {
            steps.Add("Open Logs/game_compatibility_report.json and confirm whether the game updated.");
            steps.Add("If the LOCLM menu is missing but mods loaded, update supported_game_builds.json or wait for a loader compatibility update.");
        }
        if (steps.Count == 0)
        {
            steps.Add("Zip the whole loclm/Logs folder and share it with the mod/loader developer.");
            steps.Add("If the game does not open at all, check loclm/Logs/LOCLM_proxy.log first.");
        }
        else
        {
            steps.Add("Zip the whole loclm/Logs folder if you need support.");
        }

        return steps;
    }

}
