if (variable_global_exists("antenni_menu_open") && global.antenni_menu_open == true && global.current_menu != 3)
{
    antenni_runtime_log("Antenni menu auto-closed because current_menu changed to " + string(global.current_menu));
    global.antenni_menu_open = false;
    with (obj_antenni_button)
    {
        instance_destroy();
    }
}

if (variable_global_exists("antenni_menu_open") && global.antenni_menu_open == true)
{
    logo_alpha = 0;
    logo_alpha_2 = 0;
    press_any_key_alpha = 0;
    if (!variable_global_exists("antenni_loaded_scroll"))
    {
        global.antenni_loaded_scroll = 0;
    }
    var antenni_max_scroll = max(0, global.antenni_loaded_mod_count - 5);
    if (mouse_wheel_down() || input_check_pressed("down"))
    {
        global.antenni_loaded_scroll = min(antenni_max_scroll, global.antenni_loaded_scroll + 1);
    }
    if (mouse_wheel_up() || input_check_pressed("up"))
    {
        global.antenni_loaded_scroll = max(0, global.antenni_loaded_scroll - 1);
    }
    if (variable_global_exists("antenni_folder_copied_timer") && global.antenni_folder_copied_timer > 0)
    {
        global.antenni_folder_copied_timer -= 1;
    }
}

if (variable_global_exists("antenni_menu_open") && global.antenni_menu_open == true && input_check_pressed("leave"))
{
    antenni_runtime_log("Antenni menu closed by leave input");
    global.antenni_menu_open = false;
    global.current_menu = 3;
    global.cursor_index_menu = 0;
    with (obj_antenni_button)
    {
        instance_destroy();
    }
    main_menu_spawn_buttons();
}
