function ai_set_variables(arg0, arg1, arg2, arg3, arg4)
{
    rotation_power_ai = 5;
    ai_target_direction = random_range(0, 360);
    highest_weight = 0;
    highest_weight_dir = 0;
    target_x = 0;
    target_y = 0;
    move_towards_target = false;
    orbit_around_target = false;
    orbit_length = arg1;
    orbit_dir = random_range(0, 360);
    orbit_dir_speed = arg2;
    orbit_trigger_zone_multiplier = arg3;
    orbit_target_zone_multiplier = arg4;
    ticks = 0;
    most_desired_movement_dir_temp = 0;
    most_desired_movement_dir = 0;
    for (i = 0; i < 12; i += 1)
    {
        direction_array[i][0] = 0;
        direction_array[i][1] = 0 + (i * 30);
    }
    move_towards_target = arg0;
    ai_variables_set = true;
}
