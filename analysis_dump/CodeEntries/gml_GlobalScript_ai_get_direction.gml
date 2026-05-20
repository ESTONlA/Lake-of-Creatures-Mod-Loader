function ai_get_direction()
{
    if ((ticks % 10) == 0)
    {
        for (i = 0; i < 12; i += 1)
        {
            if (direction_array[i][0] > highest_weight)
            {
                highest_weight = direction_array[i][0];
                highest_weight_dir = direction_array[i][1];
                most_desired_movement_dir = direction_array[i][1];
            }
        }
        for (i = 0; i < 12; i += 1)
        {
            my_dir = 0 + (i * 30);
            var dis_to_check = 50;
            var dis_to_target = point_distance(x + lengthdir_x(dis_to_check, my_dir), y + lengthdir_y(dis_to_check, my_dir), x + lengthdir_x(dis_to_check, ai_target_direction), y + lengthdir_y(dis_to_check, ai_target_direction));
            my_weight = 50 - (dis_to_target / 3);
            for (ii = 0; ii < 50; ii += 1)
            {
                if (wall_collisions_enabled == true)
                {
                    if (place_meeting(x + lengthdir_x(ii, my_dir), y + lengthdir_y(ii, my_dir), obj_solid) || place_meeting(x + lengthdir_x(ii, my_dir), y + lengthdir_y(ii, my_dir), obj_solid_half) || place_meeting(x + lengthdir_x(ii, my_dir), y + lengthdir_y(ii, my_dir), obj_solid_environment) || place_meeting(x + lengthdir_x(ii, my_dir), y + lengthdir_y(ii, my_dir), obj_enemy))
                    {
                        my_weight -= abs(ii - 50);
                        break;
                    }
                }
                else if (place_meeting(x + lengthdir_x(ii, my_dir), y + lengthdir_y(ii, my_dir), obj_enemy))
                {
                    my_weight -= abs(ii - 50);
                    break;
                }
            }
            if (my_dir == highest_weight_dir)
            {
                draw_set_color(c_lime);
            }
            else
            {
                draw_set_color(c_green);
            }
            if (my_weight > 0)
            {
                draw_line(x, y, x + lengthdir_x(my_weight, my_dir), y + lengthdir_y(my_weight, my_dir));
            }
            direction_array[i][0] = my_weight;
        }
        highest_weight = 0;
        draw_set_color(c_white);
        draw_line(x, y, x + lengthdir_x(50, ai_target_direction), y + lengthdir_y(50, ai_target_direction));
    }
}
