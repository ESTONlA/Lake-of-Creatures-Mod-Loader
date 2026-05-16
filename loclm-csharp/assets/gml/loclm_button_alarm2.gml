var loclm_handled = false;
if (button_index == 90 || button_index == 91 || button_index == 92)
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
__LOADED_MODS_SETUP____FAILED_MODS_SETUP__
                    global.cursor_index_menu = 0;
                    with (obj_button_menu)
                    {
                        if (option_menu_tab_button == false && object_index != obj_loclm_button)
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
        }
    }
}
if (loclm_handled == false)
{
    event_inherited();
}
