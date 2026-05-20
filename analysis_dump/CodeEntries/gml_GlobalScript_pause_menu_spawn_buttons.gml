function pause_menu_spawn_buttons()
{
    view_x_current = camera_get_view_x(view_camera[0]);
    view_y_current = camera_get_view_y(view_camera[0]);
    if (instance_exists(obj_button_menu))
    {
        instance_destroy(obj_button_menu);
    }
    if (instance_exists(obj_slider))
    {
        instance_destroy(obj_slider);
    }
    var x_middle = room_width / 2;
    var y_middle = room_height / 2;
    if (instance_exists(obj_pause))
    {
        x_middle = obj_pause.view_x_current + 240;
        y_middle = obj_pause.view_y_current + 135;
    }
    var button = instance_create_depth(x_middle, y_middle + 15 + 5, -999, obj_button_menu);
    button.button_index = 39;
    button = instance_create_depth(x_middle, y_middle + 15 + 25, -999, obj_button_menu);
    button.button_index = 2;
    button = instance_create_depth(x_middle, y_middle + 15 + 45, -999, obj_button_menu);
    button.button_index = 48;
    button = instance_create_depth(x_middle, y_middle + 15 + 65, -999, obj_button_menu);
    button.button_index = 40;
    if (instance_exists(obj_pause))
    {
        var item_tooltip_x = (obj_pause.view_x_current + 480) - 23;
        var item_tooltip_y = obj_pause.view_y_current + 23;
        var item_tooltip_in_row = 0;
        for (var i = 0; i < global.items_this_run_amount; i += 1)
        {
            var tooltip = instance_create_depth(item_tooltip_x, item_tooltip_y, 0, obj_tooltip_mask);
            tooltip.index = global.items_this_run[i];
            tooltip.tooltip_type = 2;
            tooltip.image_xscale = 0.8;
            tooltip.image_yscale = 0.8;
            item_tooltip_in_row += 1;
            item_tooltip_y += 23;
            if (item_tooltip_in_row >= 11)
            {
                item_tooltip_x -= 23;
                item_tooltip_y = view_y_current + 23;
                item_tooltip_in_row = 0;
            }
        }
    }
}
