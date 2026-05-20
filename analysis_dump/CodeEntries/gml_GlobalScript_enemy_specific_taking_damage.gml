function enemy_specific_taking_damage(arg0)
{
    switch (enemy_index)
    {
        case 1:
            if (phase == 0 && alarm[4] > 1)
            {
                alarm[4] = 1;
            }
            break;
        case 3:
            spd = 0;
            alarm[4] = 60;
            break;
        case 4:
            spd = spd / 2;
            break;
        case 6:
            spd = 0;
            break;
        case 7:
            if (phase == 0)
            {
                alarm[4] = random_range(120, 160);
            }
            break;
        case 19:
            if (instance_exists(arg0))
            {
                if (phase == 3 && arg0.melee_attack == true)
                {
                    phase = 0;
                    spd *= 0.5;
                    alarm[4] = 1;
                }
            }
            break;
        case 27:
            spd *= 0.3;
            break;
        case 37:
            if (instance_exists(arg0))
            {
                if (phase == 1 && arg0.melee_attack == true)
                {
                    alarm[4] = 1;
                    shake_intensivity = 0;
                    phase = 3;
                    image_index = 0;
                }
            }
            break;
        case 38:
            if (instance_exists(arg0))
            {
                if (phase == 5 && arg0.melee_attack == true)
                {
                    spd *= 0.45;
                }
            }
            break;
        case 42:
            spooker_hide_timer = 90;
            break;
        case 45:
            spooker_hide_timer = 60;
            break;
        case 47:
            if (phase == 1 && arg0.melee_attack == true)
            {
                xscale_ext = -0.3;
                yscale_ext = 0.7;
                play_sound(26);
                for (var i = 0; i < 8; i += 1)
                {
                    shoot_dir = 0 + (i * 45);
                    b = instance_create_depth(x + lengthdir_x(7, shoot_dir), y + lengthdir_y(7, shoot_dir), -1, obj_bullet);
                    b.sprite_index = spr_bullet;
                    b.image_angle = shoot_dir;
                    b.direction = b.image_angle;
                    b.image_xscale = random_range(1, 1.2);
                    b.image_yscale = b.image_xscale;
                    b.bullet_owner = id;
                    b.my_speed = 2;
                    b.my_range = 700;
                    b.dmg_to_deal = dmg_to_deal;
                    b.deflect_disabled = true;
                    b.wall_collisions_enabled = true;
                }
            }
            break;
    }
}
