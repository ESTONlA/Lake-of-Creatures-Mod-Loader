if (clicked == true && buttons_clickable == true)
{
    switch (button_index)
    {
        case __MAIN_MENU_BUTTON_INDEX__:
            global.current_menu = 7;
            global.cursor_index_menu = 0;
            with (obj_button_menu)
            {
                if (option_menu_tab_button == false)
                {
                    instance_destroy();
                }
            }
            var button = instance_create_depth(room_width / 2, (room_height / 2) + 62, -999, obj_button_menu);
            button.button_index = __BACK_BUTTON_INDEX__;
            break;
        case __BACK_BUTTON_INDEX__:
            global.current_menu = 3;
            global.cursor_index_menu = 0;
            with (obj_button_menu)
            {
                if (option_menu_tab_button == false)
                {
                    instance_destroy();
                }
            }
            main_menu_spawn_buttons();
            break;
    }
}
