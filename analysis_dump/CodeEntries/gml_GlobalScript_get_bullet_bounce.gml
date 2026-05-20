function get_bullet_bounce(arg0)
{
    var sound_played = false;
    var bounced = false;
    if (sprite_index == spr_flame)
    {
        sound_played = true;
    }
    if (place_meeting(x + lengthdir_x(spd, direction), y, arg0))
    {
        if (sound_played == false)
        {
            play_sound(87, arg0);
            sound_played = true;
        }
        x += lengthdir_x(spd, direction);
        var spark_animation = true;
        if (sprite_index == spr_flame)
        {
            spark_animation = false;
        }
        var animation;
        if (spark_animation == true)
        {
            animation = instance_create_depth(x + lengthdir_x(spd, image_angle), y + lengthdir_y(spd, image_angle), -50, obj_animation);
            animation.sprite_index = spr_spark_1;
        }
        direction = -direction + 180;
        image_angle = direction;
        if (spark_animation == true)
        {
            image_index = 0;
            alarm[3] = 1;
        }
        x += lengthdir_x(spd, direction);
        y += lengthdir_y(spd, direction);
        if (spark_animation == true)
        {
            animation.image_angle = direction + random_range(-8, 8);
            animation.image_xscale = random_range(1, 1.5);
            animation.image_yscale = animation.image_xscale;
        }
        if (sprite_index == spr_flame || my_source_secondary_weapon == 9)
        {
            spd *= 0.1;
        }
        bounced = true;
    }
    if (place_meeting(x, y + lengthdir_y(spd, direction), arg0))
    {
        if (sound_played == false)
        {
            play_sound(87, arg0);
            sound_played = true;
        }
        y += lengthdir_y(spd, direction);
        var spark_animation = true;
        if (sprite_index == spr_flame)
        {
            spark_animation = false;
        }
        var animation;
        if (spark_animation == true)
        {
            animation = instance_create_depth(x + lengthdir_x(spd, image_angle), y + lengthdir_y(spd, image_angle), -50, obj_animation);
            animation.sprite_index = spr_spark_1;
        }
        direction = -direction;
        image_angle = direction;
        if (spark_animation == true)
        {
            image_index = 0;
            alarm[3] = 1;
        }
        x += lengthdir_x(spd, direction);
        y += lengthdir_y(spd, direction);
        if (spark_animation == true)
        {
            animation.image_angle = direction + random_range(-8, 8);
            animation.image_xscale = random_range(1, 1.5);
            animation.image_yscale = animation.image_xscale;
        }
        if (sprite_index == spr_flame || my_source_secondary_weapon == 9)
        {
            spd *= 0.1;
        }
        bounced = true;
    }
    if (bounced == true)
    {
        bounce_counter += 1;
        alarm[6] = 5;
        if (global.challenge_run_selected == 6)
        {
            if (bounce_shot == true)
            {
                wired_shot = true;
                wired_shot_timer = random_range(5, 50);
            }
        }
        if (player_bullet == true && global.item_bouncy_stone_ball)
        {
            if (has_bounced == false)
            {
                if (global.item_bouncy_stone_ball == true && global.item_bounce_shot == false)
                {
                    bounce_shot = false;
                }
                dmg *= 4;
                has_bounced = true;
            }
        }
        if (squishy_shot == true)
        {
            spd *= 1.6;
            spd_decrease *= 0.4;
            dmg *= 0.7;
            xscale_ext = -0.9;
            yscale_ext = 0.9;
            if (dmg > 0.4)
            {
                img_xscale = dmg * 1;
                img_yscale = dmg * 1;
            }
            else
            {
                img_xscale = 0.4;
                img_yscale = 0.4;
            }
            if (dmg > 1)
            {
                image_xscale = 1;
                image_xscale = 1;
            }
            else
            {
                image_xscale = dmg;
                image_xscale = dmg;
            }
        }
    }
}
