function get_item_effects(arg0)
{
    log_info("> treasure pickup: " + string(arg0) + " | gamepad: " + string(global.gamepad_enabled));
    switch (arg0)
    {
        case 0:
            global.bullets_shot_at_once += 2;
            global.item_spread_shot = true;
            add_outfit(spr_outfit_mutant_fish);
            break;
        case 1:
            global.item_homing_shot = true;
            global.player_b_color_h = 210;
            global.player_b_color_s = 236;
            global.player_b_color_v = 236;
            global.player_core_type = 2;
            global.player_core_type_modifier_1 = 2;
            global.player_core_type_modifier_2 = 6;
            global.player_core_fill = 64;
            break;
        case 2:
            global.item_ghost_shot = true;
            global.player_bullet_size = 1.1;
            global.player_b_color_h = 118;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            global.player_shape_index = 2;
            global.player_core_type = 9;
            global.player_core_type_modifier_1 = 1.7;
            global.player_core_type_modifier_2 = 2.2;
            break;
        case 3:
            add_outfit(spr_outfit_finger);
            global.item_faster_reload = true;
            break;
        case 4:
            global.item_regen_at_tent = true;
            global.bullet_damage_increase += 0.1;
            break;
        case 5:
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.bullet_range_multiplier += 0.1;
            break;
        case 6:
            global.item_honey_drop = true;
            global.player_b_color_h = 35;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            break;
        case 7:
            add_outfit(spr_outfit_magnet);
            global.item_pickup_pull = true;
            global.bullet_range_multiplier += 0.15;
            break;
        case 8:
            global.item_scatter_shot = true;
            global.player_bullet_size = 1.2;
            global.player_shape_index = 3;
            global.player_core_size = 80;
            global.player_core_type = 0;
            global.player_b_color_h = 20;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            break;
        case 9:
            add_outfit(spr_outfit_eyeball);
            global.bullet_damage_increase += 0.1;
            global.bullet_speed_increase = global.bullet_speed_increase * 0.6;
            global.reloading_speed_increase -= 0.05;
            global.item_exploding_shot = true;
            global.player_bullet_size = 1.4;
            global.player_b_color_h = 13;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            global.player_core_fill = 90;
            global.player_core_pulse = 1;
            break;
        case 10:
            global.item_double_ammo = true;
            global.player_weapon_primary_ammo_max = global.player_weapon_primary_ammo_max * 2;
            break;
        case 11:
            global.item_boat_knockback_reduction = true;
            global.item_gun = 1;
            global.player_weapon_primary_ammo_max += 15;
            if (global.player_weapon_current == 1)
            {
                global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            }
            global.bullet_damage_increase -= 0.05;
            if (instance_exists(obj_player))
            {
                with (obj_player)
                {
                    get_weapon_variables();
                }
            }
            global.player_shape_index = 5;
            global.player_bullet_trail = 1.4;
            global.player_core_type = 0;
            global.player_bullet_size = 0.7;
            break;
        case 12:
            global.bullet_damage_increase += 0.25;
            global.weapon_spread_multiplier += 0.4;
            global.player_b_color_h = 37;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            break;
        case 13:
            global.item_double_headed_frog = true;
            global.bullet_damage_increase -= 0.1;
            break;
        case 14:
            global.item_pierce_shot = true;
            global.player_shape_index = 1;
            global.player_core_type = 0;
            global.player_bullet_size = 0.9;
            global.player_bullet_trail = 4;
            global.player_core_fill = 70;
            global.player_b_color_h = 34;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            break;
        case 15:
            global.bullet_damage_increase += 0.2;
            global.item_explosion_resistance = true;
            break;
        case 16:
            global.item_pull_shot = true;
            global.bullet_damage_increase += 0.4;
            global.player_b_color_h = 230;
            global.player_b_color_s = 240;
            global.player_b_color_v = 240;
            global.player_core_type = 6;
            global.player_core_size = 55;
            global.player_core_type_modifier_1 = 2.2;
            global.player_core_type_modifier_2 = 5;
            global.player_core_fill = 86;
            global.player_bullet_trail = 5;
            global.player_shape_index = 2;
            break;
        case 17:
            global.bullet_damage_increase += 0.25;
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            break;
        case 18:
            global.weapon_firerate_multiplier_upgrades -= 0.125;
            break;
        case 19:
            global.bullet_range_multiplier += 0.15;
            break;
        case 20:
            global.player_speed_increase = 0.3;
            break;
        case 21:
            global.bullet_damage_increase += 0.15;
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.player_b_color_h = 166;
            global.player_b_color_s = 135;
            global.player_b_color_v = 211;
            break;
        case 22:
            global.weapon_firerate_multiplier_upgrades -= 0.05;
            break;
        case 23:
            global.player_speed_increase = 0.2;
            break;
        case 24:
            global.fish_hook_chance_multiplier -= 0.1;
            global.item_msg_bottle_hp = 5;
            global.item_msg_bottle = true;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 0, obj_item_bottle);
            }
            break;
        case 25:
            global.item_gunpowder_guts = true;
            break;
        case 26:
            global.bullet_damage_increase += 0.2;
            break;
        case 27:
            global.item_wet_gunpowder = true;
            global.player_b_color_h = 18;
            global.player_b_color_s = 255;
            global.player_b_color_v = 255;
            break;
        case 28:
            global.item_nearby_burn = true;
            global.weapon_firerate_multiplier_upgrades -= 0.2;
            break;
        case 29:
            global.item_boat_shots = true;
            global.player_bullet_size = 0.8;
            global.bullet_damage_increase += 0.25;
            break;
        case 30:
            global.weapon_firerate_multiplier_upgrades -= 0.2;
            global.player_speed_increase -= 0.1;
            global.item_oil_spill = true;
            break;
        case 31:
            global.item_bounce_shot = true;
            global.player_b_color_h = 64;
            global.player_b_color_s = 242;
            global.player_b_color_v = 242;
            break;
        case 32:
            global.item_split_shot = true;
            global.bullet_damage_increase += 0.35;
            global.player_b_color_h = 206;
            global.player_b_color_s = 18;
            global.player_b_color_v = 189;
            global.player_bullet_trail = 1.5;
            global.player_core_fill = 100;
            break;
        case 33:
            global.melee_attackrate_increase += 10;
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            break;
        case 34:
            global.item_jolting_lake = true;
            global.bullet_damage_increase += 0.15;
            break;
        case 35:
            global.melee_attackrate_increase += 10;
            break;
        case 36:
            global.item_thorn_vest = true;
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            break;
        case 37:
            global.item_crocodile_skin = true;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_crocodile_skin);
            }
            break;
        case 38:
            global.item_sad_heart = true;
            break;
        case 39:
            global.item_rubber_duck = true;
            global.player_hp = global.player_hp_max;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_rubber_duck);
            }
            break;
        case 40:
            if (global.player_hp == global.player_hp_max)
            {
                global.player_hp_max += 1;
            }
            else
            {
                global.player_hp = global.player_hp_max;
            }
            global.item_bursting_heart = true;
            break;
        case 41:
            global.item_damage_block = true;
            break;
        case 42:
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.fish_value_multiplier += 0.1;
            break;
        case 43:
            global.item_fishing_magnet = true;
            break;
        case 44:
            global.item_boat_flamethrower = true;
            global.player_speed_increase -= 0.125;
            break;
        case 45:
            global.bullet_range_multiplier -= 0.6;
            var ammo_increase_amount = 2;
            global.player_weapon_secondary_ammo_increase += ammo_increase_amount;
            global.player_weapon_primary_ammo_max += ammo_increase_amount;
            break;
        case 46:
            global.item_fish_cracker = true;
            break;
        case 47:
            global.item_lifebuoy = true;
            break;
        case 48:
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            global.player_speed_increase -= 0.1;
            break;
        case 49:
            global.item_squishy_shot = true;
            global.bullet_damage_increase += 0.05;
            global.weapon_spread_multiplier += 0.3;
            global.player_b_color_h = 237;
            global.player_b_color_s = 196;
            global.player_b_color_v = 242;
            global.player_bullet_trail = 2.5;
            global.player_bullet_size = 0.6;
            global.player_core_fill = 80;
            global.player_shape_index = 5;
            break;
        case 50:
            global.item_shotgun_blast = true;
            global.bullet_damage_increase = global.bullet_damage_increase * 0.3;
            break;
        case 51:
            global.item_toxic_immunity = true;
            break;
        case 52:
            global.item_kill_hp_regen = true;
            global.bullet_damage_increase += 0.075;
            break;
        case 53:
            global.item_catch_hp_regen = true;
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            break;
        case 54:
            global.item_melee_shot = true;
            break;
        case 55:
            global.item_coal = true;
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            break;
        case 56:
            global.item_water_bucket = true;
            global.weapon_firerate_multiplier_upgrades -= 0.125;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_water_bucket);
            }
            break;
        case 57:
            if (global.player_hp_max > 1)
            {
                global.player_hp_max = 1;
                global.player_hp = global.player_hp_max;
            }
            global.bullet_damage_increase += 0.4;
            break;
        case 58:
            global.item_blessing_ahti = true;
            break;
        case 59:
            global.item_knockback_touch = true;
            break;
        case 60:
            global.item_stun_shot = true;
            break;
        case 61:
            global.item_freeze_shot = true;
            global.player_b_color_h = 144;
            global.player_b_color_s = 158;
            global.player_b_color_v = 170;
            break;
        case 62:
            global.item_shell_shot = true;
            global.player_b_color_h = 104;
            global.player_b_color_s = 172;
            global.player_b_color_v = 170;
            break;
        case 63:
            global.item_jammed_clip = true;
            global.weapon_firerate_multiplier_upgrades -= 0.1;
            break;
        case 64:
            global.item_reroll_shot = true;
            global.player_b_color_h = 36;
            global.player_b_color_s = 162;
            global.player_b_color_v = 152;
            break;
        case 65:
            global.item_chest_reroll_shot = true;
            global.player_b_color_h = 44;
            global.player_b_color_s = 116;
            global.player_b_color_v = 152;
            break;
        case 66:
            global.item_false_chompers = true;
            global.bullet_damage_increase += 0.075;
            break;
        case 67:
            global.bullet_damage_increase += 0.15;
            break;
        case 68:
            global.item_nearby_stun = true;
            global.bullet_range_multiplier += 0.2;
            break;
        case 69:
            global.item_melee_pierce_shot = true;
            break;
        case 70:
            global.item_boomerang_shot = true;
            break;
        case 71:
            global.item_daggers = true;
            var random_dir = choose(0, 360);
            if (instance_exists(obj_player))
            {
                for (var i = 0; i < 3; i += 1)
                {
                    var dagger = instance_create_depth(obj_player.x, obj_player.y, 100, obj_dagger);
                    dagger.offset = random_dir + (i * 120);
                }
            }
            break;
        case 72:
            global.item_clam_soup = true;
            break;
        case 73:
            global.item_pinecone_hp = 15;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_pinecone);
            }
            break;
        case 74:
            global.bullet_damage_increase += 0.2;
            break;
        case 75:
            global.item_super_wobble_shot = true;
            global.bullet_damage_increase += 0.25;
            break;
        case 76:
            global.item_random_hp_drop = true;
            break;
        case 77:
            global.bullet_damage_increase += 0.2;
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.upgrade_mod_enemy_shot_speed += 0.2;
            break;
        case 78:
            global.item_fifth_shot_double_damage = true;
            break;
        case 79:
            global.item_gold_nugget = true;
            global.item_gold_nugget_active = true;
            global.item_gold_nugget_money = 0;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_gold_nugget);
            }
            break;
        case 80:
            global.item_random_enemy_explosions = true;
            var ammo_increase_amount = 1;
            global.player_weapon_secondary_ammo_increase += ammo_increase_amount;
            global.player_weapon_primary_ammo_max += ammo_increase_amount;
            break;
        case 81:
            global.item_fire_more_damage = true;
            break;
        case 82:
            global.item_spike_immunity = true;
            break;
        case 83:
            global.fish_value_multiplier += 0.05;
            break;
        case 84:
            global.item_merge_shots = true;
            break;
        case 85:
            global.item_freeze_ray = true;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 0, obj_ice_ball);
            }
            break;
        case 86:
            global.item_sea_tumor = true;
            global.item_sea_tumor_level = 0;
            break;
        case 87:
            global.item_bonfire = true;
            break;
        case 88:
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            for (var i = 0; i < 5; i += 1)
            {
                var r2 = choose(0, 1);
                switch (r2)
                {
                    case 0:
                        drop_item("HP", obj_player.x, obj_player.y);
                        break;
                    case 1:
                        drop_item("HP_EXTRA", obj_player.x, obj_player.y);
                        break;
                }
            }
            break;
        case 89:
            global.item_staff = true;
            if (instance_exists(obj_player))
            {
                instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_staff);
            }
            break;
        case 90:
            global.item_gun_lure = true;
            break;
        case 91:
            global.bullet_speed_increase = global.bullet_speed_increase * 0.65;
            global.item_ghost_shot = true;
            global.item_wrap_shot = true;
            global.player_b_color_h = 220;
            global.player_b_color_s = 236;
            global.player_b_color_v = 236;
            global.player_shape_index = 1;
            global.player_bullet_spin_spd = 8;
            break;
        case 92:
            global.item_bomb_float = true;
            break;
        case 93:
            global.item_double_pickup_spawn = true;
            break;
        case 94:
            global.item_laser_shot = true;
            global.bullet_damage_increase += 0.2;
            break;
        case 95:
            global.item_torpedo = true;
            break;
        case 96:
            global.item_shop_variety = true;
            break;
        case 97:
            global.weapon_spread_multiplier -= 0.5;
            global.bullet_range_multiplier -= 0.5;
            global.bullet_speed_increase = global.bullet_speed_increase * 0.5;
            global.item_lob_shot = true;
            global.player_b_color_h = 22;
            global.player_b_color_s = 122;
            global.player_b_color_v = 122;
            break;
        case 98:
            global.item_wobble_shot = true;
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.player_b_color_h = 10;
            global.player_b_color_s = 200;
            global.player_b_color_v = 255;
            break;
        case 99:
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            global.bullet_speed_increase = global.bullet_speed_increase * 0.8;
            global.player_b_color_h = 16;
            global.player_b_color_s = 180;
            global.player_b_color_v = 255;
            break;
        case 100:
            global.item_division_shot = true;
            break;
        case 101:
            global.bullet_speed_increase = global.bullet_speed_increase * 1.25;
            global.weapon_firerate_multiplier_upgrades += 0.125;
            global.bullet_damage_increase += 0.2;
            break;
        case 102:
            global.fish_time_multiplier += 0.2;
            global.player_hp_max += 1;
            global.player_hp = global.player_hp_max;
            break;
        case 103:
            global.bullet_damage_increase += 0.15;
            global.fish_time_multiplier -= 0.15;
            break;
        case 104:
            global.item_fermented_liquid = true;
            global.player_b_color_h = 44;
            global.player_b_color_s = 58;
            global.player_b_color_v = 146;
            break;
        case 105:
            global.weapon_firerate_multiplier_upgrades -= 0.18;
            global.item_tougher_night = true;
            break;
        case 106:
            global.weapon_firerate_multiplier_upgrades -= 0.075;
            var ammo_increase_amount = 1;
            global.player_weapon_secondary_ammo_increase += ammo_increase_amount;
            global.player_weapon_primary_ammo_max += ammo_increase_amount;
            break;
        case 107:
            global.item_fire_shot = true;
            global.bullet_damage_increase += 0.1;
            global.player_b_color_h = 16;
            global.player_b_color_s = 108;
            global.player_b_color_v = 211;
            break;
        case 108:
            var ammo_increase_amount = floor((10 + global.player_weapon_secondary_ammo_increase) * 0.5);
            if (ammo_increase_amount >= 1)
            {
                global.player_weapon_secondary_ammo_increase += ammo_increase_amount;
            }
            else
            {
                global.player_weapon_secondary_ammo_increase += 1;
            }
            global.player_weapon_primary_ammo_max = floor(global.player_weapon_primary_ammo_max * 1.5);
            get_weapon_variables();
            global.player_b_color_h = 142;
            global.player_b_color_s = 134;
            global.player_b_color_v = 211;
            break;
        case 109:
            global.item_fire_breath = true;
            add_outfit(spr_outfit_dragons_breath);
            break;
        case 110:
            global.item_bouncy_stone_ball = true;
            break;
        case 111:
            global.fish_time_multiplier += 0.3;
            break;
        case 112:
            global.item_love_wand = true;
            break;
        case 113:
            global.item_dull_knife = true;
            break;
        case 114:
            global.item_skillet = true;
            break;
    }
    cap_stats();
    adjust_extra_hp();
    if (get_damage_stat() >= 500)
    {
        achievement_get("DMG_150");
    }
    if (get_damage_stat() >= 1000)
    {
        achievement_get("DMG_200");
    }
    if (global.run_ongoing == true)
    {
        task_add_condition(26);
        if (global.unlocks[0][arg0] == 2)
        {
            global.unlocks[0][arg0] = 3;
        }
        item_displayer = instance_create_depth(0, 0, -700, obj_item_displayer);
        item_displayer.item_name = get_item_name(arg0);
        item_displayer.item_desc = get_item_desc(arg0);
        update_unlocks();
    }
}
