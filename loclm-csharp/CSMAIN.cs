using UndertaleModLib;
using System.IO;
using System.Reflection;
using System.Diagnostics;
using System.Text.Json;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UndertaleModLib.Models;

class LOCLM
{
    private const string LoaderVersion = "0.3.0-beta";

    private static bool SupportsColor => !Console.IsOutputRedirected;

    private static void WriteColored(string text, ConsoleColor color, bool newline = true)
    {
        if (SupportsColor)
        {
            ConsoleColor previous = Console.ForegroundColor;
            Console.ForegroundColor = color;
            if (newline)
            {
                Console.WriteLine(text);
            }
            else
            {
                Console.Write(text);
            }
            Console.ForegroundColor = previous;
            return;
        }

        if (newline)
        {
            Console.WriteLine(text);
        }
        else
        {
            Console.Write(text);
        }
    }

    private static void LogBanner()
    {
        WriteColored("==================================================", ConsoleColor.DarkCyan);
        WriteColored(" LOCLM - Lake of Creatures Loader", ConsoleColor.Cyan);
        WriteColored("==================================================", ConsoleColor.DarkCyan);
    }

    private static void LogInfo(string message) => WriteColored($"[INFO] {message}", ConsoleColor.Gray);
    private static void LogStep(string message) => WriteColored($"[ • ] {message}", ConsoleColor.Cyan);
    private static void LogSuccess(string message) => WriteColored($"[ OK ] {message}", ConsoleColor.Green);
    private static void LogWarn(string message) => WriteColored($"[WARN] {message}", ConsoleColor.Yellow);
    private static void LogError(string message) => WriteColored($"[ERR ] {message}", ConsoleColor.Red);
    private static void LogPlain(string message) => WriteColored(message, ConsoleColor.White);

    public static void Main(string[] args)
    {
        if (args.Length < 2)
        {
            LogBanner();
            LogError("Missing launch arguments.");
            LogInfo("Usage: loclm-csharp.exe <data.win> <game executable> [game args...]");
            return;
        }

        void handler(string e, bool isImportant)
        {
            if (isImportant)
            {
                LogError("Exception while reading data.win:");
                LogPlain(e);
            }
            return;
        }
        void handler2(string e)
        {
            //Console.WriteLine(e);
            return;
        }
        string originalDataWinPath = args[0];
        string gameExecutable = args[1];
        string loclmDirectory = AppContext.BaseDirectory;
        string dataDirectory = Path.GetDirectoryName(originalDataWinPath) ?? Directory.GetCurrentDirectory();
        string outputDataWinPath = Path.Combine(dataDirectory, "LOCLM_CACHE_data.win");
        string cacheManifestPath = Path.Combine(dataDirectory, "LOCLM_CACHE_manifest.json");
        string modsDirectory = Path.Combine(loclmDirectory, "mods");
        string securityAllowlistPath = Path.Combine(loclmDirectory, "security_allowlist.json");

        LogBanner();
        LogInfo($"Game executable: {gameExecutable}");
        LogInfo($"Source data.win: {originalDataWinPath}");
        LogInfo($"Output cache: {outputDataWinPath}");

        if (!File.Exists(originalDataWinPath))
        {
            LogError($"data.win was not found: {originalDataWinPath}");
            return;
        }

        if (!File.Exists(gameExecutable))
        {
            LogError($"Game executable was not found: {gameExecutable}");
            return;
        }

        if (!Directory.Exists(modsDirectory))
        {
            Directory.CreateDirectory(modsDirectory);
            LogWarn($"Created missing mods folder: {modsDirectory}");
        }

        SecurityAllowlist securityAllowlist = SecurityAllowlist.Load(securityAllowlistPath, LogWarn);
        string cacheFingerprint = BuildCacheFingerprint(originalDataWinPath, gameExecutable, loclmDirectory, modsDirectory);
        if (IsCacheValid(outputDataWinPath, cacheManifestPath, cacheFingerprint))
        {
            LogSuccess("Cache is up to date. Skipping regeneration.");
            LogStep("Launching game");
            LogInfo("Executable: " + gameExecutable);
            LaunchGame(gameExecutable, outputDataWinPath, args);
            return;
        }

        LogStep("Cache is missing or outdated. Regenerating patched data.win.");

        LogStep("Opening data.win");
        LogStep($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        UndertaleData unmodifiedData;
        using (FileStream readStream = File.OpenRead(originalDataWinPath))
        {
            unmodifiedData = UndertaleIO.Read(
                readStream,
                (UndertaleReader.WarningHandlerDelegate)handler,
                (UndertaleReader.MessageHandlerDelegate)handler2);
        }

        UndertaleData data = unmodifiedData;

        LogStep("Scanning mods directory");
        LogInfo(modsDirectory);
        string[] modDirectories = Directory.GetDirectories(modsDirectory).OrderBy(path => path, StringComparer.OrdinalIgnoreCase).ToArray();
        bool hasErrored = false;
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
        List<ModInfo> modDataList = new List<ModInfo>();
        List<string> loadedMods = new List<string>();
        List<string> failedMods = new List<string>();
        List<string> securityBlockedMods = new List<string>();
        for (int i = 0; i < modDirectories.Length; i++)
        {
            string modPath = Path.Combine(modsDirectory, Path.GetFileName(modDirectories[i]));
            LogStep($"Reading mod metadata from \"{modPath}\"");

            ModManifestResult manifest = ModManifestValidator.Load(modPath);
            if (!manifest.Success || manifest.ModInfo is null)
            {
                string error = manifest.Error ?? "invalid modinfo.json.";
                LogError($"Skipping mod \"{Path.GetFileName(modPath)}\": {error}");
                failedMods.Add($"{Path.GetFileName(modPath)}: {error}");
                continue;
            }

            ModInfo modData = manifest.ModInfo;
            if (whitelisted.Length != 0 && !(Array.IndexOf(whitelisted, modData.modName) >= 0))
            {
                LogWarn($"Skipping \"{modData.modName}\" because it is not in whitelist.txt.");
                continue;
            }

            if (Array.IndexOf(blacklisted, modData.modName) >= 0)
            {
                LogWarn($"Skipping \"{modData.modName}\" because it is in blacklist.txt.");
                continue;
            }

            modDataList.Add(modData);
        }
        List<ModInfo> prioritizedModInfo = modDataList.OrderBy(o => o.priority).ToList();
        for (int i = 0; i < prioritizedModInfo.Count; i++)
        {
            if(hasErrored) break;
            string modPath =  Path.Combine(modsDirectory, Path.GetFileName(prioritizedModInfo[i].modPath));
            LogStep($"Loading mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
            string dllPath = Path.Combine(modPath, Path.GetFileName(prioritizedModInfo[i].modPath) + ".dll");
            if (File.Exists(dllPath))
            {
                SecurityScanResult securityScan = SecurityScanner.ScanMod(modPath, dllPath, securityAllowlist);
                string modDisplayName = GetModDisplayName(prioritizedModInfo[i]);
                LogInfo($"\"{modDisplayName}\" Hash \"{securityScan.ModHash}\"");
                if (securityScan.IsBlocked)
                {
                    string reason = securityScan.Summary;
                    LogError($"Security scan blocked \"{modDisplayName}\": {reason}");
                    LogWarn($"Allowlist hash for review only: {securityScan.ModHash}");
                    LogWarn("This can be a false positive, but it is not always false. The mod was not loaded.");
                    securityBlockedMods.Add($"{modDisplayName}: {reason}");
                    failedMods.Add($"{modDisplayName}: blocked by security scan");
                    continue;
                }
                if (securityScan.IsAllowedByAllowlist)
                {
                    LogWarn($"Security scan found suspicious code in \"{GetModDisplayName(prioritizedModInfo[i])}\", but its mod hash is allowlisted.");
                }

                UndertaleData backupOfBeforeData = data;
                LogInfo("DLL: " + dllPath);
                try
                {
                    Assembly assembly = Assembly.LoadFrom(dllPath);

                    Type[] types = assembly.GetTypes();
                    if (types.Length == 0)
                    {
                        throw new InvalidOperationException("Assembly has no loadable types.");
                    }

                    Type type = types[0];
                    MethodInfo? loadMethod = type.GetMethod("Load");
                    for (var t = 0; t < types.Length; t++)
                    {
                        if (loadMethod != null)
                        {
                            break;
                        }
                        type = types[t];
                        loadMethod = type.GetMethod("Load");
                    }
                    if (loadMethod is null)
                    {
                        throw new InvalidOperationException("Mod does not expose a public Load method.");
                    }

                    object? instanceOfType = Activator.CreateInstance(type);
                    if (instanceOfType is null)
                    {
                        throw new InvalidOperationException("Could not create mod entry point instance.");
                    }

                    LogInfo("Number of types: " + types.Length.ToString());

                    int audioGroup = 0;
                    loadMethod.Invoke(instanceOfType, new object[] { audioGroup, data });
                    LogSuccess($"Loaded mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
                    loadedMods.Add(GetModDisplayName(prioritizedModInfo[i]));
                }
                catch (TargetInvocationException tie)
                {
                    Exception e = tie.InnerException ?? tie;
                    LogError($"Error while loading \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\": {e.Message}");
                    LogPlain(e.StackTrace ?? "");
                    LogWarn("Skipping to next mod.");
                    failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: {e.Message}");
                    data = backupOfBeforeData;
                    hasErrored = true;
                }
                catch (Exception ex)
                {
                    LogError($"Error while loading \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\": {ex.Message}");
                    LogPlain(ex.StackTrace ?? "");
                    LogWarn("Skipping to next mod.");
                    failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: {ex.Message}");
                    data = backupOfBeforeData;
                    hasErrored = true;
                }
            }
            else
            {
                LogError($"DLL file does not exist: {dllPath}");
                LogWarn("Skipping to next mod.");
                failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: missing DLL");
                hasErrored = true;
            }
        }

        InstallLoaderAboutButton(data, modsDirectory, loadedMods, failedMods, securityBlockedMods);

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
            WaitForYes();
        }

        UndertaleData outputData = data;
        if (File.Exists(outputDataWinPath))
        {
            File.Delete(outputDataWinPath);
        }
        LogStep("Creating output stream");
        LogStep($"Writing modified data.win to \"{outputDataWinPath}\"...");
        using (FileStream writeStream = File.OpenWrite(outputDataWinPath))
        {
            UndertaleIO.Write(writeStream, outputData);
        }
        if (!hasErrored)
        {
            WriteCacheManifest(cacheManifestPath, cacheFingerprint);
        }
        LogSuccess("Done.");
        LogStep("Launching game");
        LogInfo("Executable: " + gameExecutable);
        LaunchGame(gameExecutable, outputDataWinPath, args);
    }

    private static void LaunchGame(string gameExecutable, string outputDataWinPath, string[] args)
    {
        if (string.Equals(Environment.GetEnvironmentVariable("LOCLM_SKIP_LAUNCH"), "1", StringComparison.Ordinal))
        {
            LogWarn("LOCLM_SKIP_LAUNCH=1 is set. Not launching the game.");
            return;
        }

        WriteColored("", ConsoleColor.White);
        WriteColored("LOCLM is ready to relaunch the game.", ConsoleColor.Yellow);
        WriteColored("Type 'y' and press Enter to continue. This window will stay open until then.", ConsoleColor.Yellow);
        WaitForYes();

        string argstring = "";
        for(int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }
        Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
    }

    private static void WaitForYes()
    {
        while (true)
        {
            WriteColored("> ", ConsoleColor.Yellow, false);
            string? input = Console.ReadLine();
            if (string.Equals(input?.Trim(), "y", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            LogWarn("Type 'y' and press Enter to continue.");
        }
    }

    private static bool IsCacheValid(string outputDataWinPath, string cacheManifestPath, string cacheFingerprint)
    {
        if (!File.Exists(outputDataWinPath) || !File.Exists(cacheManifestPath))
        {
            return false;
        }

        try
        {
            CacheManifest? manifest = JsonSerializer.Deserialize<CacheManifest>(File.ReadAllText(cacheManifestPath));
            return manifest?.fingerprint == cacheFingerprint;
        }
        catch (Exception ex)
        {
            LogWarn($"Could not read cache manifest: {ex.Message}");
            return false;
        }
    }

    private static void WriteCacheManifest(string cacheManifestPath, string cacheFingerprint)
    {
        CacheManifest manifest = new()
        {
            loaderVersion = LoaderVersion,
            fingerprint = cacheFingerprint,
            createdUtc = DateTime.UtcNow.ToString("O")
        };
        JsonSerializerOptions options = new() { WriteIndented = true };
        File.WriteAllText(cacheManifestPath, JsonSerializer.Serialize(manifest, options));
        LogInfo($"Wrote cache manifest: {cacheManifestPath}");
    }

    private static string BuildCacheFingerprint(
        string originalDataWinPath,
        string gameExecutable,
        string loclmDirectory,
        string modsDirectory)
    {
        StringBuilder builder = new();
        builder.AppendLine("loclm-cache-v1");
        builder.AppendLine("loader-version=" + LoaderVersion);

        AppendFileMetadata(builder, "data.win", originalDataWinPath);
        AppendFileHash(builder, "game-executable", gameExecutable);
        AppendFileHash(builder, "loader-exe", Environment.ProcessPath ?? "");
        AppendFileHash(builder, "loader-dll", Path.Combine(loclmDirectory, "loclm-csharp.dll"));
        AppendFileHash(builder, "proxy-dll", Path.Combine(Path.GetDirectoryName(originalDataWinPath) ?? "", "version.dll"));
        AppendFileHash(builder, "blacklist", Path.Combine(loclmDirectory, "blacklist.txt"));
        AppendFileHash(builder, "whitelist", Path.Combine(loclmDirectory, "whitelist.txt"));
        AppendFileHash(builder, "security-allowlist", Path.Combine(loclmDirectory, "security_allowlist.json"));
        AppendDirectoryFingerprint(builder, "gml-assets", Path.Combine(loclmDirectory, "assets", "gml"));
        AppendDirectoryFingerprint(builder, "mods", modsDirectory);

        using SHA256 sha = SHA256.Create();
        return Convert.ToHexString(sha.ComputeHash(Encoding.UTF8.GetBytes(builder.ToString())));
    }

    private static void AppendFileMetadata(StringBuilder builder, string label, string path)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        builder.AppendLine($"{label}.length={file.Length}");
        builder.AppendLine($"{label}.writeUtc={file.LastWriteTimeUtc.Ticks}");
    }

    private static void AppendFileHash(StringBuilder builder, string label, string path)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        builder.AppendLine($"{label}.length={file.Length}");
        builder.AppendLine($"{label}.sha256={ComputeFileHash(path)}");
    }

    private static void AppendDirectoryFingerprint(StringBuilder builder, string label, string directory)
    {
        if (!Directory.Exists(directory))
        {
            builder.AppendLine($"{label}=missing");
            return;
        }

        builder.AppendLine($"{label}=exists");
        string[] files = Directory.GetFiles(directory, "*", SearchOption.AllDirectories)
            .OrderBy(path => Path.GetRelativePath(directory, path), StringComparer.OrdinalIgnoreCase)
            .ToArray();
        builder.AppendLine($"{label}.fileCount={files.Length}");
        foreach (string file in files)
        {
            string relativePath = Path.GetRelativePath(directory, file).Replace('\\', '/');
            builder.AppendLine($"{label}.file={relativePath}");
            AppendFileHash(builder, $"{label}.{relativePath}", file);
        }
    }

    private static string ComputeFileHash(string path)
    {
        using SHA256 sha = SHA256.Create();
        using FileStream stream = File.OpenRead(path);
        return Convert.ToHexString(sha.ComputeHash(stream));
    }

    private static void InstallLoaderAboutButton(
        UndertaleData data,
        string modsDirectory,
        IReadOnlyList<string> loadedMods,
        IReadOnlyList<string> failedMods,
        IReadOnlyList<string> securityBlockedMods)
    {
        UndertaleGameObject buttonMenu = data.GameObjects.ByName("obj_button_menu");
        if (buttonMenu is null)
        {
            LogError("Could not find obj_button_menu; LOCLM menu button was not installed.");
            return;
        }

        UndertaleGameObject loclmButton = EnsureClonedMenuButton(data, buttonMenu);
        string loadedModsSetup = BuildGmlStringArraySetup("loclm_loaded_mods", "loclm_loaded_mod_count", loadedMods);
        string failedModsSetup = BuildGmlStringArraySetup("loclm_failed_mods", "loclm_failed_mod_count", failedMods);
        string securityWarningTitle = securityBlockedMods.Count == 1
            ? "LOCLM blocked a suspicious mod"
            : "LOCLM blocked suspicious mods";
        string securityWarningBody = securityBlockedMods.Count == 0
            ? ""
            : BuildSecurityWarningBody(securityBlockedMods);

        UndertaleModLib.Compiler.CodeImportGroup importGroup = new(data);

        importGroup.QueueFindReplace(
            "gml_GlobalScript_main_menu_spawn_buttons",
            "btn_yy = 4;",
            LoadGmlAsset(
                "main_menu_spawn_buttons.patch.gml",
                ("__SECURITY_BLOCK_COUNT__", securityBlockedMods.Count.ToString()),
                ("__SECURITY_WARNING_TITLE__", QuoteGmlString(securityWarningTitle)),
                ("__SECURITY_WARNING_BODY__", QuoteGmlString(securityWarningBody))));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Create, data),
            LoadGmlAsset("loclm_button_create.gml"));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 0u, data),
            LoadGmlAsset("loclm_button_alarm0.gml"));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 2u, data),
            LoadGmlAsset(
                "loclm_button_alarm2.gml",
                ("__LOADED_MODS_SETUP__", loadedModsSetup),
                ("__FAILED_MODS_SETUP__", failedModsSetup),
                ("__MODS_DIRECTORY__", QuoteGmlString(modsDirectory))));

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
            LoadGmlAsset("loclm_button_draw.gml", ("__LOADER_VERSION__", QuoteGmlString(LoaderVersion))));

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Draw_0",
            LoadGmlAsset("main_menu_draw_security_warning.gml"));

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Step_0",
            LoadGmlAsset("main_menu_step.gml"));

        importGroup.Import();
        LogSuccess("Installed LOCLM about button clone and info panel.");
    }

    private static string LoadGmlAsset(string fileName, params (string Token, string Value)[] replacements)
    {
        string path = Path.Combine(AppContext.BaseDirectory, "assets", "gml", fileName);
        if (!File.Exists(path))
        {
            throw new FileNotFoundException("Missing LOCLM GML asset.", path);
        }

        string code = File.ReadAllText(path);
        foreach ((string token, string value) in replacements)
        {
            code = code.Replace(token, value);
        }

        return code;
    }

    private static string GetModDisplayName(ModInfo modInfo)
    {
        if (!string.IsNullOrWhiteSpace(modInfo.modName))
        {
            return modInfo.modName;
        }

        if (!string.IsNullOrWhiteSpace(modInfo.modPath))
        {
            return Path.GetFileName(modInfo.modPath);
        }

        return "Unknown Mod";
    }

    private static string BuildGmlStringArraySetup(string arrayName, string countName, IReadOnlyList<string> values)
    {
        string setup = $"                    global.{arrayName} = [];\n" +
            $"                    global.{countName} = {values.Count};\n";
        for (int i = 0; i < values.Count; i++)
        {
            setup += $"                    global.{arrayName}[{i}] = {QuoteGmlString(values[i])};\n";
        }

        return setup;
    }

    private static string BuildSecurityWarningBody(IReadOnlyList<string> securityBlockedMods)
    {
        string firstBlockedMod = TrimForMenu(securityBlockedMods[0], 46);
        string extra = securityBlockedMods.Count > 1
            ? $" +{securityBlockedMods.Count - 1} more"
            : "";
        return "Blocked: " + firstBlockedMod + extra +
            "\nThis can be a false positive, but it is not always false. The mod was not loaded.";
    }

    private static string TrimForMenu(string value, int maxLength)
    {
        if (value.Length <= maxLength)
        {
            return value;
        }

        return value[..Math.Max(0, maxLength - 3)] + "...";
    }

    private static string QuoteGmlString(string value) =>
        "\"" + value
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("\r", "")
            .Replace("\n", "\\n") + "\"";

    private static UndertaleGameObject EnsureClonedMenuButton(UndertaleData data, UndertaleGameObject buttonMenu)
    {
        if (data.GameObjects.ByName("obj_loclm_button") is UndertaleGameObject existingButton)
        {
            return existingButton;
        }

        UndertaleGameObject loclmButton = new()
        {
            Name = data.Strings.MakeString("obj_loclm_button"),
            ParentId = buttonMenu,
            Sprite = buttonMenu.Sprite,
            TextureMaskId = buttonMenu.TextureMaskId,
            Visible = buttonMenu.Visible,
            Managed = buttonMenu.Managed,
            Solid = buttonMenu.Solid,
            Depth = buttonMenu.Depth,
            Persistent = buttonMenu.Persistent,
            UsesPhysics = buttonMenu.UsesPhysics,
            IsSensor = buttonMenu.IsSensor,
            CollisionShape = buttonMenu.CollisionShape,
            Density = buttonMenu.Density,
            Restitution = buttonMenu.Restitution,
            Group = buttonMenu.Group,
            LinearDamping = buttonMenu.LinearDamping,
            AngularDamping = buttonMenu.AngularDamping,
            Friction = buttonMenu.Friction,
            Awake = buttonMenu.Awake,
            Kinematic = buttonMenu.Kinematic
        };

        foreach (var vertex in buttonMenu.PhysicsVertices)
        {
            loclmButton.PhysicsVertices.Add(new UndertaleGameObject.UndertalePhysicsVertex
            {
                X = vertex.X,
                Y = vertex.Y
            });
        }

        data.GameObjects.Add(loclmButton);
        return loclmButton;
    }

}
