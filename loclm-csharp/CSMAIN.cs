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

//NOTE TO PEOPLE LOOKING AT THIS CODE
//Path.Combine() breaks the thing sometimes. I DONT KNOW WHY, IT SHOULDNT BE HAPPENING.
//It's only SOME of the time too.
//Anyways, that's why I used the messy "path + "\\" + path + "\\" + path...... method. :(

class LOCLM
{
    public static void Main(string[] args)
    {
        void handler(string e, bool isImportant)
        {
            if (isImportant)
            {
                Console.WriteLine("EXCEPTION WHILE READING DATA.WIN: \n" + e);
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

        if (!Directory.Exists(modsDirectory))
        {
            Directory.CreateDirectory(modsDirectory);
        }

        Console.WriteLine("Creating file stream...");
        FileStream readStream = File.OpenRead(originalDataWinPath);
        Console.WriteLine($"Reading unmodified data.win from \"{originalDataWinPath}\"...");
        UndertaleData unmodifiedData = UndertaleIO.Read(
            readStream,
            (UndertaleReader.WarningHandlerDelegate)handler,
            (UndertaleReader.MessageHandlerDelegate)handler2);
        readStream.Dispose();

        UndertaleData data = unmodifiedData;

        Console.WriteLine("Getting mod directory...");
        Console.WriteLine(modsDirectory);
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
        for (int i = 0; i < modDirectories.Length; i++)
        {
            string modPath = Path.Combine(modsDirectory, Path.GetFileName(modDirectories[i]));
            Console.WriteLine($"Getting mod info from \"{modPath}\"...");
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
                    Console.WriteLine("Mod has invalid modinfo.json! Please fix or contact mod developer!");
                    hasErrored = true;
                    break;
                }
            } else
            {
                Console.WriteLine($"There is no mod info file for \"{modPath}\".\nThis isn't an error (most likely).\nWe will still attempt to load the mod without the mod info json file.\nWARNING: THIS WILL ERROR IN A FUTURE VERSION OF LOCLM!!!\nPausing so this message is seen, press enter to continue loading.");
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
            Console.WriteLine($"Loading mod from \"{modPath}\"...");
            string dllPath = Path.Combine(modPath, Path.GetFileName(prioritizedModInfo[i].modPath) + ".dll");
            if (File.Exists(dllPath))
            {
                UndertaleData backupOfBeforeData = data;
                Console.WriteLine("Loading dll from " + dllPath);
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

                    Console.WriteLine("Number of types: " + types.Length.ToString());

                    int audioGroup = 0;
                    loadMethod.Invoke(instanceOfType, new object[] { audioGroup, data });
                    Console.WriteLine($"Successfully loaded mod \"{Path.GetFileName(prioritizedModInfo[i].modPath)}\"");
                }
                catch (TargetInvocationException tie)
                {
                    Exception e = tie.InnerException;
                    Console.WriteLine("ERROR WHILE LOADING DLL:\n" + e.Message + "\nSTACK TRACE:\n" + e.StackTrace + "\nSkipping to next mod...");
                    data = backupOfBeforeData;
                    hasErrored = true;
                }
            }
            else
            {
                Console.WriteLine($"ERROR: Dll file does not exist: {dllPath}! Skipping to next mod...");
                hasErrored = true;
            }
        }

        InstallLoaderAboutButton(data);

        if(hasErrored){
            Console.Write(
@"

********************
There was an error during the mod loading process!
Please review the above error!

If you wish to continue launching the game, type 'y' and press enter.
Any other input will close this window without launching the game.

If you continue to launch the game, the mods you have added may not work as expected, or even may not work at all.
********************
Continue? (y to continue, anything else to exit.)
>");
            string Input = Console.ReadLine();
            if(Input != "y")
                return;
        }

        UndertaleData outputData = data;
        if (File.Exists(outputDataWinPath))
        {
            File.Delete(outputDataWinPath);
        }
        Console.WriteLine("Creating file stream...");
        FileStream writeStream = File.OpenWrite(outputDataWinPath);
        Console.WriteLine($"Writing modified data.win to \"{outputDataWinPath}\"...");
        UndertaleIO.Write(writeStream, outputData);
        writeStream.Dispose();
        Console.WriteLine("Done!");
        Console.WriteLine("Launching Executable from " + gameExecutable);
        string argstring = "";
        for(int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }
        Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
    }

    private static void InstallLoaderAboutButton(UndertaleData data)
    {
        UndertaleModLib.Compiler.CodeImportGroup importGroup = new(data);

        importGroup.QueueReplace(
            "gml_GlobalScript_main_menu_spawn_buttons",
            @"function main_menu_spawn_buttons()
{
    btn_yy = 4;
    global.button_unlock[90] = 1;
    global.button_unlock[91] = 1;
    if (global.start_tutorial_completion == 0)
    {
        var button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 5 + btn_yy, -999, obj_button_menu);
        button.button_index = 52;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 25 + btn_yy, -999, obj_button_menu);
        button.button_index = 2;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 45 + btn_yy, -999, obj_button_menu);
        button.button_index = 44;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 65 + btn_yy, -999, obj_button_menu);
        button.button_index = 3;
    }
    else
    {
        var button = instance_create_depth(room_width / 2, (((room_height / 2) + 15) - 15) + btn_yy, -999, obj_button_menu);
        button.button_index = 1;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 5 + btn_yy, -999, obj_button_menu);
        button.button_index = 53;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 25 + btn_yy, -999, obj_button_menu);
        button.button_index = 19;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 45 + btn_yy, -999, obj_button_menu);
        button.button_index = 2;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 65 + btn_yy, -999, obj_button_menu);
        button.button_index = 44;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 85 + btn_yy, -999, obj_button_menu);
        button.button_index = 3;
    }
    var aboutButton = instance_create_depth((room_width / 2) - 165, (room_height / 2) + 15 + 5 + btn_yy, -999, obj_button_menu);
    aboutButton.button_index = 90;
}");

        importGroup.QueueTrimmedLinesFindReplace(
            data.Code.ByName("gml_Object_obj_button_menu_Alarm_0"),
            @"    case 67:
        my_text = txt(""unlock_dlc"");
        fadeout_dir = 0;
        break;
}",
            @"    case 67:
        my_text = txt(""unlock_dlc"");
        fadeout_dir = 0;
        break;
    case 90:
        my_text = ""LOCLM"";
        fadeout_dir = 1;
        break;
    case 91:
        my_text = ""Back"";
        fadeout_dir = 1;
        break;
}");

        importGroup.QueueTrimmedLinesFindReplace(
            data.Code.ByName("gml_Object_obj_button_menu_Alarm_2"),
            @"        case 67:
            url_open(""https://store.steampowered.com/app/4575790"");
            break;
    }",
            @"        case 67:
            url_open(""https://store.steampowered.com/app/4575790"");
            break;
        case 90:
            global.current_menu = 90;
            global.cursor_index_menu = 0;
            with (obj_button_menu)
            {
                if (option_menu_tab_button == false)
                {
                    instance_destroy();
                }
            }
            var aboutBackButton = instance_create_depth(78, 34, -999, obj_button_menu);
            aboutBackButton.button_index = 91;
            break;
        case 91:
            global.current_menu = 3;
            global.cursor_index_menu = 0;
            with (obj_button_menu)
            {
                if (option_menu_tab_button == false)
                {
                    instance_destroy();
                }
            }
            main_menu_spawn_buttons();
            break;
    }");

        importGroup.QueueAppend(
            data.Code.ByName("gml_Object_obj_ctrl_main_menu_Draw_0"),
            @"
if (global.current_menu == 90)
{
    draw_set_font(global.font_current);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(global.color_yellow);
    draw_text(28, 28, ""LOCLM"");
    draw_set_color(c_white);
    draw_text(28, 48, ""Created and maintained by Estonia.\nMade by the community, for the community.\nBuilt to stay out of the game's way."");
}");

        importGroup.QueueAppend(
            data.Code.ByName("gml_Object_obj_ctrl_main_menu_Step_0"),
            @"
if (global.current_menu == 90)
{
    overlay_darkness_alpha += ((0.8 - overlay_darkness_alpha) * 0.1);
    global.current_darkness += ((0.2 - global.current_darkness) * 0.1);
    logo_yy += ((-70 - logo_yy) * 0.1);
    logo_alpha += ((0 - logo_alpha) * 0.2);
    if (input_check_pressed(""leave""))
    {
        global.current_menu = 3;
        global.cursor_index_menu = 0;
        with (obj_button_menu)
        {
            if (option_menu_tab_button == false)
            {
                instance_destroy();
            }
        }
        main_menu_spawn_buttons();
    }
}");

        importGroup.Import();
        Console.WriteLine("Installed LOCLM about button and info panel.");
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
