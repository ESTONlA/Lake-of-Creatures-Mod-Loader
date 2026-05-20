function ai_move(arg0, arg1, arg2)
{
    var strength_of_direction_change = 5;
    if (move_towards_target == true)
    {
        spd += ((arg1 - spd) * arg2);
        ai_smooth_rotation(rotation_power_ai);
        ai_target_direction = point_direction(x, y, target_x, target_y);
        if (collision_circle(target_x, target_y, orbit_length * orbit_trigger_zone_multiplier, id, 0, 0))
        {
            move_towards_target = false;
            if (arg0 == true)
            {
                orbit_around_target = true;
            }
        }
    }
    else if (orbit_around_target == true)
    {
        ai_target_direction = point_direction(x, y, target_x + lengthdir_x(orbit_length * orbit_target_zone_multiplier, orbit_dir), target_y + lengthdir_y(orbit_length * orbit_target_zone_multiplier, orbit_dir));
        spd += ((arg1 - spd) * arg2);
        direction += (sin(degtorad(most_desired_movement_dir - direction)) * strength_of_direction_change);
        orbit_dir += orbit_dir_speed;
    }
    else
    {
        direction += (sin(degtorad(most_desired_movement_dir - direction)) * strength_of_direction_change);
        spd += ((0 - spd) * arg2);
    }
}
