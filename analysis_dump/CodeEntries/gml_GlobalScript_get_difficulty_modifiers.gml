function get_difficulty_modifiers()
{
    switch (global.difficulty_selection)
    {
        case 0:
            global.difficulty_mod_primary_ammo = 1.5;
            global.difficulty_mod_primary_dmg = 1.25;
            global.difficulty_mod_enemy_speed = 0.75;
            global.difficulty_mod_enemy_shot_speed = 0.75;
            global.difficulty_mod_range = 1.5;
            global.difficulty_mod_spread = 0.5;
            break;
        case 1:
            global.difficulty_mod_primary_ammo = 1;
            global.difficulty_mod_primary_dmg = 1;
            global.difficulty_mod_enemy_speed = 1;
            global.difficulty_mod_enemy_shot_speed = 1;
            global.difficulty_mod_range = 1;
            global.difficulty_mod_spread = 1;
            break;
    }
    global.player_weapon_primary_ammo_max = floor(global.player_weapon_primary_ammo_max * global.difficulty_mod_primary_ammo);
    global.player_weapon_primary_ammo = global.player_weapon_primary_ammo_max;
    global.bullet_damage_increase = global.bullet_damage_increase * global.difficulty_mod_primary_dmg;
    global.bullet_range_multiplier = global.bullet_range_multiplier * global.difficulty_mod_range;
    global.weapon_spread_multiplier = global.weapon_spread_multiplier * global.difficulty_mod_spread;
}
