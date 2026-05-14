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
using UndertaleModLib.Models;

//NOTE TO PEOPLE LOOKING AT THIS CODE
//Path.Combine() breaks the thing sometimes. I DONT KNOW WHY, IT SHOULDNT BE HAPPENING.
//It's only SOME of the time too.
//Anyways, that's why I used the messy "path + "\\" + path + "\\" + path...... method. :(

class LOCLM
{
    private static readonly string LoaderVersion =
        Assembly.GetExecutingAssembly().GetName().Version?.ToString() ?? "dev";

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
        string loclmDirectory = Path.GetDirectoryName(System.Reflection.Assembly.GetExecutingAssembly().Location);
        string outputDataWinPath = Path.Combine(Path.GetDirectoryName(originalDataWinPath), "LOCLM_CACHE_data.win");
        string modsDirectory = Path.Combine(loclmDirectory, "mods");

        LogBanner();
        LogInfo($"Game executable: {gameExecutable}");
        LogInfo($"Source data.win: {originalDataWinPath}");
        LogInfo($"Output cache: {outputDataWinPath}");

        if (!Directory.Exists(modsDirectory))
        {
            Directory.CreateDirectory(modsDirectory);
            LogWarn($"Created missing mods folder: {modsDirectory}");
        }

        LogStep("Opening data.win");
        FileStream readStream = File.OpenRead(originalDataWinPath);
        LogStep($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        UndertaleData unmodifiedData = UndertaleIO.Read(
            readStream,
            (UndertaleReader.WarningHandlerDelegate)handler,
            (UndertaleReader.MessageHandlerDelegate)handler2);
        readStream.Dispose();

        UndertaleData data = unmodifiedData;

        LogStep("Scanning mods directory");
        LogInfo(modsDirectory);
        string[] modDirectories = Directory.GetDirectories(modsDirectory);
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
        for (int i = 0; i < modDirectories.Length; i++)
        {
            string modPath = Path.Combine(modsDirectory, Path.GetFileName(modDirectories[i]));
            LogStep($"Reading mod metadata from \"{modPath}\"");
            if(File.Exists(Path.Combine(modPath, "modinfo.json")))
            {
                string jsonText = File.ReadAllText(Path.Combine(modPath, "modinfo.json"));
                try
                {
                    ModInfo modData = JsonSerializer.Deserialize<ModInfo>(jsonText);
                    modData.modPath = modDirectories[i];
                    modDataList.Add(modData);
                } catch(Exception e)
                {
                    LogError($"Mod has invalid modinfo.json: {modPath}");
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
                UndertaleData backupOfBeforeData = data;
                LogInfo("DLL: " + dllPath);
                try
                {
                    Assembly assembly = Assembly.LoadFrom(dllPath);

                    Type[] types = assembly.GetTypes();

                    Type type = types[0];
                    MethodInfo loadMethod = type.GetMethod("Load");
                    for (var t = 0; t < types.Length; t++)
                    {
                        if (loadMethod != null)
                        {
                            break;
                        }
                        type = types[t];
                        loadMethod = type.GetMethod("Load");
                    }
                    object instanceOfType = Activator.CreateInstance(type);

                    LogInfo("Number of types: " + types.Length.ToString());

                    int audioGroup = 0;
                    loadMethod.Invoke(instanceOfType, new object[] { audioGroup, data });
                    LogSuccess($"Loaded mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
                    loadedMods.Add(GetModDisplayName(prioritizedModInfo[i]));
                }
                catch (TargetInvocationException tie)
                {
                    Exception e = tie.InnerException;
                    LogError($"Error while loading \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\": {e.Message}");
                    LogPlain(e.StackTrace ?? "");
                    LogWarn("Skipping to next mod.");
                    failedMods.Add($"{GetModDisplayName(prioritizedModInfo[i])}: {e.Message}");
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

        InstallLoaderAboutButton(data, modsDirectory, loadedMods, failedMods);

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
            string Input = Console.ReadLine();
            if(Input != "y")
                return;
        }

        UndertaleData outputData = data;
        if (File.Exists(outputDataWinPath))
        {
            File.Delete(outputDataWinPath);
        }
        LogStep("Creating output stream");
        FileStream writeStream = File.OpenWrite(outputDataWinPath);
        LogStep($"Writing modified data.win to \"{outputDataWinPath}\"...");
        UndertaleIO.Write(writeStream, outputData);
        writeStream.Dispose();
        LogSuccess("Done.");
        LogStep("Launching game");
        LogInfo("Executable: " + gameExecutable);
        string argstring = "";
        for(int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }
        Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
    }

    private static void InstallLoaderAboutButton(
        UndertaleData data,
        string modsDirectory,
        IReadOnlyList<string> loadedMods,
        IReadOnlyList<string> failedMods)
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
    public string modName { get; set; }
    public string[] authors { get; set; }
    public string description { get; set; }
    public int priority { get; set; }
}
