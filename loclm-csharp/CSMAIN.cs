using UndertaleModLib;
using System.IO;
using System.Xml;
using System.Drawing;
using System.Reflection;
using System.Diagnostics;
using static System.Environment;
using System.Text.Json;
using System.Text.Json.Nodes;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using UndertaleModLib.Models;

class LOCLM
{
    private const string LoaderVersion = "0.3.0-beta";
    private static readonly SuspiciousPattern[] SuspiciousPatterns =
    {
        new(
            "process_spawn",
            "Starts external processes or shell commands.",
            "System.Diagnostics.Process",
            "Process.Start",
            "Start-Process",
            "cmd.exe",
            "powershell",
            "wscript.exe",
            "cscript.exe",
            "mshta.exe",
            "rundll32.exe",
            "regsvr32.exe"),
        new(
            "native_code",
            "Uses native process/memory APIs or P/Invoke.",
            "DllImport",
            "DllImportAttribute",
            "NativeLibrary.Load",
            "LoadLibrary",
            "GetProcAddress",
            "VirtualAlloc",
            "WriteProcessMemory",
            "CreateRemoteThread"),
        new(
            "network_access",
            "Uses network clients or sockets.",
            "System.Net.Http",
            "HttpClient",
            "WebClient",
            "TcpClient",
            "UdpClient",
            "System.Net.Sockets.Socket",
            "DownloadFile",
            "DownloadString"),
        new(
            "destructive_io",
            "Deletes or overwrites files/directories.",
            "File.Delete",
            "Directory.Delete",
            "DeleteFile",
            "File.WriteAllBytes",
            "File.WriteAllText"),
        new(
            "registry_access",
            "Touches the Windows registry.",
            "Microsoft.Win32.Registry",
            "RegistryKey"),
        new(
            "runtime_code_loading",
            "Builds or loads code dynamically at runtime.",
            "Assembly.Load",
            "Assembly.LoadFrom",
            "Reflection.Emit",
            "Convert.FromBase64String",
            "FromBase64String")
    };

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
            if(File.Exists(Path.Combine(modPath, "modinfo.json")))
            {
                string jsonText = File.ReadAllText(Path.Combine(modPath, "modinfo.json"));
                try
                {
                    ModInfo? modData = JsonSerializer.Deserialize<ModInfo>(jsonText);
                    if (modData is null)
                    {
                        throw new InvalidOperationException("modinfo.json deserialized to null.");
                    }
                    modData.modPath = modDirectories[i];
                    modDataList.Add(modData);
                } catch(Exception ex)
                {
                    LogError($"Mod has invalid modinfo.json: {modPath}");
                    LogPlain(ex.Message);
                    failedMods.Add($"{Path.GetFileName(modPath)}: invalid modinfo.json");
                    hasErrored = true;
                    break;
                }
            } else
            {
                LogWarn($"No modinfo.json for \"{modPath}\".");
                LogWarn("Loading anyway for compatibility.");
                LogWarn("This will become a hard error in a future version of LOCLM.");
                LogPlain("Press Enter to continue.");
                Console.ReadLine();
                ModInfo modData = new ModInfo
                {
                    modName = "Unknown mod " + i.ToString(),
                    authors = new string[]{ "Unknown Author" },
                    description = "This mod does not have a modinfo.json file. This could be because it is an old mod or because the owner forgot to add one.",
                    priority = 999999 // If it doesn't have the json, it should load last.
                };

                if(whitelisted.Length != 0)
                {
                    if(!(Array.IndexOf(whitelisted, modData.modName) >= 0))
                        continue;
                }
                if(Array.IndexOf(blacklisted, modData.modName) >= 0)
                {
                    continue;
                }
                
                modData.modPath = modDirectories[i];
                modDataList.Add(modData);
            }
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
                SecurityScanResult securityScan = ScanModSecurity(modPath, dllPath);
                if (securityScan.IsBlocked)
                {
                    string modDisplayName = GetModDisplayName(prioritizedModInfo[i]);
                    string reason = securityScan.Summary;
                    LogError($"Security scan blocked \"{modDisplayName}\": {reason}");
                    LogWarn("This can be a false positive, but it is not always false. The mod was not loaded.");
                    securityBlockedMods.Add($"{modDisplayName}: {reason}");
                    failedMods.Add($"{modDisplayName}: blocked by security scan");
                    continue;
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
Any other input will close this window without launching the game.

If you continue to launch the game, the mods you have added may not work as expected, or even may not work at all.
********************
Continue? (y to continue, anything else to exit.)
>", ConsoleColor.Yellow, false);
            string? Input = Console.ReadLine();
            if(Input != "y")
                return;
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

        string argstring = "";
        for(int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }
        Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
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
            @"
btn_yy = 4;
    if (!variable_global_exists(""loclm_menu_open""))
    {
        global.loclm_menu_open = false;
    }
    global.loclm_security_block_count = " + securityBlockedMods.Count.ToString() + @";
    global.loclm_security_warning_title = " + QuoteGmlString(securityWarningTitle) + @";
    global.loclm_security_warning_body = " + QuoteGmlString(securityWarningBody) + @";
    if (global.current_menu == 3 && global.loclm_menu_open == false)
    {
        global.button_unlock[90] = 1;
        var button = instance_create_depth(52, (room_height / 2) + 15 + btn_yy, -999, obj_loclm_button);
        button.button_index = 90;
    }");

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Create, data),
            @"
event_inherited();
click_delete = false;");

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 0u, data),
            @"
event_inherited();
my_text = ""LOCLM"";
fadeout_dir = 1;
if (button_index == 91)
{
    my_text = ""Back"";
}
if (button_index == 92)
{
    my_text = ""Copy Mods Path"";
}");

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Alarm, 2u, data),
            @"
var loclm_handled = false;
if (button_index == 90 || button_index == 91 || button_index == 92)
{
    if (variable_instance_exists(id, ""clicked"") && clicked == true)
    {
        loclm_handled = true;
        switch (button_index)
        {
            case 90:
                if (global.current_menu == 3)
                {
                    global.loclm_menu_open = true;
                    global.loclm_loaded_scroll = 0;
                    global.loclm_folder_copied_timer = 0;
" + loadedModsSetup + failedModsSetup + @"
                    global.cursor_index_menu = 0;
                    with (obj_button_menu)
                    {
                        if (option_menu_tab_button == false && object_index != obj_loclm_button)
                        {
                            instance_destroy();
                        }
                    }
                    x = 78;
                    y = room_height - 42;
                    depth = -100001;
                    button_index = 91;
                    clicked = false;
                    fadeout = false;
                    click_delete = false;
                    canclick = true;
                    alarm[0] = 1;
                    var folder_button = instance_create_depth(245, room_height - 42, -100001, obj_loclm_button);
                    folder_button.button_index = 92;
                    folder_button.click_delete = false;
                }
                break;
            case 91:
                global.loclm_menu_open = false;
                global.current_menu = 3;
                global.cursor_index_menu = 0;
                with (obj_loclm_button)
                {
                    instance_destroy();
                }
                main_menu_spawn_buttons();
                break;
            case 92:
                clipboard_set_text(" + QuoteGmlString(modsDirectory) + @");
                global.loclm_folder_copied_timer = 120;
                clicked = false;
                bg_scale = 1.1;
                break;
        }
    }
}
if (loclm_handled == false)
{
    event_inherited();
}");

        importGroup.QueueReplace(
            loclmButton.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
            @"
if (variable_global_exists(""loclm_menu_open"") && global.loclm_menu_open == true && button_index == 91)
{
    var panel_x = 20;
    var panel_y = 16;
    var panel_w = room_width - 40;
    var panel_h = room_height - 82;
    var text_x = panel_x + 18;
    var text_y = panel_y + 14;
    var left_x = text_x;
    var right_x = panel_x + 242;
    var section_y = text_y + 82;

    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_alpha(0.9);
    draw_set_color(global.color_outline);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);
    draw_set_alpha(1);

    draw_set_font(global.font_current);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(global.color_yellow);
    draw_text_outline_b2x(text_x, text_y, ""LOCLM"");
    draw_set_color(c_white);
    draw_text(text_x, text_y + 25, ""Community-built loader for Lake of Creatures"");
    draw_set_color(12632256);
    draw_text(text_x, text_y + 45, ""Made by Estonia, for love of the game."");

    draw_set_color(global.color_yellow);
    draw_text(left_x, section_y, ""Loader Version"");
    draw_set_color(c_white);
    draw_text(left_x + 18, section_y + 22, " + QuoteGmlString(LoaderVersion) + @");

    draw_set_color(global.color_yellow);
    draw_text(right_x, section_y, ""Loaded Mods"");
    draw_set_color(c_white);
    var loaded_visible = 4;
    var loaded_count = global.loclm_loaded_mod_count;
    if (loaded_count <= 0)
    {
        draw_text(right_x + 18, section_y + 22, ""None"");
    }
    else
    {
        var loaded_start = global.loclm_loaded_scroll;
        var loaded_end = min(loaded_count, loaded_start + loaded_visible);
        for (var i = loaded_start; i < loaded_end; i += 1)
        {
            var mod_name = string(global.loclm_loaded_mods[i]);
            if (string_length(mod_name) > 35)
            {
                mod_name = string_copy(mod_name, 1, 32) + ""..."";
            }
            draw_text(right_x + 18, section_y + 22 + ((i - loaded_start) * 20), ""- "" + mod_name);
        }
        if (loaded_count > loaded_visible)
        {
            draw_set_color(8421504);
            draw_text(right_x + 112, section_y, string(loaded_start + 1) + ""-"" + string(loaded_end) + ""/"" + string(loaded_count));
            draw_text(right_x + 18, section_y + 106, ""Scroll: wheel / Up / Down"");
        }
    }

    if (variable_global_exists(""loclm_folder_copied_timer"") && global.loclm_folder_copied_timer > 0)
    {
        draw_set_color(global.color_yellow);
        draw_text(panel_x + panel_w - 138, panel_y + panel_h - 24, ""Path copied."");
    }
}
event_inherited();
");

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Draw_0",
            @"
if (variable_global_exists(""loclm_security_block_count"") && global.loclm_security_block_count > 0)
{
    var loclm_about_open = false;
    if (variable_global_exists(""loclm_menu_open""))
    {
        loclm_about_open = global.loclm_menu_open;
    }
    if (global.current_menu == 3 && loclm_about_open == false)
    {
        var warning_x = 18;
        var warning_y = room_height - 110;
        var warning_w = room_width - 36;
        var warning_h = 70;
        draw_set_alpha(0.86);
        draw_set_color(c_black);
        draw_rectangle(warning_x, warning_y, warning_x + warning_w, warning_y + warning_h, false);
        draw_set_alpha(1);
        draw_set_color(global.color_yellow);
        draw_rectangle(warning_x, warning_y, warning_x + warning_w, warning_y + warning_h, true);
        draw_set_font(global.font_current);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(global.color_yellow);
        draw_text(warning_x + 14, warning_y + 10, string(global.loclm_security_warning_title));
        draw_set_color(c_white);
        draw_text_ext(warning_x + 14, warning_y + 30, string(global.loclm_security_warning_body), 16, warning_w - 28);
        draw_set_alpha(1);
    }
}");

        importGroup.QueueAppend(
            "gml_Object_obj_ctrl_main_menu_Step_0",
            @"
if (variable_global_exists(""loclm_menu_open"") && global.loclm_menu_open == true && global.current_menu != 3)
{
    global.loclm_menu_open = false;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
}

if (variable_global_exists(""loclm_menu_open"") && global.loclm_menu_open == true)
{
    logo_alpha = 0;
    logo_alpha_2 = 0;
    press_any_key_alpha = 0;
    if (!variable_global_exists(""loclm_loaded_scroll""))
    {
        global.loclm_loaded_scroll = 0;
    }
    var loclm_max_scroll = max(0, global.loclm_loaded_mod_count - 5);
    if (mouse_wheel_down() || input_check_pressed(""down""))
    {
        global.loclm_loaded_scroll = min(loclm_max_scroll, global.loclm_loaded_scroll + 1);
    }
    if (mouse_wheel_up() || input_check_pressed(""up""))
    {
        global.loclm_loaded_scroll = max(0, global.loclm_loaded_scroll - 1);
    }
    if (variable_global_exists(""loclm_folder_copied_timer"") && global.loclm_folder_copied_timer > 0)
    {
        global.loclm_folder_copied_timer -= 1;
    }
}

if (variable_global_exists(""loclm_menu_open"") && global.loclm_menu_open == true && input_check_pressed(""leave""))
{
    global.loclm_menu_open = false;
    global.current_menu = 3;
    global.cursor_index_menu = 0;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
    main_menu_spawn_buttons();
}");

        importGroup.Import();
        LogSuccess("Installed LOCLM about button clone and info panel.");
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

    private static SecurityScanResult ScanModSecurity(string modPath, string dllPath)
    {
        List<SecurityFinding> findings = new();
        ScanFileForSuspiciousPatterns(dllPath, Path.GetFileName(dllPath), findings);

        foreach (string filePath in EnumerateSecurityScanFiles(modPath, dllPath))
        {
            if (findings.Count >= SecurityScanResult.MaxFindings)
            {
                break;
            }

            string relativePath = Path.GetRelativePath(modPath, filePath).Replace('\\', '/');
            ScanFileForSuspiciousPatterns(filePath, relativePath, findings);
        }

        return new SecurityScanResult(findings);
    }

    private static IEnumerable<string> EnumerateSecurityScanFiles(string modPath, string mainDllPath)
    {
        if (!Directory.Exists(modPath))
        {
            yield break;
        }

        string mainDllFullPath = Path.GetFullPath(mainDllPath);
        foreach (string filePath in Directory.GetFiles(modPath, "*", SearchOption.AllDirectories)
                     .OrderBy(path => Path.GetRelativePath(modPath, path), StringComparer.OrdinalIgnoreCase))
        {
            string fullPath = Path.GetFullPath(filePath);
            if (string.Equals(fullPath, mainDllFullPath, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            string fileName = Path.GetFileName(filePath);
            if (IsKnownLoaderDependency(fileName))
            {
                continue;
            }

            string extension = Path.GetExtension(filePath).ToLowerInvariant();
            if (extension is ".dll" or ".exe" or ".gml" or ".cs" or ".json" or ".txt" or ".cfg" or ".ini")
            {
                yield return filePath;
            }
        }
    }

    private static bool IsKnownLoaderDependency(string fileName) =>
        fileName.Equals("UndertaleModLib.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("Underanalyzer.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("System.Drawing.Common.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("ICSharpCode.SharpZipLib.dll", StringComparison.OrdinalIgnoreCase);

    private static void ScanFileForSuspiciousPatterns(string path, string displayPath, List<SecurityFinding> findings)
    {
        const long maxScanBytes = 16 * 1024 * 1024;
        FileInfo file = new(path);
        if (!file.Exists || file.Length > maxScanBytes)
        {
            return;
        }

        byte[] bytes = File.ReadAllBytes(path);
        string asciiText = ExtractPrintableAscii(bytes);
        string utf16Text = Encoding.Unicode.GetString(bytes);
        foreach (SuspiciousPattern pattern in SuspiciousPatterns)
        {
            if (findings.Count >= SecurityScanResult.MaxFindings)
            {
                return;
            }

            foreach (string needle in pattern.Needles)
            {
                if (ContainsIgnoreCase(asciiText, needle) || ContainsIgnoreCase(utf16Text, needle))
                {
                    findings.Add(new SecurityFinding(pattern.Id, displayPath, pattern.Description));
                    break;
                }
            }
        }
    }

    private static string ExtractPrintableAscii(byte[] bytes)
    {
        char[] chars = new char[bytes.Length];
        for (int i = 0; i < bytes.Length; i++)
        {
            byte value = bytes[i];
            chars[i] = value >= 32 && value <= 126 ? (char)value : ' ';
        }

        return new string(chars);
    }

    private static bool ContainsIgnoreCase(string haystack, string needle) =>
        haystack.Contains(needle, StringComparison.OrdinalIgnoreCase);

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

public class ModInfo
{
    public string modPath = "";
    public string modName { get; set; } = "";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "";
    public int priority { get; set; }
}

public class CacheManifest
{
    public string loaderVersion { get; set; } = "";
    public string fingerprint { get; set; } = "";
    public string createdUtc { get; set; } = "";
}

public sealed record SuspiciousPattern(string Id, string Description, params string[] Needles);

public sealed record SecurityFinding(string Rule, string File, string Description);

public sealed class SecurityScanResult
{
    public const int MaxFindings = 50;

    public SecurityScanResult(IReadOnlyList<SecurityFinding> findings)
    {
        Findings = findings;
    }

    public IReadOnlyList<SecurityFinding> Findings { get; }
    public bool IsBlocked => Findings.Count > 0;

    public string Summary
    {
        get
        {
            if (Findings.Count == 0)
            {
                return "clean";
            }

            SecurityFinding first = Findings[0];
            string extra = Findings.Count > 1 ? $" (+{Findings.Count - 1} more)" : "";
            return $"{first.Rule} in {first.File}{extra}";
        }
    }
}
