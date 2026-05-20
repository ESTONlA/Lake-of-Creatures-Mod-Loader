function scr_lm_mp_init()
{
    if (!variable_global_exists("lm_mp_initialized"))
    {
        global.lm_mp_initialized = true;
        global.lm_mp_socket = -1;
        global.lm_mp_bridge_port = scr_lm_mp_read_bridge_port();
        global.lm_mp_retry_timer = 1;
        global.lm_mp_bridge_connected = false;
        global.lm_mp_lobby_ready = false;
        global.lm_mp_connected = false;
        global.lm_mp_status = "Steam bridge not connected";
        global.lm_mp_lobby_id = "";
        global.lm_mp_menu_open = false;
        global.lm_mp_menu_mode = 0;
        global.lm_mp_join_lobby_id = "";
        global.lm_mp_panel_message = "";
        global.lm_mp_host_requested = false;
        global.lm_mp_join_requested = false;
        global.lm_mp_send_timer = 0;
        global.lm_mp_peer_connected = false;
        global.lm_mp_connected_peer_count = 0;
        global.lm_mp_match_started = false;
        global.lm_mp_is_host = false;
        global.lm_mp_host_name = "Host";
        global.lm_mp_peer_name = "";
        global.lm_mp_remote_player_instance = noone;
        global.lm_mp_world_send_timer = 0;
        global.lm_mp_world_tick = 0;
        global.lm_mp_next_entity_id = 1;
        global.lm_mp_host_room = -1;
        global.lm_mp_remote_entities = [];
        global.lm_mp_remote_entity_ids = [];
        global.lm_mp_remote_entity_seen = [];
    }

    if (
        !variable_global_exists("lm_mp_remote_players")
        || !is_real(global.lm_mp_remote_players)
        || !ds_exists(global.lm_mp_remote_players, ds_type_map)
    )
    {
        global.lm_mp_remote_players = ds_map_create();
    }
}
