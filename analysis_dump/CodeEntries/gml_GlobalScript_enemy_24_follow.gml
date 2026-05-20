function enemy_24_follow()
{
    depth = -y;
    if (place_meeting(x, y, obj_enemy))
    {
        get_unstuck_bounce(obj_enemy);
    }
    if (ai_variables_set == true)
    {
        ticks += 1;
        ai_get_direction();
        ai_smooth_rotation(20);
        img_angle += (sin(degtorad(direction - img_angle)) * rotation_speed);
    }
    apply_speed();
    spd += ((0 - spd) * 0.02);
    if (place_meeting(x, y, obj_player))
    {
        player_hurt(1);
    }
    if (timer_use(0))
    {
        if (ai_variables_set == true)
        {
            if (instance_exists(obj_player))
            {
                ai_target_direction = point_direction(x, y, obj_player.x + random_range(-32, 32), obj_player.y + random_range(-32, 32));
            }
        }
        spd = 2;
        image_index = 1;
        image_speed = 0;
        xscale_ext = -0.5;
        yscale_ext = 0.5;
        timer_set(0, random_range(25, 35), false);
        timer_set(4, 8, false);
    }
    if (timer_use(1))
    {
        set_state(UnknownEnum.Value_3);
        image_index = 0;
        shake_intensivity = 1;
        counter_state[0] = 0;
        timer_set(2, random_range(30, 35), false);
    }
    if (timer_use(4))
    {
        image_index = 0;
    }
}

enum UnknownEnum
{
    Value_3 = 3
}
