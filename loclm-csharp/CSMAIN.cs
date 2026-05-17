using UndertaleModLib;
using System.IO;
using System.Linq;
using System.Text;

public static class LoaderApp
{
    private static readonly List<string> WarningSummary = new();
    private static readonly List<string> ErrorSummary = new();

    private static void WriteColored(string text, ConsoleColor color, bool newline = true)
    {
        if (newline)
        {
            LoaderLogger.WriteRaw(text);
        }

        ConsoleTheme.WriteColored(text, color, newline);
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
        LoaderResult<LoaderConfig> configResult = LoaderConfig.Create(args, AppContext.BaseDirectory);
        if (!configResult.Success || configResult.Value is null)
        {
            LogBanner();
            LogError(configResult.Error?.Message ?? "Missing launch arguments.");
            return;
        }

        LoaderConfig config = configResult.Value;
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
        ModLoadOptions loadOptions = ModLoadOptions.FromEnvironment();

        Directory.CreateDirectory(logsDirectory);
        LoaderLogger.Initialize(loaderLogPath, LoaderConstants.LoaderVersion);
        LogBanner();
        LogInfo($"Game executable: {gameExecutable}");
        LogInfo($"Source data.win: {originalDataWinPath}");
        LogInfo($"Output cache: {outputDataWinPath}");
        LogInfo($"Loader log: {loaderLogPath}");

        LoaderResult installValidation = InstallValidator.Validate(config);
        if (!installValidation.Success)
        {
            LogError(installValidation.Error?.Message ?? "Install validation failed.");
            return;
        }

        if (!Directory.Exists(modsDirectory))
        {
            Directory.CreateDirectory(modsDirectory);
            LogWarn($"Created missing mods folder: {modsDirectory}");
        }
        Directory.CreateDirectory(disabledModsDirectory);
        Directory.CreateDirectory(quarantineDirectory);

        StartupDiagnostics.Run(
            originalDataWinPath,
            gameExecutable,
            loclmDirectory,
            logsDirectory,
            modsDirectory,
            LoaderConstants.LoaderVersion,
            LogInfo,
            LogWarn);

        GameCompatibilityInfo gameCompatibility = GameCompatibilityInfo.Create(originalDataWinPath, gameExecutable);
        SecurityAllowlist securityAllowlist = SecurityAllowlist.Load(securityAllowlistPath, LogWarn);
        string cacheFingerprint = CacheManager.BuildCacheFingerprint(originalDataWinPath, gameExecutable, loclmDirectory, modsDirectory);
        if (CacheManager.IsCacheValid(outputDataWinPath, cacheManifestPath, cacheFingerprint, LogWarn))
        {
            LogSuccess("Cache is up to date. Skipping regeneration.");
            WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, false);
            LogStep("Launching game");
            LogInfo("Executable: " + gameExecutable);
            GameLauncher.Launch(gameExecutable, outputDataWinPath, args, LogWarn, LogError, LogSuccess);
            return;
        }

        LogStep("Cache is missing or outdated. Regenerating patched data.win.");

        LogStep("Opening data.win");
        LogStep($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        GamePatcher gamePatcher = new();
        UndertaleData data = gamePatcher.ReadDataWin(originalDataWinPath, message =>
        {
            LogError("Exception while reading data.win:");
            LogPlain(message);
        });
        FutureProofing.Run(data, gameCompatibility, logsDirectory, loclmDirectory, LoaderConstants.LoaderVersion, LogInfo, LogWarn);

        LogStep("Scanning mods directory");
        LogInfo(modsDirectory);
        string[] blacklisted = {};
        string[] whitelisted = {};
        if (File.Exists(Path.Combine(loclmDirectory, "blacklist.txt")))
        {
            blacklisted = File.ReadAllLines(Path.Combine(loclmDirectory, "blacklist.txt"));
        }
        if (File.Exists(Path.Combine(loclmDirectory, "whitelist.txt")))
        {
            whitelisted = File.ReadAllLines(Path.Combine(loclmDirectory, "whitelist.txt"));
        }

        ResourceChangeTracker changeTracker = new();
        ModLoader modLoader = new(loadOptions, LogInfo, LogStep, LogSuccess, LogWarn, LogError, LogPlain);
        ModLoadExecutionResult modLoadResult = modLoader.LoadMods(
            data,
            modsDirectory,
            disabledModsDirectory,
            quarantineDirectory,
            LoaderConstants.LoaderVersion,
            gameCompatibility,
            securityAllowlist,
            whitelisted,
            blacklisted,
            changeTracker);
        ModLoadPlan loadPlan = modLoadResult.LoadPlan;
        IReadOnlyList<string> loadedMods = modLoadResult.LoadedMods;
        IReadOnlyList<string> failedMods = modLoadResult.FailedMods;
        IReadOnlyList<string> securityBlockedMods = modLoadResult.SecurityBlockedMods;
        bool hasErrored = modLoadResult.HasErrored;

        ModStatusWriter.WriteAll(logsDirectory, LoaderConstants.LoaderVersion, loadOptions.StrictMode, loadPlan.Statuses);
        changeTracker.WriteReport(conflictReportPath);
        IReadOnlyList<string> modConflicts = changeTracker.BuildMenuSummaries();
        if (changeTracker.Conflicts.Count > 0)
        {
            LogWarn($"Detected {changeTracker.Conflicts.Count} possible mod conflict(s). Report: {conflictReportPath}");
        }
        else
        {
            LogSuccess($"No mod conflicts detected. Report: {conflictReportPath}");
        }

        InGameMenuInstaller menuInstaller = new(new GmlAssetLoader(loclmDirectory), LogInfo, LogWarn, LogSuccess);
        bool menuInstalled = menuInstaller.Install(data, modsDirectory, loadedMods, failedMods, securityBlockedMods, modConflicts);
        if (!menuInstalled)
        {
            LogWarn("LOCLM will continue without the in-game menu. Mods can still load and the generated cache can still launch.");
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
        gamePatcher.WriteDataWin(outputDataWinPath, data);
        if (!hasErrored)
        {
            CacheManager.WriteCacheManifest(cacheManifestPath, cacheFingerprint, LogInfo);
        }
        LogSuccess("Done.");
        WriteRunSummary(logsDirectory, originalDataWinPath, gameExecutable, outputDataWinPath, cacheManifestPath, gameCompatibility, hasErrored);
        LogStep("Launching game");
        LogInfo("Executable: " + gameExecutable);
        GameLauncher.Launch(gameExecutable, outputDataWinPath, args, LogWarn, LogError, LogSuccess);
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
