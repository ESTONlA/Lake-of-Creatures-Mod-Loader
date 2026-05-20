function scr_lm_mp_tick()
{
    scr_lm_mp_init();

    if (global.lm_mp_socket < 0)
    {
        global.lm_mp_retry_timer -= 1;
        if (global.lm_mp_retry_timer <= 0)
        {
            global.lm_mp_bridge_port = scr_lm_mp_read_bridge_port();
            global.lm_mp_socket = network_create_socket(network_socket_tcp);
            var _result = network_connect_raw(global.lm_mp_socket, "127.0.0.1", global.lm_mp_bridge_port);
            global.lm_mp_retry_timer = 120;
            if (_result >= 0)
            {
                global.lm_mp_status = "Connecting to LOCLM Steam bridge on " + string(global.lm_mp_bridge_port);
                scr_lm_mp_send_packet(1, -1);
            }
            else
            {
                network_destroy(global.lm_mp_socket);
                global.lm_mp_socket = -1;
                global.lm_mp_status = "Retrying LOCLM Steam bridge...";
            }
        }
    }

    global.lm_mp_send_timer -= 1;
    if (global.lm_mp_connected && global.lm_mp_send_timer <= 0)
    {
        global.lm_mp_send_timer = 3;
        scr_lm_mp_send_player_state();
    }

    global.lm_mp_world_send_timer -= 1;
    if (
        global.lm_mp_connected
        && global.lm_mp_match_started
        && global.lm_mp_is_host
        && global.lm_mp_world_send_timer <= 0
    )
    {
        global.lm_mp_world_send_timer = 6;
        scr_lm_mp_send_world_state();
    }
}
