function navigation_look_for_button(arg0)
{
    for (i = 0; i <= 160; i += 1)
    {
        if (collision_rectangle((room_width / 2) - 100, (y + lengthdir_y(i, arg0)) - 6, (room_width / 2) + 100, y + lengthdir_y(i, arg0) + 6, obj_button_menu, 0, 0))
        {
            var nearest_button = instance_nearest(x + lengthdir_x(i, arg0), y + lengthdir_y(i, arg0), obj_button_menu);
            if (nearest_button != my_current_button)
            {
                x = nearest_button.x;
                y = nearest_button.y;
                my_current_button = nearest_button;
                break;
            }
        }
        else if (collision_rectangle((room_width / 2) - 100, (y + lengthdir_y(i, arg0)) - 6, (room_width / 2) + 100, y + lengthdir_y(i, arg0) + 6, obj_unlock_menu_item, 0, 0))
        {
            var nearest_button = instance_nearest(x + lengthdir_x(i, arg0), y + lengthdir_y(i, arg0), obj_unlock_menu_item);
            if (nearest_button != my_current_button)
            {
                x = nearest_button.x;
                y = nearest_button.y;
                my_current_button = nearest_button;
                break;
            }
        }
        else if (i >= 160)
        {
            display_offset_len = 5;
            display_offset_dir = arg0;
        }
    }
}
