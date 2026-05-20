btn_yy = 4;
    if (!variable_global_exists("loclm_runtime_log_ready"))
    {
        global.loclm_runtime_log_ready = true;
        loclm_runtime_log("runtime logger initialized");
    }
    if (!variable_global_exists("loclm_menu_open"))
    {
        global.loclm_menu_open = false;
        loclm_runtime_log("main menu initialized");
    }
    if (!variable_global_exists("loclm_loaded_mods"))
    {
        global.loclm_loaded_mods = [];
    }
    if (!variable_global_exists("loclm_loaded_mod_count"))
    {
        global.loclm_loaded_mod_count = 0;
    }
    if (!variable_global_exists("loclm_failed_mods"))
    {
        global.loclm_failed_mods = [];
    }
    if (!variable_global_exists("loclm_failed_mod_count"))
    {
        global.loclm_failed_mod_count = 0;
    }
    if (!variable_global_exists("loclm_mod_conflicts"))
    {
        global.loclm_mod_conflicts = [];
    }
    if (!variable_global_exists("loclm_mod_conflict_count"))
    {
        global.loclm_mod_conflict_count = 0;
    }
    if (!variable_global_exists("loclm_loaded_scroll"))
    {
        global.loclm_loaded_scroll = 0;
    }
    if (!variable_global_exists("loclm_folder_copied_timer"))
    {
        global.loclm_folder_copied_timer = 0;
    }
    if (!variable_global_exists("lm_mp_menu_open"))
    {
        global.lm_mp_menu_open = false;
    }
    global.loclm_security_block_count = __SECURITY_BLOCK_COUNT__;
    global.loclm_security_warning_title = __SECURITY_WARNING_TITLE__;
    global.loclm_security_warning_body = __SECURITY_WARNING_BODY__;
    if (global.current_menu == 3 && global.loclm_menu_open == false && global.lm_mp_menu_open == false)
    {
        global.button_unlock[90] = 1;
        global.button_unlock[93] = 1;
        global.button_unlock[94] = 1;
        global.button_unlock[95] = 1;
        var loclm_menu_x = 86;
        var button = instance_create_depth(loclm_menu_x, (room_height / 2) + 15 + btn_yy, -999, obj_loclm_button);
        button.button_index = 90;
        var host_button = instance_create_depth(loclm_menu_x, (room_height / 2) + 49 + btn_yy, -999, obj_loclm_button);
        host_button.button_index = 93;
        var join_button = instance_create_depth(loclm_menu_x, (room_height / 2) + 83 + btn_yy, -999, obj_loclm_button);
        join_button.button_index = 94;
        var lobby_button = instance_create_depth(loclm_menu_x, (room_height / 2) + 117 + btn_yy, -999, obj_loclm_button);
        lobby_button.button_index = 95;
    }
