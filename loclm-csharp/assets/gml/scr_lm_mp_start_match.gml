function scr_lm_mp_start_match(_is_host)
{
    scr_lm_mp_init();
    global.lm_mp_match_started = true;
    global.lm_mp_menu_open = false;
    global.lm_mp_menu_mode = 0;
    global.lm_mp_status = "Starting multiplayer run...";
    global.lm_mp_panel_message = global.lm_mp_status;

    with (obj_lm_remote_player)
    {
        instance_destroy();
    }
    with (obj_lm_remote_entity)
    {
        instance_destroy();
    }
    global.lm_mp_remote_player_instance = noone;
    global.lm_mp_remote_entities = [];
    global.lm_mp_remote_entity_ids = [];
    global.lm_mp_remote_entity_seen = [];

    if (
        variable_global_exists("lm_mp_remote_players")
        && is_real(global.lm_mp_remote_players)
        && ds_exists(global.lm_mp_remote_players, ds_type_map)
    )
    {
        ds_map_clear(global.lm_mp_remote_players);
    }

    with (obj_loclm_button)
    {
        instance_destroy();
    }

    if (asset_get_index("start_new_run") >= 0)
    {
        loclm_runtime_log("Steam multiplayer starting run through normal main-menu run flow");
        with (obj_button_menu)
        {
            canclick = false;
        }
        global.cutscene_phase = 1;
        start_new_run("normal");
        play_music(1);
        return true;
    }

    if (asset_get_index("lake_start") >= 0)
    {
        loclm_runtime_log("Steam multiplayer starting run through lake_start");
        lake_start();
        return true;
    }

    if (asset_get_index("game_start_init") >= 0)
    {
        loclm_runtime_log("Steam multiplayer starting run through game_start_init");
        game_start_init();
        return true;
    }

    global.lm_mp_menu_open = true;
    global.lm_mp_menu_mode = 1;
    global.lm_mp_status = "Could not find the game's start script.";
    global.lm_mp_panel_message = global.lm_mp_status;
    loclm_runtime_log("Steam multiplayer start failed because no known game start script exists");
    scr_lm_mp_open_lobby_panel();
    return false;
}
