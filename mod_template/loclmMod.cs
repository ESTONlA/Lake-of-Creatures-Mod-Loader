using UndertaleModLib;

namespace CreatureProbe;

public class CreatureProbe
{
    public void Load(int audiogroup, UndertaleData data)
    {
        if (audiogroup != 0)
        {
            return;
        }

        ModContext context = ModContext.Create(data);
        ModConfig config = context.LoadJson<ModConfig>("data/mod-config.json", required: false) ?? new ModConfig();

        context.Log("Booting template sample...");
        context.Log($"Loaded manifest for {context.Manifest.modName}.");

        if (config.VerboseLogging)
        {
            context.Log($"Discovered {context.CodeFiles.Count} code asset file(s).");
        }

        InstallMainMenuTab(context, config);
    }

    private static void InstallMainMenuTab(ModContext context, ModConfig config)
    {
        if (!config.EnableMenuTab)
        {
            context.Log("Menu tab sample is disabled in mod-config.json.");
            return;
        }

        context.FindReplaceCode(
            "gml_GlobalScript_main_menu_spawn_buttons",
            "btn_yy = 4;",
            "btn_yy = 4;\n    global.button_unlock[68] = 1;");
        context.FindReplaceCode(
            "gml_GlobalScript_main_menu_spawn_buttons",
            "button.button_index = 3;",
            "button.button_index = 3;\n        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 105 + btn_yy, -999, obj_button_menu);\n        button.button_index = 68;");
        context.FindReplaceCode(
            "gml_Object_obj_button_menu_Alarm_0",
            "    case 67:\n        my_text = txt(\"unlock_dlc\");\n        fadeout_dir = 0;\n        break;\n}",
            "    case 67:\n        my_text = txt(\"unlock_dlc\");\n        fadeout_dir = 0;\n        break;\n    case 68:\n        my_text = " + QuoteGmlString(config.MainMenuButtonLabel) + ";\n        fadeout_dir = 1;\n        break;\n}");
        context.FindReplaceCode(
            "gml_Object_obj_button_menu_Alarm_2",
            "        case 67:\n            url_open(\"https://store.steampowered.com/app/4575790\");\n            break;\n    }",
            "        case 67:\n            url_open(\"https://store.steampowered.com/app/4575790\");\n            break;\n        case 68:\n            global.current_menu = 7;\n            break;\n    }");
        context.AppendCodeFromFile(
            "hooks/obj_ctrl_main_menu_Draw_0.gml",
            "gml_Object_obj_ctrl_main_menu_Draw_0",
            ("__MENU_TAB_TITLE__", QuoteGmlString(config.MenuTabTitle)),
            ("__MENU_TAB_BODY__", QuoteGmlString(config.MenuTabBody)));
        context.AppendCodeFromFile(
            "hooks/obj_ctrl_main_menu_Step_0.gml",
            "gml_Object_obj_ctrl_main_menu_Step_0");
        context.AppendCodeFromFile(
            "hooks/obj_ctrl_main_menu_Alarm_2.gml",
            "gml_Object_obj_ctrl_main_menu_Alarm_2");

        context.Log("Installed the Test Mod - Estonia main-menu tab.");
    }

    private static string QuoteGmlString(string value) =>
        "\"" + value.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"";
}
