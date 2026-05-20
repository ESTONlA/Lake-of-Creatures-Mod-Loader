function scr_lm_mp_handle_local_packet(_packet_type, _buffer)
{
    switch (_packet_type)
    {
        case 2:
            var _welcome = scr_lm_mp_read_string_payload(_buffer);
            if (string_length(_welcome) <= 0)
            {
                _welcome = "Steam bridge ready";
            }

            global.lm_mp_bridge_connected = true;
            global.lm_mp_status = _welcome;
            if (string_pos("Steam P2P connected", _welcome) > 0)
            {
                global.lm_mp_connected = true;
                global.lm_mp_peer_connected = true;
                global.lm_mp_connected_peer_count = max(1, global.lm_mp_connected_peer_count);
                global.lm_mp_panel_message = "Peer connected. Player sync is active.";
                scr_lm_mp_open_lobby_panel();
            }
            break;

        case 5:
            global.lm_mp_lobby_id = string(buffer_read(_buffer, buffer_u64));
            global.lm_mp_lobby_ready = true;
            global.lm_mp_connected = false;
            global.lm_mp_is_host = true;
            global.lm_mp_host_requested = false;
            global.lm_mp_status = "Lobby created: " + global.lm_mp_lobby_id;
            global.lm_mp_panel_message = "Lobby ready. Copy the ID or invite a friend through Steam.";
            scr_lm_mp_open_lobby_panel();
            show_debug_message("[LOCLM MP] Lobby created: " + global.lm_mp_lobby_id);
            break;

        case 6:
            var _joined_lobby_id = string(buffer_read(_buffer, buffer_u64));
            if (
                variable_global_exists("lm_mp_is_host")
                && global.lm_mp_is_host == true
                && variable_global_exists("lm_mp_lobby_id")
                && string(global.lm_mp_lobby_id) == _joined_lobby_id
            )
            {
                global.lm_mp_lobby_ready = true;
                global.lm_mp_join_requested = false;
                scr_lm_mp_open_lobby_panel();
                break;
            }

            global.lm_mp_lobby_id = _joined_lobby_id;
            global.lm_mp_lobby_ready = true;
            global.lm_mp_join_requested = false;
            global.lm_mp_is_host = false;
            global.lm_mp_status = "Joined lobby: " + global.lm_mp_lobby_id;
            global.lm_mp_panel_message = "Joined lobby. Connecting to host...";
            scr_lm_mp_open_lobby_panel();
            break;

        case 8:
            global.lm_mp_status = "Host started the match.";
            global.lm_mp_panel_message = global.lm_mp_status;
            scr_lm_mp_start_match(false);
            break;

        case 15:
            var _names = scr_lm_mp_read_string_payload(_buffer);
            var _split = string_pos("\n", _names);
            if (_split > 0)
            {
                var _host_name = string_copy(_names, 1, _split - 1);
                var _peer_name = string_copy(_names, _split + 1, string_length(_names) - _split);
                if (string_length(_host_name) > 0)
                {
                    global.lm_mp_host_name = _host_name;
                }
                global.lm_mp_peer_name = _peer_name;
                if (string_length(_peer_name) > 0)
                {
                    global.lm_mp_peer_connected = true;
                    global.lm_mp_connected_peer_count = max(1, global.lm_mp_connected_peer_count);
                }
                else
                {
                    global.lm_mp_peer_connected = false;
                    global.lm_mp_connected_peer_count = 0;
                }
            }
            break;

        case 7:
            var _lobby_error = scr_lm_mp_read_string_payload(_buffer);
            if (string_length(_lobby_error) <= 0)
            {
                _lobby_error = "Steam lobby failed";
            }

            global.lm_mp_host_requested = false;
            global.lm_mp_join_requested = false;
            global.lm_mp_status = _lobby_error;
            global.lm_mp_panel_message = _lobby_error;
            show_debug_message("[LOCLM MP] lobby failed: " + _lobby_error);
            break;

        case 12:
            global.lm_mp_connected = false;
            global.lm_mp_peer_connected = false;
            global.lm_mp_connected_peer_count = 0;
            global.lm_mp_peer_name = "";
            global.lm_mp_status = "Steam P2P disconnected";
            global.lm_mp_panel_message = "Peer disconnected.";
            break;

        case 13:
            var _bridge_error = scr_lm_mp_read_string_payload(_buffer);
            if (string_length(_bridge_error) <= 0)
            {
                _bridge_error = "Steam bridge error";
            }

            global.lm_mp_status = _bridge_error;
            global.lm_mp_panel_message = _bridge_error;
            show_debug_message("[LOCLM MP] bridge error: " + _bridge_error);
            break;

        case 11:
            scr_lm_mp_update_remote_player(_buffer);
            break;

        case 16:
            scr_lm_mp_update_world_state(_buffer);
            break;
    }
}
