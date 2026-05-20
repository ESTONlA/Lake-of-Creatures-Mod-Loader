function get_random_weapon(arg0 = false)
{
    if (arg0)
    {
        return choose(spr_weapon_machinegun_pickup, spr_weapon_shotgun_pickup, spr_weapon_bow_pickup, spr_weapon_harpoon_pickup, spr_weapon_bouncesmg_pickup, spr_weapon_uzi_pickup, spr_weapon_shorty_pickup, spr_weapon_blower_pickup, spr_weapon_flamethrower_pickup, spr_weapon_auto_shotgun_pickup, spr_weapon_blaster_pickup, spr_weapon_minigun_pickup, spr_weapon_crossbow_pickup, spr_weapon_kebab_pickup);
    }
    if (global.unlocks_all[12] != 0 && global.unlocks_all[13] != 0)
    {
        if (floor(random(10)) != 0)
        {
            if (floor(random(9)) != 0)
            {
                return choose(spr_weapon_machinegun_pickup, spr_weapon_shotgun_pickup, spr_weapon_bow_pickup, spr_weapon_harpoon_pickup, spr_weapon_bouncesmg_pickup, spr_weapon_uzi_pickup, spr_weapon_shorty_pickup, spr_weapon_blower_pickup);
            }
            else
            {
                return choose(spr_weapon_flamethrower_pickup, spr_weapon_auto_shotgun_pickup, spr_weapon_blaster_pickup);
            }
        }
        else if (floor(random(250)) != 0)
        {
            return choose(spr_weapon_minigun_pickup, spr_weapon_crossbow_pickup);
        }
        else
        {
            return spr_weapon_kebab_pickup;
        }
    }
    else if (global.unlocks_all[12] != 0 && global.unlocks_all[13] == 0)
    {
        if (floor(random(9)) != 0)
        {
            return choose(spr_weapon_machinegun_pickup, spr_weapon_shotgun_pickup, spr_weapon_bow_pickup, spr_weapon_harpoon_pickup, spr_weapon_bouncesmg_pickup);
        }
        else
        {
            return choose(spr_weapon_flamethrower_pickup, spr_weapon_shorty_pickup, spr_weapon_blower_pickup, spr_weapon_uzi_pickup, spr_weapon_crossbow_pickup);
        }
    }
    else
    {
        return choose(spr_weapon_machinegun_pickup, spr_weapon_shotgun_pickup, spr_weapon_bow_pickup, spr_weapon_bouncesmg_pickup, spr_weapon_flamethrower_pickup);
    }
}
