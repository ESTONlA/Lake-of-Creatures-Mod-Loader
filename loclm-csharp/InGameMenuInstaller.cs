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
            warn("Could not find obj_button_menu; LOCLM menu button was not installed.");
            return false;
        }

        bool alreadyInjected = data.GameObjects.ByName("obj_loclm_button") is not null;
        UndertaleGameObject loclmButton = EnsureClonedMenuButton(data, buttonMenu);
        UndertaleGameObject mpController = EnsurePlainObject(data, "obj_lm_mp_controller", persistent: true, visible: false);
        UndertaleGameObject remotePlayer = EnsurePlainObject(data, "obj_lm_remote_player", persistent: false, visible: true);
        UndertaleGameObject remoteEntity = EnsurePlainObject(data, "obj_lm_remote_entity", persistent: false, visible: true);
        if (alreadyInjected)
        {
            info("Existing obj_loclm_button found; reusing already-injected LOCLM menu object.");
        }

        string loadedModsSetup = BuildGmlStringArraySetup("loclm_loaded_mods", "loclm_loaded_mod_count", loadedMods);
        string failedModsSetup = BuildGmlStringArraySetup("loclm_failed_mods", "loclm_failed_mod_count", failedMods);
        string conflictsSetup = BuildGmlStringArraySetup("loclm_mod_conflicts", "loclm_mod_conflict_count", modConflicts);
        string securityWarningTitle = securityBlockedMods.Count == 1
            ? "LOCLM blocked a suspicious mod"
            : "LOCLM blocked suspicious mods";
        string securityWarningBody = securityBlockedMods.Count == 0
            ? ""
            : BuildSecurityWarningBody(securityBlockedMods);

        try
        {
            UndertaleModLib.Compiler.CodeImportGroup importGroup = new(data);

            importGroup.QueueReplace(
                "gml_GlobalScript_loclm_runtime_log",
                gmlAssets.Load("runtime_logger.gml"));

            QueueMultiplayerScripts(importGroup);

            importGroup.QueueFindReplace(
                "gml_GlobalScript_main_menu_spawn_buttons",
                "btn_yy = 4;",
                gmlAssets.Load(
                    "main_menu_spawn_buttons.patch.gml",
                    ("__SECURITY_BLOCK_COUNT__", securityBlockedMods.Count.ToString()),
                    ("__SECURITY_WARNING_TITLE__", GmlAssetLoader.QuoteGmlString(securityWarningTitle)),
                    ("__SECURITY_WARNING_BODY__", GmlAssetLoader.QuoteGmlString(securityWarningBody))));

            importGroup.QueueReplace(
                loclmButton.EventHandlerFor(EventType.Create, data),
                gmlAssets.Load("loclm_button_create.gml"));

            importGroup.QueueReplace(
                loclmButton.EventHandlerFor(EventType.Alarm, 0u, data),
                gmlAssets.Load("loclm_button_alarm0.gml"));

            importGroup.QueueReplace(
                loclmButton.EventHandlerFor(EventType.Alarm, 2u, data),
                gmlAssets.Load(
                    "loclm_button_alarm2.gml",
                    ("__LOADED_MODS_SETUP__", loadedModsSetup),
                    ("__FAILED_MODS_SETUP__", failedModsSetup),
                    ("__CONFLICTS_SETUP__", conflictsSetup),
                    ("__MODS_DIRECTORY__", GmlAssetLoader.QuoteGmlString(modsDirectory))));

            importGroup.QueueReplace(
                loclmButton.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
                gmlAssets.Load("loclm_button_draw.gml", ("__LOADER_VERSION__", GmlAssetLoader.QuoteGmlString(LoaderConstants.LoaderVersion))));

            importGroup.QueueAppend(
                "gml_Object_obj_ctrl_main_menu_Draw_0",
                gmlAssets.Load("main_menu_draw_security_warning.gml"));

            importGroup.QueueAppend(
                "gml_Object_obj_ctrl_main_menu_Step_0",
                gmlAssets.Load("main_menu_step.gml"));

            importGroup.QueueReplace(
                mpController.EventHandlerFor(EventType.Create, data),
                gmlAssets.Load("mp_controller_create.gml"));

            importGroup.QueueReplace(
                mpController.EventHandlerFor(EventType.Step, EventSubtypeStep.Step, data),
                gmlAssets.Load("mp_controller_step.gml"));

            importGroup.QueueReplace(
                mpController.EventHandlerFor(EventType.Other, 68u, data),
                gmlAssets.Load("mp_controller_async_networking.gml"));

            importGroup.QueueReplace(
                remotePlayer.EventHandlerFor(EventType.Create, data),
                gmlAssets.Load("mp_remote_player_create.gml"));

            importGroup.QueueReplace(
                remotePlayer.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
                gmlAssets.Load("mp_remote_player_draw.gml"));

            importGroup.QueueReplace(
                remoteEntity.EventHandlerFor(EventType.Create, data),
                gmlAssets.Load("mp_remote_entity_create.gml"));

            importGroup.QueueReplace(
                remoteEntity.EventHandlerFor(EventType.Draw, EventSubtypeDraw.Draw, data),
                gmlAssets.Load("mp_remote_entity_draw.gml"));

            importGroup.Import();
            success("Installed LOCLM about button clone and info panel.");
            return true;
        }
        catch (Exception ex)
        {
            warn("LOCLM in-game menu could not be installed: " + ex.Message);
            warn("This usually means the game updated and a menu injection target changed.");
            return false;
        }
    }

    private void QueueMultiplayerScripts(UndertaleModLib.Compiler.CodeImportGroup importGroup)
    {
        string[] scripts =
        {
            "scr_lm_mp_init",
            "scr_lm_mp_host_steam",
            "scr_lm_mp_join_steam_lobby",
            "scr_lm_mp_tick",
            "scr_lm_mp_send_player_state",
            "scr_lm_mp_handle_local_packet",
            "scr_lm_mp_spawn_remote_player",
            "scr_lm_mp_update_remote_player",
            "scr_lm_mp_send_world_state",
            "scr_lm_mp_update_world_state",
            "scr_lm_mp_open_lobby_panel",
            "scr_lm_mp_start_match",
            "scr_lm_mp_send_packet",
            "scr_lm_mp_read_bridge_port",
            "scr_lm_mp_read_string_payload"
        };

        foreach (string script in scripts)
        {
            importGroup.QueueReplace("gml_GlobalScript_" + script, gmlAssets.Load(script + ".gml"));
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

        foreach (UndertaleGameObject.UndertalePhysicsVertex vertex in buttonMenu.PhysicsVertices)
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

    private static UndertaleGameObject EnsurePlainObject(UndertaleData data, string name, bool persistent, bool visible)
    {
        if (data.GameObjects.ByName(name) is UndertaleGameObject existing)
        {
            existing.Persistent = persistent;
            existing.Visible = visible;
            existing.Solid = false;
            return existing;
        }

        UndertaleGameObject obj = new()
        {
            Name = data.Strings.MakeString(name),
            Visible = visible,
            Persistent = persistent,
            Solid = false,
            Depth = -100000
        };

        data.GameObjects.Add(obj);
        return obj;
    }
}
