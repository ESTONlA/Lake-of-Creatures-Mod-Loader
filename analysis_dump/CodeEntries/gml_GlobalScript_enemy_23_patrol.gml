function scr_enemy_23_patrol()
{
    depth = -y;
    if (img_angle > 90 && img_angle < 270)
    {
        image_yscale = -1;
    }
    else
    {
        image_yscale = 1;
    }
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
        timer_set(0, 60, false);
    }
    if (instance_exists(obj_player))
    {
        ai_target_direction = point_direction(x, y, obj_player.x, obj_player.y);
        if (can_see_player())
        {
            target_direction = point_direction(x, y, obj_player.x, obj_player.y);
        }
    }
}
