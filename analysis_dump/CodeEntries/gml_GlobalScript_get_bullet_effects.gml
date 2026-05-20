function get_bullet_effects()
{
    if (global.item_spread_shot == true)
    {
        if (sprite_index != spr_pixel)
        {
            direction += random_range(-15, 15);
            image_angle = direction;
        }
        else
        {
            direction += random_range(-30, 30);
            image_angle = direction;
        }
    }
    if (global.item_ghost_shot == true)
    {
        wall_collisions_enabled = false;
        if (melee_attack == true)
        {
            image_alpha = 0.7;
        }
    }
    if (global.item_wobble_shot == true)
    {
        wobble_shot = true;
    }
    if (global.item_super_wobble_shot == true)
    {
        wobble_super_shot = true;
    }
    if (global.item_lob_shot == true)
    {
        if (melee_attack == false)
        {
            var lob_amount = 5 + global.weapon_lob_height;
            yy_spd = -lob_amount;
            yy = -(lob_amount * 2);
            lob_shot = true;
            if (sprite_index == spr_bullet_player)
            {
                sprite_index = spr_bullet_bubble_player;
            }
        }
    }
    if (global.item_homing_shot == true)
    {
        homing_bullet = true;
        homing = true;
        if (sprite_index == spr_bullet_player || sprite_index == spr_bullet)
        {
            sprite_index = spr_bullet_homing;
        }
        else
        {
            my_color = 16711935;
        }
    }
    if (global.item_exploding_shot == true)
    {
        if (melee_attack == false)
        {
            exploding_bullet = true;
        }
    }
    if (global.item_scatter_shot == true)
    {
        if (melee_attack == false)
        {
            scatter_bullet = true;
        }
    }
    if (global.item_split_shot == true)
    {
        if (melee_attack == false)
        {
            split_bullet = true;
            alarm[1] = 5;
        }
    }
    if (global.item_odd_spell == true)
    {
        if (melee_attack == false && player_bullet == false)
        {
            if (floor(random(20)) == 0)
            {
                split_bullet = true;
                alarm[1] = 5;
            }
        }
    }
    if (global.item_bounce_shot == true)
    {
        if (melee_attack == false)
        {
            bounce_shot = true;
        }
    }
    if (global.item_bomb_shot == true)
    {
        if (melee_attack == false)
        {
            img_xscale -= 0.36;
            img_yscale -= 0.36;
            bomb_bullet = true;
            if (place_meeting(x, y, obj_bullet))
            {
                oth = instance_place(x, y, obj_bullet);
                if (oth.bomb_bullet == true)
                {
                    get_unstuck(obj_bullet);
                }
            }
            xscale_ext = 0.3;
            yscale_ext = -0.3;
            sprite_index = spr_bullet_bomb;
            my_speed = my_speed / 3;
            alarm[1] = 120 - choose(0, 1, 2);
            alarm[4] = 45 - choose(0, 1, 2);
        }
    }
    if (global.item_stun_shot == true)
    {
        stun_bullet = true;
    }
    if (global.item_pull_shot == true)
    {
        if (melee_attack == false)
        {
            knockback_direction_offset = 180;
            knockback_speed_multiplier = 0.3;
        }
    }
    if (global.item_pierce_shot == true)
    {
        if (melee_attack == false)
        {
            piercing_bullet = true;
            if (sprite_index == spr_bullet_player)
            {
                sprite_index = spr_bullet_player_piercing;
            }
        }
    }
    if (global.item_blessing_ahti_effect_active == true)
    {
        if (melee_attack == false)
        {
            if (floor(random(2)) == 0)
            {
                exploding_bullet = true;
            }
        }
    }
    if (global.item_wrap_shot == true)
    {
        wrap_shot = true;
    }
    if (global.item_freeze_shot == true)
    {
        if (melee_attack == false)
        {
            if (floor(random(10)) == 0)
            {
                freeze_bullet = true;
                sprite_index = spr_bullet_freeze_player;
            }
        }
    }
    if (global.item_shell_shot == true)
    {
        if (melee_attack == false)
        {
            bullet_destroying_shot = true;
            sprite_index = spr_bullet_shell_player;
        }
    }
    if (global.item_fifth_shot_double_damage == true)
    {
        global.item_fifth_shot_double_damage_count += 1;
        if (global.item_fifth_shot_double_damage_count >= 5)
        {
            dmg *= 2;
            global.item_fifth_shot_double_damage_count = 0;
        }
    }
    if (global.item_bouncy_stone_ball == true)
    {
        bounce_shot = true;
        dmg *= 0.5;
    }
    if (global.item_wired_shot == true)
    {
        wired_shot = true;
        wired_shot_timer = random_range(5, 50);
    }
    if (global.item_duplication_shot == true && duplication_shot_child == false)
    {
        duplication_shot = true;
        duplication_shot_timer = random_range(5, 20);
    }
    if (global.item_boomerang_shot == true)
    {
        boomerang_shot = true;
        boomerang_shot_dir = direction;
        boomerang_shot_timer = my_range * global.bullet_range_multiplier * 0.5;
        boomerang_shot_dir_multiplier = choose(-1, 1);
        boomerang_shot_spd_add = random_range(-0.05, 0.05);
    }
    if (global.item_division_shot == true)
    {
        if (division_shot_child == false)
        {
            division_shot = true;
        }
    }
    if (global.item_fire_shot == true)
    {
        fire_shot = true;
    }
    if (global.item_squishy_shot == true)
    {
        bounce_shot = true;
        squishy_shot = true;
        if (sprite_index == spr_bullet_player)
        {
            sprite_index = spr_bullet_player_squishy;
        }
    }
    if (global.item_swerving_bullet == true)
    {
        if (global.birgit_wand_misses_left <= 0)
        {
            swerving_bullet = true;
            swerving_bullet_timer = random_range(6, 15);
            if (floor(random(1)) == 0)
            {
                swerving_bullet_timer = random_range(9, 15);
                swerving_bullet_dir = random_range(-1.5, 1.5);
                if (global.player_weapon_current != 1)
                {
                    swerving_bullet_dir = random_range(-0.4, 0.4);
                }
            }
            else
            {
                swerving_bullet_dir = 0;
            }
        }
    }
}
