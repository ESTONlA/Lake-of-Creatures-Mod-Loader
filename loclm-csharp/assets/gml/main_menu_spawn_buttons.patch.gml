btn_yy = 4;
    if (!variable_global_exists("loclm_menu_open"))
    {
        global.loclm_menu_open = false;
    }
    global.loclm_security_block_count = __SECURITY_BLOCK_COUNT__;
    global.loclm_security_warning_title = __SECURITY_WARNING_TITLE__;
    global.loclm_security_warning_body = __SECURITY_WARNING_BODY__;
    if (global.current_menu == 3 && global.loclm_menu_open == false)
    {
        global.button_unlock[90] = 1;
        var button = instance_create_depth(52, (room_height / 2) + 15 + btn_yy, -999, obj_loclm_button);
        button.button_index = 90;
    }
