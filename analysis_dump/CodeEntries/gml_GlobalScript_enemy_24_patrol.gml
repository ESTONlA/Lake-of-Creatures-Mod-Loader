function enemy_24_patrol()
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
        ai_smooth_rotation(10);
        img_angle += (sin(degtorad(direction - img_angle)) * rotation_speed);
    }
    apply_speed();
    spd += ((0 - spd) * 0.04);
    if (place_meeting(x, y, obj_player))
    {
        player_hurt(1);
    }
    if (timer_use(0))
    {
        spd = 3;
        image_index = 1;
        image_speed = 0.2;
        if (ai_variables_set == true)
        {
            ai_target_direction = point_direction(x, y, x + lengthdir_x(20, random_range(0, 360)), y + lengthdir_y(20, random_range(0, 360)));
        }
        timer_set(0, random_range(25, 35), false);
    }
    if (instance_exists(obj_player))
    {
        set_state(UnknownEnum.Value_9);
        timer_set(1, random_range(90, 160), false);
    }
}

enum UnknownEnum
{
    Value_9 = 9
}
