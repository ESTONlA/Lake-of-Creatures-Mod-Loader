function bullet_effect_explosive_shot(arg0, arg1)
{
    if (item_effects_disabled == false)
    {
        if (exploding_bullet == true || bomb_bullet == true)
        {
            if (dmg >= 1)
            {
                animation = instance_create_depth(arg0 + lengthdir_x(spd, image_angle), arg1 + lengthdir_y(spd, image_angle), id.depth - 5, obj_animation);
                animation.sprite_index = spr_explosion;
                animation.image_xscale = dmg / 3;
                animation.image_yscale = animation.image_xscale;
                animation.target_xscale = dmg / 2.9;
                animation.target_yscale = animation.target_xscale;
                animation.image_speed = 0.6 + random_range(-0.05, 0.05);
                animation.image_index = 1;
                animation.dmg = dmg;
                animation.freeze_frame_length = 1;
                animation.screen_shake_length = 2;
                animation.explosion_splash_enabled = false;
                animation.hurt_player = !from_player;
                animation.small_explosion_sound = true;
            }
            else
            {
                animation = instance_create_depth(arg0 + lengthdir_x(spd, image_angle), arg1 + lengthdir_y(spd, image_angle), id.depth - 5, obj_animation);
                animation.sprite_index = spr_explosion;
                animation.image_xscale = 1/3;
                animation.image_yscale = animation.image_xscale;
                animation.target_xscale = 0.3448275862068966;
                animation.target_yscale = animation.target_xscale;
                animation.image_speed = 0.6 + random_range(-0.05, 0.05);
                animation.image_index = 1;
                animation.dmg = dmg;
                animation.freeze_frame_length = 1;
                animation.screen_shake_length = 2;
                animation.explosion_splash_enabled = false;
                animation.hurt_player = !from_player;
                animation.small_explosion_sound = true;
            }
        }
    }
}
