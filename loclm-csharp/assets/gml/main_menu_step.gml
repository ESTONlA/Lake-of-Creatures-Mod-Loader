if (variable_global_exists("loclm_menu_open") && global.loclm_menu_open == true && global.current_menu != 3)
{
    loclm_runtime_log("LOCLM menu auto-closed because current_menu changed to " + string(global.current_menu));
    global.loclm_menu_open = false;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
}

if (variable_global_exists("lm_mp_menu_open") && global.lm_mp_menu_open == true && global.current_menu != 3)
{
    loclm_runtime_log("Steam multiplayer menu auto-closed because current_menu changed to " + string(global.current_menu));
    global.lm_mp_menu_open = false;
    global.lm_mp_menu_mode = 0;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
}

if (!instance_exists(obj_lm_mp_controller))
{
    instance_create_depth(0, 0, -100000, obj_lm_mp_controller);
}

if (variable_global_exists("loclm_menu_open") && global.loclm_menu_open == true)
{
    logo_alpha = 0;
    logo_alpha_2 = 0;
    press_any_key_alpha = 0;
    if (!variable_global_exists("loclm_loaded_scroll"))
    {
        global.loclm_loaded_scroll = 0;
    }
    var loclm_max_scroll = max(0, global.loclm_loaded_mod_count - 5);
    if (mouse_wheel_down() || input_check_pressed("down"))
    {
        global.loclm_loaded_scroll = min(loclm_max_scroll, global.loclm_loaded_scroll + 1);
    }
    if (mouse_wheel_up() || input_check_pressed("up"))
    {
        global.loclm_loaded_scroll = max(0, global.loclm_loaded_scroll - 1);
    }
    if (variable_global_exists("loclm_folder_copied_timer") && global.loclm_folder_copied_timer > 0)
    {
        global.loclm_folder_copied_timer -= 1;
    }
}

if (variable_global_exists("lm_mp_menu_open") && global.lm_mp_menu_open == true)
{
    logo_alpha = 0;
    logo_alpha_2 = 0;
    press_any_key_alpha = 0;
    if (variable_global_exists("lm_mp_menu_mode") && global.lm_mp_menu_mode == 2)
    {
        global.lm_mp_join_lobby_id = string(keyboard_string);
    }
    if (variable_global_exists("lm_mp_menu_mode") && global.lm_mp_menu_mode == 1)
    {
        if (variable_global_exists("lm_mp_is_host") && global.lm_mp_is_host == true)
        {
            var _loclm_start_button_exists = false;
            with (obj_loclm_button)
            {
                if (button_index == 99)
                {
                    _loclm_start_button_exists = true;
                }
            }

            if (_loclm_start_button_exists == false)
            {
                var _loclm_start_button = instance_create_depth(455, room_height - 42, -100001, obj_loclm_button);
                _loclm_start_button.button_index = 99;
                _loclm_start_button.my_text = "Start Game";
                _loclm_start_button.click_delete = false;
                _loclm_start_button.fadeout = false;
                _loclm_start_button.canclick = true;
                _loclm_start_button.alarm[0] = 1;
            }
        }

        if (variable_global_exists("lm_mp_bridge_connected") && global.lm_mp_bridge_connected == true)
        {
            if ((!variable_global_exists("lm_mp_lobby_ready") || global.lm_mp_lobby_ready == false) &&
                (!variable_global_exists("lm_mp_host_requested") || global.lm_mp_host_requested == false))
            {
                scr_lm_mp_host_steam();
            }
        }
    }
}

if (variable_global_exists("loclm_menu_open") && global.loclm_menu_open == true && input_check_pressed("leave"))
{
    loclm_runtime_log("LOCLM menu closed by leave input");
    global.loclm_menu_open = false;
    global.current_menu = 3;
    global.cursor_index_menu = 0;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
    main_menu_spawn_buttons();
}

if (variable_global_exists("lm_mp_menu_open") && global.lm_mp_menu_open == true && input_check_pressed("leave"))
{
    loclm_runtime_log("Steam multiplayer menu closed by leave input");
    global.lm_mp_menu_open = false;
    global.lm_mp_menu_mode = 0;
    global.current_menu = 3;
    global.cursor_index_menu = 0;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
    main_menu_spawn_buttons();
}
