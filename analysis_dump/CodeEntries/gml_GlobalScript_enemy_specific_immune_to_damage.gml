function enemy_specific_immune_to_damage()
{
    if (place_meeting(x, y, obj_bullet))
    {
        oth = instance_place(x, y, obj_bullet);
        if (oth.player_bullet == true && oth.image_index != 0)
        {
            switch (enemy_index)
            {
                case 7:
                    if (phase == 0)
                    {
                        animation = instance_create_depth(oth.x + lengthdir_x(15, oth.image_angle), oth.y + lengthdir_y(15, oth.image_angle), -50, obj_animation);
                        animation.sprite_index = spr_spark_1;
                        animation.image_angle = (oth.direction - 180) + random_range(-8, 8);
                        animation.image_xscale = random_range(1, 1.5);
                        animation.image_yscale = animation.image_xscale;
                        alarm[4] = random_range(120, 160);
                        if (oth.piercing_bullet == false)
                        {
                            instance_destroy(oth);
                        }
                    }
                    break;
                case 21:
                    animation = instance_create_depth(oth.x + lengthdir_x(15, oth.image_angle), oth.y + lengthdir_y(15, oth.image_angle), -50, obj_animation);
                    animation.sprite_index = spr_spark_1;
                    animation.image_angle = (oth.direction - 180) + random_range(-8, 8);
                    animation.image_xscale = random_range(1, 1.5);
                    animation.image_yscale = animation.image_xscale;
                    if (oth.piercing_bullet == false)
                    {
                        var shoot_dir = oth.direction - 180;
                        b = instance_create_depth(oth.x + lengthdir_x(15, oth.image_angle), oth.y + lengthdir_y(15, oth.image_angle), -1, obj_bullet);
                        b.image_angle = shoot_dir + random_range(-8, 8);
                        b.direction = b.image_angle;
                        b.image_xscale = random_range(1, 1.2);
                        b.image_yscale = b.image_xscale;
                        b.bullet_owner = id;
                        b.my_speed = 1;
                        b.dmg_to_deal = 1;
                        instance_destroy(oth);
                    }
                    break;
            }
        }
    }
    if (place_meeting(x, y, obj_hurt_mask))
    {
        oth = instance_place(x, y, obj_hurt_mask);
        if (oth.sprite_index == spr_explosion_mask)
        {
            switch (enemy_index)
            {
                case 7:
                    if (phase == 0)
                    {
                        knockback_movement_len = 1;
                        knockback_movement_dir = point_direction(oth.x, oth.y, x, y);
                        alarm[4] = random_range(120, 160);
                    }
                    break;
            }
        }
    }
}
