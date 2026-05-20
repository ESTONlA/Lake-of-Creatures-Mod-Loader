function set_enemy_on_fire(arg0)
{
    if (burning == false)
    {
        for (var i = 0; i < 4; i += 1)
        {
            animation = instance_create_depth(x + random_range(-8, 8), y + random_range(-8, 8), depth - 5, obj_animation);
            animation.sprite_index = spr_flame_small;
            animation.image_speed = random_range(0.85, 1);
            animation.image_index = random_range(0, 2);
        }
        if (arg0 != -4)
        {
            if (instance_exists(arg0))
            {
                arg0.fire_aura_white_alpha = 1.8;
            }
        }
    }
    burning = true;
    draw_color = 4235519;
}
