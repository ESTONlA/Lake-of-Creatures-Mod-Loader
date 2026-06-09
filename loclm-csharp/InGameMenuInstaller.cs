using UndertaleModLib;
using UndertaleModLib.Models;

public sealed class InGameMenuInstaller
{
    private readonly GmlAssetLoader gmlAssets;
    private readonly Action<string> info;
    private readonly Action<string> warn;
    private readonly Action<string> success;

    public InGameMenuInstaller(GmlAssetLoader gmlAssets, Action<string> info, Action<string> warn, Action<string> success)
    {
        this.gmlAssets = gmlAssets;
        this.info = info;
        this.warn = warn;
        this.success = success;
    }

    public bool Install(
        UndertaleData data,
        string modsDirectory,
        IReadOnlyList<string> loadedMods,
        IReadOnlyList<string> failedMods,
        IReadOnlyList<string> securityBlockedMods,
        IReadOnlyList<string> modConflicts)
    {
        UndertaleGameObject buttonMenu = data.GameObjects.ByName("obj_button_menu");
        if (buttonMenu is null)
        {
            warn("Could not find obj_button_menu; the Antenni menu button was not installed.");
            return false;
        }

        bool alreadyInjected = data.GameObjects.ByName("obj_antenni_button") is not null;
        UndertaleGameObject antenniButton = EnsureClonedMenuButton(data, buttonMenu);
        if (alreadyInjected)
        {
            info("Existing obj_antenni_button found; reusing the injected Antenni menu object.");
        }

        string loadedModsSetup = BuildGmlStringArraySetup("antenni_loaded_mods", "antenni_loaded_mod_count", loadedMods);
        string failedModsSetup = BuildGmlStringArraySetup("antenni_failed_mods", "antenni_failed_mod_count", failedMods);
        string conflictsSetup = BuildGmlStringArraySetup("antenni_mod_conflicts", "antenni_mod_conflict_count", modConflicts);
        string securityWarningTitle = securityBlockedMods.Count == 1
            ? "Antenni blocked a suspicious mod"
            : "Antenni blocked suspicious mods";
        string securityWarningBody = securityBlockedMods.Count == 0
            ? ""
            : BuildSecurityWarningBody(securityBlockedMods);

        try
        {
            UndertaleModLib.Compiler.CodeImportGroup importGroup = new(data);

            importGroup.QueueReplace(
                "gml_GlobalScript_antenni_runtime_log",
                gmlAssets.Load("runtime_logger.gml"));

            importGroup.QueueFindReplace(
                "gml_GlobalScript_main_menu_spawn_buttons",
                "btn_yy = 4;",
                gmlAssets.Load(
                    "main_menu_spawn_buttons.patch.gml",
                    ("__SECURITY_BLOCK_COUNT__", securityBlockedMods.Count.ToString()),
                    ("__SECURITY_WARNING_TITLE__", GmlAssetLoader.QuoteGmlString(securityWarningTitle)),
                    ("__SECURITY_WARNING_BODY__", GmlAssetLoader.QuoteGmlString(securityWarningBody))));

            importGroup.QueueReplace(
                antenniButton.EventHandlerFor(EventType.Create, data),
                gmlAssets.Load("antenni_button_create.gml"));

            importGroup.QueueReplace(
                antenniButton.EventHandlerFor(EventType.Alarm, 0u, data),
                gmlAssets.Load("antenni_button_alarm0.gml"));

            importGroup.QueueReplace(
                antenniButton.EventHandlerFor(EventType.Alarm, 2u, data),
                gmlAssets.Load(
                    "antenni_button_alarm2.gml",
                    ("__LOADED_MODS_SETUP__", loadedModsSetup),
                    ("__FAILED_MODS_SETUP__", failedModsSetup),
                    ("__CONFLICTS_SETUP__", conflictsSetup),
                    ("__MODS_DIRECTORY__", GmlAssetLoader.QuoteGmlString(modsDirectory))));

            importGroup.QueueReplace(
                antenniButton.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
                gmlAssets.Load("antenni_button_draw.gml", ("__LOADER_VERSION__", GmlAssetLoader.QuoteGmlString(LoaderConstants.LoaderVersion))));

            importGroup.QueueAppend(
                "gml_Object_obj_ctrl_main_menu_Draw_0",
                gmlAssets.Load("main_menu_draw_security_warning.gml"));

            importGroup.QueueAppend(
                "gml_Object_obj_ctrl_main_menu_Step_0",
                gmlAssets.Load("main_menu_step.gml"));

            importGroup.Import();
            success("Installed the Antenni Loader menu button and info panel.");
            return true;
        }
        catch (Exception ex)
        {
            warn("The Antenni in-game menu could not be installed: " + ex.Message);
            warn("This usually means the game updated and a menu injection target changed.");
            return false;
        }
    }

    private static string BuildGmlStringArraySetup(string arrayName, string countName, IReadOnlyList<string> values)
    {
        string setup = $"                    global.{arrayName} = [];\n" +
            $"                    global.{countName} = {values.Count};\n";
        for (int i = 0; i < values.Count; i++)
        {
            setup += $"                    global.{arrayName}[{i}] = {GmlAssetLoader.QuoteGmlString(values[i])};\n";
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

    private static UndertaleGameObject EnsureClonedMenuButton(UndertaleData data, UndertaleGameObject buttonMenu)
    {
        if (data.GameObjects.ByName("obj_antenni_button") is UndertaleGameObject existingButton)
        {
            return existingButton;
        }

        UndertaleGameObject antenniButton = new()
        {
            Name = data.Strings.MakeString("obj_antenni_button"),
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

        foreach (UndertaleGameObject.UndertalePhysicsVertex vertex in buttonMenu.PhysicsVertices)
        {
            antenniButton.PhysicsVertices.Add(new UndertaleGameObject.UndertalePhysicsVertex
            {
                X = vertex.X,
                Y = vertex.Y
            });
        }

        data.GameObjects.Add(antenniButton);
        return antenniButton;
    }
}
