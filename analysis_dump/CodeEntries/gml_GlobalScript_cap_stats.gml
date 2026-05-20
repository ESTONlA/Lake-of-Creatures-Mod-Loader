function cap_stats()
{
    if (global.fish_hook_chance_multiplier < 0.1)
    {
        global.fish_hook_chance_multiplier = 0.1;
    }
    if (global.player_hp_max > 10)
    {
        global.player_hp_max = 10;
    }
    if (global.player_hp > 10)
    {
        global.player_hp = 10;
    }
    if (global.player_weapon_primary_ammo_max < 1)
    {
        global.player_weapon_primary_ammo_max = 1;
    }
    if (global.weapon_spread_multiplier <= 0)
    {
        global.weapon_spread_multiplier = 0;
    }
    if (global.bullet_range_multiplier < 0.1)
    {
        global.bullet_range_multiplier = 0.1;
    }
    if (global.player_speed_increase < -0.5)
    {
        global.player_speed_increase = -0.5;
    }
    if (global.fish_time_multiplier < 0.1)
    {
        global.fish_time_multiplier = 0.1;
    }
    if (global.bullet_speed_increase < 0.1)
    {
        global.bullet_speed_increase = 0.1;
    }
    if (global.bullet_speed_increase > 3)
    {
        global.bullet_speed_increase = 3;
    }
    if (global.weapon_temporary_damage_multiplier > 1.5)
    {
        global.weapon_temporary_damage_multiplier = 1.5;
    }
    if (global.weapon_firerate_multiplier_upgrades < 0.1)
    {
        global.weapon_firerate_multiplier_upgrades = 0.1;
    }
}
