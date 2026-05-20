function fish_movement_roaming()
{
    if (ai_variables_set == true)
    {
        if (timer_allow_movement < 45 && is_fish_hooked() == false)
        {
            timer_allow_movement += 1;
            if (spd > 1)
            {
                spd = 1;
            }
        }
        else if (is_fish_hooked() == false)
        {
            if (spd > 1.75)
            {
                spd = 1.75;
            }
        }
        else if (spd > 1)
        {
            spd = 1;
        }
        if (tutorial_fish == true)
        {
            if (spd > 0.4)
            {
                spd = 0.4;
            }
        }
        apply_speed();
        if (move_towards_target == true)
        {
            ai_get_direction();
        }
        if (fleeing == false)
        {
            ai_smooth_rotation(rotation_speed);
        }
        else
        {
            ai_smooth_rotation(rotation_speed * 0.6);
        }
        ai_target_direction = point_direction(x, y, target_x, target_y);
        ticks += 1;
        image_angle += (sin(degtorad(direction - image_angle)) * rotation_speed);
        if (move_towards_target == true)
        {
            if (collision_circle(target_x, target_y, 5, id, 0, 0) || place_meeting(target_x, target_y, obj_solid) || place_meeting(target_x, target_y, obj_solid_half) || place_meeting(target_x, target_y, obj_solid_environment) || target_x < 90 || target_x > (room_width - 90) || target_y < 90 || target_y > (room_height - 90))
            {
                move_towards_target = false;
                if (fleeing == true)
                {
                    if (instance_exists(obj_player))
                    {
                        if (!collision_circle(x, y, flee_radius, obj_player, 0, 0))
                        {
                            var target_x_temp = x + random_range(-64, 64);
                            var target_y_temp = y + random_range(-64, 64);
                            var check = 0;
                            while (place_meeting(target_x_temp, target_y_temp, obj_solid) || place_meeting(target_x_temp, target_y_temp, obj_solid_half) || place_meeting(target_x_temp, target_y_temp, obj_solid_environment) || target_x_temp < 90 || target_x_temp > (room_width - 90) || target_y_temp < 90 || target_y_temp > (room_height - 90))
                            {
                                target_x_temp = x + random_range(-64, 64);
                                target_y_temp = y + random_range(-64, 64);
                                check += 1;
                                if (check >= 40)
                                {
                                    break;
                                }
                                if (caught == true)
                                {
                                    break;
                                }
                            }
                            target_x = target_x_temp;
                            target_y = target_y_temp;
                            move_towards_target = true;
                        }
                    }
                    else
                    {
                        fleeing = false;
                    }
                }
            }
            else if (fleeing == false)
            {
                spd += ((max_roam_spd - spd) * roam_acc_spd);
            }
            else
            {
                spd += (((max_roam_spd * 4) - spd) * roam_acc_spd);
            }
        }
        else
        {
            spd += ((min_roam_spd - spd) * (roam_acc_spd / 2));
            if (floor(random(150)) == 0 && fleeing == false)
            {
                var target_x_temp = x + random_range(-64, 64);
                var target_y_temp = y + random_range(-64, 64);
                var check = 0;
                while (place_meeting(target_x_temp, target_y_temp, obj_solid) || place_meeting(target_x_temp, target_y_temp, obj_solid_half) || place_meeting(target_x_temp, target_y_temp, obj_solid_environment) || target_x_temp < 90 || target_x_temp > (room_width - 90) || target_y_temp < 90 || target_y_temp > (room_height - 90))
                {
                    target_x_temp = x + random_range(-64, 64);
                    target_y_temp = y + random_range(-64, 64);
                    check += 1;
                    if (check >= 40)
                    {
                        break;
                    }
                    if (caught == true)
                    {
                        break;
                    }
                }
                target_x = target_x_temp;
                target_y = target_y_temp;
                move_towards_target = true;
            }
        }
    }
}
