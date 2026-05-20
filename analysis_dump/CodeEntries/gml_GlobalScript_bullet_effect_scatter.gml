function bullet_effect_scatter(arg0, arg1)
{
    var scatter_disabled = false;
    var audio_scatter_disabled = false;
    if (burning_shot == true)
    {
        audio_scatter_disabled = true;
    }
    if (item_effects_disabled == false && scatter_disabled == false)
    {
        if (scatter_bullet == true && scatter_bullet_child == false && img_xscale > 0.3 && img_yscale > 0.3 && dmg > 0.075 && instance_number(obj_bullet) < 200)
        {
            for (i = 0; i < 4; i += 1)
            {
                random_dir = random_range(0, 360);
                var b = copy_bullet(arg0 + lengthdir_x(10, random_dir), arg1 + lengthdir_y(10, random_dir));
                if (b != -4)
                {
                    b.scatter_bullet_child = true;
                    b.dmg = dmg * 0.07;
                    b.my_range = my_range * 1;
                    b.my_speed = my_speed / 6;
                    b.image_angle = random_dir;
                    b.direction = b.image_angle;
                }
            }
            if (audio_scatter_disabled == false)
            {
                play_sound(29);
            }
        }
    }
}
