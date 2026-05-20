var loclm_handled = false;
if (button_index == 90 || button_index == 91 || button_index == 92 || button_index == 93 || button_index == 94 || button_index == 95 || button_index == 96 || button_index == 97 || button_index == 98 || button_index == 99)
{
    if (variable_instance_exists(id, "clicked") && clicked == true)
    {
        loclm_handled = true;
        switch (button_index)
        {
            case 90:
                if (global.current_menu == 3)
                {
                    loclm_runtime_log("LOCLM menu opened");
                    global.loclm_menu_open = true;
                    global.loclm_loaded_scroll = 0;
                    global.loclm_folder_copied_timer = 0;
__LOADED_MODS_SETUP____FAILED_MODS_SETUP____CONFLICTS_SETUP__
                    global.cursor_index_menu = 0;
                    with (obj_button_menu)
                    {
                        if (option_menu_tab_button == false && object_index != obj_loclm_button)
                        {
                            instance_destroy();
                        }
                    }
                    with (obj_loclm_button)
                    {
                        if (button_index == 93 || button_index == 94 || button_index == 95 || button_index == 96 || button_index == 97 || button_index == 98 || button_index == 99)
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
                loclm_runtime_log("LOCLM menu closed");
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
                loclm_runtime_log("mods path copied to clipboard");
                clipboard_set_text(__MODS_DIRECTORY__);
                global.loclm_folder_copied_timer = 120;
                clicked = false;
                bg_scale = 1.1;
                break;
            case 93:
                if (global.current_menu == 3 && (!variable_global_exists("loclm_menu_open") || global.loclm_menu_open == false))
                {
                    scr_lm_mp_init();
                    loclm_runtime_log("Steam lobby host panel opened from main menu");
                    global.lm_mp_is_host = true;
                    global.lm_mp_menu_open = true;
                    global.lm_mp_menu_mode = 1;
                    global.lm_mp_panel_message = "Creating lobby...";
                    global.current_menu = 3;
                    global.cursor_index_menu = 0;
                    with (obj_button_menu)
                    {
                        if (option_menu_tab_button == false && object_index != obj_loclm_button)
                        {
                            instance_destroy();
                        }
                    }
                    with (obj_loclm_button)
                    {
                        if (id != other.id)
                        {
                            instance_destroy();
                        }
                    }
                    x = 86;
                    y = room_height - 42;
                    depth = -100001;
                    button_index = 96;
                    clicked = false;
                    fadeout = false;
                    click_delete = false;
                    canclick = true;
                    alarm[0] = 1;
                    var copy_lobby_button = instance_create_depth(265, room_height - 42, -100001, obj_loclm_button);
                    copy_lobby_button.button_index = 95;
                    copy_lobby_button.my_text = "Copy Lobby ID";
                    copy_lobby_button.click_delete = false;
                    copy_lobby_button.fadeout = false;
                    copy_lobby_button.canclick = true;
                    copy_lobby_button.alarm[0] = 1;
                    var start_button = instance_create_depth(455, room_height - 42, -100001, obj_loclm_button);
                    start_button.button_index = 99;
                    start_button.my_text = "Start Game";
                    start_button.click_delete = false;
                    start_button.fadeout = false;
                    start_button.canclick = true;
                    start_button.alarm[0] = 1;
                    scr_lm_mp_host_steam();
                }
                clicked = false;
                bg_scale = 1.1;
                break;
            case 94:
                if (global.current_menu == 3 && (!variable_global_exists("loclm_menu_open") || global.loclm_menu_open == false))
                {
                    scr_lm_mp_init();
                    loclm_runtime_log("Steam lobby join panel opened from main menu");
                    global.lm_mp_is_host = false;
                    global.lm_mp_menu_open = true;
                    global.lm_mp_menu_mode = 2;
                    global.lm_mp_panel_message = "Paste or type a lobby ID.";
                    global.current_menu = 3;
                    if (!variable_global_exists("lm_mp_join_lobby_id"))
                    {
                        global.lm_mp_join_lobby_id = "";
                    }
                    keyboard_string = string(global.lm_mp_join_lobby_id);
                    global.cursor_index_menu = 0;
                    with (obj_button_menu)
                    {
                        if (option_menu_tab_button == false && object_index != obj_loclm_button)
                        {
                            instance_destroy();
                        }
                    }
                    with (obj_loclm_button)
                    {
                        if (id != other.id)
                        {
                            instance_destroy();
                        }
                    }
                    x = 86;
                    y = room_height - 42;
                    depth = -100001;
                    button_index = 96;
                    clicked = false;
                    fadeout = false;
                    click_delete = false;
                    canclick = true;
                    alarm[0] = 1;
                    var paste_button = instance_create_depth(265, room_height - 42, -100001, obj_loclm_button);
                    paste_button.button_index = 98;
                    paste_button.my_text = "Paste ID";
                    paste_button.click_delete = false;
                    paste_button.fadeout = false;
                    paste_button.canclick = true;
                    paste_button.alarm[0] = 1;
                    var join_now_button = instance_create_depth(425, room_height - 42, -100001, obj_loclm_button);
                    join_now_button.button_index = 97;
                    join_now_button.my_text = "Join";
                    join_now_button.click_delete = false;
                    join_now_button.fadeout = false;
                    join_now_button.canclick = true;
                    join_now_button.alarm[0] = 1;
                }
                clicked = false;
                bg_scale = 1.1;
                break;
            case 96:
                loclm_runtime_log("Steam multiplayer panel closed");
                global.lm_mp_menu_open = false;
                global.lm_mp_menu_mode = 0;
                global.current_menu = 3;
                global.cursor_index_menu = 0;
                with (obj_loclm_button)
                {
                    instance_destroy();
                }
                main_menu_spawn_buttons();
                break;
            case 97:
                scr_lm_mp_init();
                global.lm_mp_join_lobby_id = string(keyboard_string);
                if (string_length(global.lm_mp_join_lobby_id) > 0)
                {
                    loclm_runtime_log("Steam lobby join requested from join panel");
                    global.lm_mp_panel_message = "Joining lobby...";
                    scr_lm_mp_join_steam_lobby(global.lm_mp_join_lobby_id);
                }
                else
                {
                    global.lm_mp_panel_message = "Enter a lobby ID first.";
                    global.lm_mp_status = global.lm_mp_panel_message;
                }
                clicked = false;
                bg_scale = 1.1;
                break;
            case 98:
                scr_lm_mp_init();
                global.lm_mp_join_lobby_id = clipboard_get_text();
                keyboard_string = string(global.lm_mp_join_lobby_id);
                global.lm_mp_panel_message = "Pasted lobby ID.";
                clicked = false;
                bg_scale = 1.1;
                break;
            case 99:
                scr_lm_mp_init();
                var _start_packet_sent = scr_lm_mp_send_packet(8, -1);
                if (scr_lm_mp_start_match(true))
                {
                    loclm_runtime_log("Steam multiplayer start pressed; start packet sent=" + string(_start_packet_sent));
                }
                clicked = false;
                bg_scale = 1.1;
                break;
            case 95:
                if (global.current_menu == 3 && (!variable_global_exists("loclm_menu_open") || global.loclm_menu_open == false))
                {
                    scr_lm_mp_init();
                    if (variable_global_exists("lm_mp_lobby_id") && string_length(string(global.lm_mp_lobby_id)) > 0)
                    {
                        clipboard_set_text(string(global.lm_mp_lobby_id));
                        global.lm_mp_status = "Lobby ID copied to clipboard.";
                        global.lm_mp_panel_message = "Lobby ID copied.";
                        loclm_runtime_log("Steam lobby id copied to clipboard");
                    }
                    else
                    {
                        global.lm_mp_status = "No lobby ID yet. Host or join a lobby first.";
                        global.lm_mp_panel_message = global.lm_mp_status;
                    }
                }
                clicked = false;
                bg_scale = 1.1;
                break;
        }
    }
}
if (loclm_handled == false)
{
    event_inherited();
}
