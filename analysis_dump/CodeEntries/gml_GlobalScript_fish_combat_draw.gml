function fish_combat_draw()
{
    if (fish_type == 9)
    {
        laser_anticipation_direction += smooth_rotation(laser_anticipation_direction, direction, 5);
        draw_set_color(c_red);
        draw_set_alpha(laser_anticipation_alpha);
        draw_line_width(x + lengthdir_x(4, laser_anticipation_direction), y + lengthdir_y(4, laser_anticipation_direction), x + lengthdir_x(500, laser_anticipation_direction), y + lengthdir_y(500, laser_anticipation_direction), laser_anticipation_width);
        draw_set_color(c_white);
        draw_set_alpha(1);
    }
}
