if (variable_global_exists("loclm_menu_open") && global.loclm_menu_open == true && button_index == 91)
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
    draw_text_outline_b2x(text_x, text_y, "LOCLM");
    draw_set_color(c_white);
    draw_text(text_x, text_y + 25, "Community-built loader for Lake of Creatures");
    draw_set_color(12632256);
    draw_text(text_x, text_y + 45, "Made by Estonia, for love of the game.");

    draw_set_color(global.color_yellow);
    draw_text(left_x, section_y, "Loader Version");
    draw_set_color(c_white);
    draw_text(left_x + 18, section_y + 22, __LOADER_VERSION__);

    draw_set_color(global.color_yellow);
    draw_text(right_x, section_y, "Loaded Mods");
    draw_set_color(c_white);
    var loaded_visible = 4;
    var loaded_count = global.loclm_loaded_mod_count;
    if (loaded_count <= 0)
    {
        draw_text(right_x + 18, section_y + 22, "None");
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
                mod_name = string_copy(mod_name, 1, 32) + "...";
            }
            draw_text(right_x + 18, section_y + 22 + ((i - loaded_start) * 20), "- " + mod_name);
        }
        if (loaded_count > loaded_visible)
        {
            draw_set_color(8421504);
            draw_text(right_x + 112, section_y, string(loaded_start + 1) + "-" + string(loaded_end) + "/" + string(loaded_count));
            draw_text(right_x + 18, section_y + 106, "Scroll: wheel / Up / Down");
        }
    }

    var conflict_y = section_y + 142;
    draw_set_color(global.color_yellow);
    draw_text(right_x, conflict_y, "Possible Conflicts");
    draw_set_color(c_white);
    if (!variable_global_exists("loclm_mod_conflict_count") || global.loclm_mod_conflict_count <= 0)
    {
        draw_text(right_x + 18, conflict_y + 22, "None");
    }
    else
    {
        var conflict_visible = min(global.loclm_mod_conflict_count, 4);
        for (var c = 0; c < conflict_visible; c += 1)
        {
            var conflict_text = string(global.loclm_mod_conflicts[c]);
            if (string_length(conflict_text) > 43)
            {
                conflict_text = string_copy(conflict_text, 1, 40) + "...";
            }
            draw_text(right_x + 18, conflict_y + 22 + (c * 20), "- " + conflict_text);
        }
        if (global.loclm_mod_conflict_count > conflict_visible)
        {
            draw_set_color(8421504);
            draw_text(right_x + 18, conflict_y + 106, "+" + string(global.loclm_mod_conflict_count - conflict_visible) + " more in Logs/mod_conflicts.json");
        }
    }

    if (variable_global_exists("loclm_folder_copied_timer") && global.loclm_folder_copied_timer > 0)
    {
        draw_set_color(global.color_yellow);
        draw_text(panel_x + panel_w - 138, panel_y + panel_h - 24, "Path copied.");
    }
}
if (variable_global_exists("lm_mp_menu_open") && global.lm_mp_menu_open == true && button_index == 96)
{
    var mp_panel_x = 36;
    var mp_panel_y = 32;
    var mp_panel_w = room_width - 72;
    var mp_panel_h = room_height - 132;
    var mp_text_x = mp_panel_x + 24;
    var mp_text_y = mp_panel_y + 24;

    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(mp_panel_x, mp_panel_y, mp_panel_x + mp_panel_w, mp_panel_y + mp_panel_h, false);
    draw_set_alpha(0.9);
    draw_set_color(global.color_outline);
    draw_rectangle(mp_panel_x, mp_panel_y, mp_panel_x + mp_panel_w, mp_panel_y + mp_panel_h, true);
    draw_set_alpha(1);

    draw_set_font(global.font_current);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(c_white);
    var mp_status = "Steam bridge starting...";
    if (variable_global_exists("lm_mp_status"))
    {
        mp_status = string(global.lm_mp_status);
    }
    if (string_length(mp_status) > 62)
    {
        mp_status = string_copy(mp_status, 1, 59) + "...";
    }
    draw_text(mp_text_x, mp_text_y, mp_status);

    if (variable_global_exists("lm_mp_panel_message") && string_length(string(global.lm_mp_panel_message)) > 0)
    {
        var mp_message = string(global.lm_mp_panel_message);
        if (string_length(mp_message) > 70)
        {
            mp_message = string_copy(mp_message, 1, 67) + "...";
        }
        draw_set_color(12632256);
        draw_text(mp_text_x, mp_text_y + 30, mp_message);
    }

    if (global.lm_mp_menu_mode == 1)
    {
        var lobby_col_x = mp_text_x;
        var players_col_x = mp_text_x + 335;
        var lobby_row_y = mp_text_y + 82;

        draw_set_color(global.color_yellow);
        draw_text(lobby_col_x, lobby_row_y, "Lobby ID");
        draw_set_color(c_white);
        if (variable_global_exists("lm_mp_lobby_id") && string_length(string(global.lm_mp_lobby_id)) > 0)
        {
            draw_text(lobby_col_x, lobby_row_y + 28, string(global.lm_mp_lobby_id));
        }
        else
        {
            draw_text(lobby_col_x, lobby_row_y + 28, "Waiting for Steam...");
        }

        draw_set_color(global.color_yellow);
        draw_text(players_col_x, lobby_row_y, "Active Players");
        draw_set_color(c_white);
        var host_name = "Host";
        if (variable_global_exists("lm_mp_host_name") && string_length(string(global.lm_mp_host_name)) > 0)
        {
            host_name = string(global.lm_mp_host_name);
        }
        if (string_length(host_name) > 26)
        {
            host_name = string_copy(host_name, 1, 23) + "...";
        }
        draw_text(players_col_x, lobby_row_y + 28, "- " + host_name);
        var remote_count = 0;
        if (
            variable_global_exists("lm_mp_remote_players")
            && is_real(global.lm_mp_remote_players)
            && ds_exists(global.lm_mp_remote_players, ds_type_map)
        )
        {
            remote_count = ds_map_size(global.lm_mp_remote_players);
        }
        else
        {
            global.lm_mp_remote_players = ds_map_create();
        }
        if (variable_global_exists("lm_mp_connected_peer_count"))
        {
            remote_count = max(remote_count, global.lm_mp_connected_peer_count);
        }
        if (variable_global_exists("lm_mp_peer_connected") && global.lm_mp_peer_connected == true)
        {
            remote_count = max(remote_count, 1);
        }
        if (remote_count > 0)
        {
            var peer_name = "Peer connected";
            if (variable_global_exists("lm_mp_peer_name") && string_length(string(global.lm_mp_peer_name)) > 0)
            {
                peer_name = string(global.lm_mp_peer_name);
            }
            if (string_length(peer_name) > 26)
            {
                peer_name = string_copy(peer_name, 1, 23) + "...";
            }
            draw_text(players_col_x, lobby_row_y + 52, "- " + peer_name);
        }
        else
        {
            draw_set_color(12632256);
            draw_text(players_col_x, lobby_row_y + 52, "Waiting for player...");
        }
    }
    else if (global.lm_mp_menu_mode == 2)
    {
        draw_set_color(global.color_yellow);
        draw_text(mp_text_x, mp_text_y + 82, "Lobby ID");

        var input_x = mp_text_x + 20;
        var input_y = mp_text_y + 110;
        var input_w = mp_panel_w - 80;
        draw_set_alpha(0.72);
        draw_set_color(c_black);
        draw_rectangle(input_x, input_y, input_x + input_w, input_y + 34, false);
        draw_set_alpha(1);
        draw_set_color(global.color_outline);
        draw_rectangle(input_x, input_y, input_x + input_w, input_y + 34, true);

        draw_set_color(c_white);
        var join_text = string(keyboard_string);
        if (string_length(join_text) <= 0)
        {
            draw_set_color(8421504);
            join_text = "Paste or type lobby ID here";
        }
        draw_text(input_x + 10, input_y + 8, join_text);

        draw_set_color(12632256);
        draw_text(mp_text_x + 20, input_y + 48, "Use Paste ID, or type the lobby ID directly, then press Join.");
    }
}
event_inherited();
