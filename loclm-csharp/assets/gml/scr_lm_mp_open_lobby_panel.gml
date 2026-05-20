function scr_lm_mp_open_lobby_panel()
{
    if (global.current_menu != 3)
    {
        return false;
    }

    global.lm_mp_menu_open = true;
    global.lm_mp_menu_mode = 1;
    global.cursor_index_menu = 0;
    logo_alpha = 0;
    logo_alpha_2 = 0;
    press_any_key_alpha = 0;

    with (obj_button_menu)
    {
        if (option_menu_tab_button == false && object_index != obj_loclm_button)
        {
            instance_destroy();
        }
    }

    with (obj_loclm_button)
    {
        instance_destroy();
    }

    var back_button = instance_create_depth(86, room_height - 42, -100001, obj_loclm_button);
    back_button.button_index = 96;
    back_button.click_delete = false;
    back_button.fadeout = false;
    back_button.canclick = true;

    var copy_lobby_button = instance_create_depth(265, room_height - 42, -100001, obj_loclm_button);
    copy_lobby_button.button_index = 95;
    copy_lobby_button.my_text = "Copy Lobby ID";
    copy_lobby_button.click_delete = false;
    copy_lobby_button.fadeout = false;
    copy_lobby_button.canclick = true;
    copy_lobby_button.alarm[0] = 1;

    if (variable_global_exists("lm_mp_is_host") && global.lm_mp_is_host == true)
    {
        var start_button = instance_create_depth(455, room_height - 42, -100001, obj_loclm_button);
        start_button.button_index = 99;
        start_button.my_text = "Start Game";
        start_button.click_delete = false;
        start_button.fadeout = false;
        start_button.canclick = true;
        start_button.alarm[0] = 1;
    }

    return true;
}
