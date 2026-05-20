function get_damage_stat()
{
    return floor((global.weapon_bullet_damage + global.bullet_damage_increase) * global.weapon_temporary_damage_multiplier * 100);
}
