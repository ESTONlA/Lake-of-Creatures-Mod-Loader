if (variable_global_exists("loclm_menu_open") && global.loclm_menu_open == true && global.current_menu != 3)
{
    loclm_runtime_log("LOCLM menu auto-closed because current_menu changed to " + string(global.current_menu));
    global.loclm_menu_open = false;
    with (obj_loclm_button)
    {
        instance_destroy();
    }
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
