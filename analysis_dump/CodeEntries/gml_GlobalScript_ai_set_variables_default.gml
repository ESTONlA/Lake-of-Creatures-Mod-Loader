function ai_set_variables_default()
{
    ai_target_direction = random_range(0, 360);
    highest_weight = 0;
    highest_weight_dir = 0;
    target_x = 0;
    target_y = 0;
    move_towards_target = false;
    orbit_around_target = false;
    orbit_length = 70;
    orbit_dir = random_range(0, 360);
    orbit_dir_speed = choose(1, 1.1, 1.2, -1, -1.1, -1.2);
    orbit_trigger_zone_multiplier = 6;
    orbit_target_zone_multiplier = choose(1.4, 1.45, 1.5, 1.55, 1.6);
    ticks = 0;
    most_desired_movement_dir = 0;
    for (i = 0; i < 12; i += 1)
    {
        direction_array[i][0] = 0;
        direction_array[i][1] = 0 + (i * 30);
    }
    move_towards_target = true;
    ai_variables_set = true;
}
