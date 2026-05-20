function enemy_24_attack_charge_up()
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
        var point_dir = direction;
        if (instance_exists(obj_player))
        {
            point_dir = point_direction(x, y, obj_player.x, obj_player.y);
        }
        img_angle += (sin(degtorad(point_dir - img_angle)) * rotation_speed);
    }
    apply_speed();
    spd += ((0 - spd) * 0.04);
    if (counter_state[0] < 3)
    {
        shake_intensivity += ((2 - shake_intensivity) * 0.06);
    }
    if (place_meeting(x, y, obj_player))
    {
        player_hurt(1);
    }
    if (timer_use(2))
    {
        if (counter_state[0] < 3)
        {
            var shoot_dir = direction;
            if (instance_exists(obj_player))
            {
                shoot_dir = point_direction(x, y + yy, obj_player.x, obj_player.y);
            }
            play_sound(26);
            b = instance_create_depth(x, y + yy, -1, obj_bullet);
            b.image_angle = shoot_dir + random_range(-5, 5);
            b.direction = b.image_angle;
            b.image_xscale = random_range(1, 1.2);
            b.image_yscale = b.image_xscale;
            b.bullet_owner = id;
            b.my_speed = 2;
            b.bounce_shot = true;
            counter_state[0] += 1;
            xscale_ext = 0.2;
            yscale_ext = -0.2;
            timer_set(2, 6, false);
        }
        else
        {
            shake_intensivity = 0;
            timer_set(3, random_range(90, 160), false);
        }
    }
    if (timer_use(3))
    {
        set_state(UnknownEnum.Value_9);
        timer_set(1, random_range(90, 160), false);
    }
}

enum UnknownEnum
{
    Value_9 = 9
}
