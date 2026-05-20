function get_aiming()
{
    if (global.gamepad_enabled == true)
    {
        var gamepad_axis_h = (input_value("axis_h_pos") - input_value("axis_h_neg")) * 30;
        var gamepad_axis_v = (input_value("axis_v_pos") - input_value("axis_v_neg")) * 30;
        if (gamepad_axis_h != 0 || gamepad_axis_v != 0)
        {
            distance_from_mouse = point_direction(x, y - 10, x + gamepad_axis_h, (y - 10) + gamepad_axis_v);
            mouse_direction = point_direction(x, y - 10, x + gamepad_axis_h, (y - 10) + gamepad_axis_v);
        }
    }
    else
    {
        distance_from_mouse = point_distance(x, y - 10, mouse_x, mouse_y);
        mouse_direction = point_direction(x, y - 10, mouse_x, mouse_y);
    }
}
