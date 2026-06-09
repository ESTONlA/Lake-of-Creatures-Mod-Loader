btn_yy = 4;
    if (!variable_global_exists("antenni_runtime_log_ready"))
    {
        global.antenni_runtime_log_ready = true;
        antenni_runtime_log("runtime logger initialized");
    }
    if (!variable_global_exists("antenni_menu_open"))
    {
        global.antenni_menu_open = false;
        antenni_runtime_log("main menu initialized");
    }
    if (!variable_global_exists("antenni_loaded_mods"))
    {
        global.antenni_loaded_mods = [];
    }
    if (!variable_global_exists("antenni_loaded_mod_count"))
    {
        global.antenni_loaded_mod_count = 0;
    }
    if (!variable_global_exists("antenni_failed_mods"))
    {
        global.antenni_failed_mods = [];
    }
    if (!variable_global_exists("antenni_failed_mod_count"))
    {
        global.antenni_failed_mod_count = 0;
    }
    if (!variable_global_exists("antenni_mod_conflicts"))
    {
        global.antenni_mod_conflicts = [];
    }
    if (!variable_global_exists("antenni_mod_conflict_count"))
    {
        global.antenni_mod_conflict_count = 0;
    }
    if (!variable_global_exists("antenni_loaded_scroll"))
    {
        global.antenni_loaded_scroll = 0;
    }
    if (!variable_global_exists("antenni_folder_copied_timer"))
    {
        global.antenni_folder_copied_timer = 0;
    }
    global.antenni_security_block_count = __SECURITY_BLOCK_COUNT__;
    global.antenni_security_warning_title = __SECURITY_WARNING_TITLE__;
    global.antenni_security_warning_body = __SECURITY_WARNING_BODY__;
    if (global.current_menu == 3 && global.antenni_menu_open == false)
    {
        global.button_unlock[90] = 1;
        var button = instance_create_depth(52, (room_height / 2) + 15 + btn_yy, -999, obj_antenni_button);
        button.button_index = 90;
    }
