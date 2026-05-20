function get_character_specific_starting_stats()
{
    switch (global.playable_characters_selected)
    {
        case 0:
            global.player_weapon_primary_ammo_max = 4;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_pistol;
            global.hud_weapon_icon_2 = spr_weapon_pistol_hud;
            if (global.difficulty_selection == 0)
            {
                global.player_hp = 4;
                global.player_hp_max = 4;
            }
            else
            {
                global.player_hp = 3;
                global.player_hp_max = 3;
            }
            break;
        case 1:
            global.player_weapon_primary_ammo_max = 8;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_ap;
            global.hud_weapon_icon_2 = spr_weapon_ap_hud;
            global.player_hp = 2;
            global.player_hp_max = 2;
            global.weapon_firerate_multiplier_upgrades += 0.2;
            global.item_swerving_bullet = true;
            var item_ind = 66;
            global.item_false_chompers = true;
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
            break;
        case 2:
            global.player_weapon_primary_ammo_max = 2;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_sawed_off;
            global.hud_weapon_icon_2 = spr_weapon_sawed_off_hud;
            global.player_hp = 1;
            global.player_hp_max = 1;
            global.player_speed_increase += 0.1;
            global.player_hp_extra[2] = 1;
            global.player_hp_extra[3] = 1;
            var item_ind = 64;
            global.item_reroll_shot = true;
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
            break;
        case 3:
            global.player_weapon_primary_ammo_max = 25;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_flamethrower;
            global.hud_weapon_icon_2 = spr_weapon_flamethrower_hud;
            global.player_hp = 2;
            global.player_hp_max = 2;
            global.player_speed_increase += 0.1;
            global.bullet_damage_increase -= 0.03;
            global.player_hp_extra[3] = 2;
            var item_ind = 104;
            global.item_fermented_liquid = true;
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
            break;
        case 4:
            global.player_weapon_primary_ammo_max = 15;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_pinkuzi;
            global.hud_weapon_icon_2 = spr_weapon_pinkuzi_hud;
            global.player_hp_extra[1] = 1;
            global.player_hp_extra[2] = 1;
            global.player_hp_extra[3] = 1;
            global.player_hp = 0;
            global.player_hp_max = 0;
            var item_ind = 59;
            global.item_knockback_touch = true;
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
            break;
        case 5:
            global.player_weapon_primary_ammo_max = 6;
            global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
            global.player_weapon_current_sprite = spr_weapon_lasergun;
            global.hud_weapon_icon_2 = spr_weapon_lasergun_hud;
            global.player_hp = 1;
            global.player_hp_max = 4;
            global.item_laser_shot = true;
            var item_ind = 34;
            global.item_jolting_lake = true;
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
            break;
    }
}
