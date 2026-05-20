function get_weapon_name(arg0)
{
    var weapon_name = "asd";
    switch (arg0)
    {
        case spr_weapon_machinegun_pickup:
            weapon_name = txt("weapon_machinegun");
            break;
        case 2:
            weapon_name = txt("weapon_machinegun");
            break;
        case 3:
            weapon_name = txt("weapon_shotgun");
            break;
        case spr_weapon_shotgun_pickup:
            weapon_name = txt("weapon_shotgun");
            break;
        case 4:
            weapon_name = txt("weapon_bow");
            break;
        case spr_weapon_bow_pickup:
            weapon_name = txt("weapon_bow");
            break;
        case 6:
            weapon_name = txt("weapon_smg");
            break;
        case spr_weapon_uzi_pickup:
            weapon_name = txt("weapon_smg");
            break;
        case 7:
            weapon_name = txt("weapon_harpoongun");
            break;
        case spr_weapon_harpoon_pickup:
            weapon_name = txt("weapon_harpoongun");
            break;
        case 8:
            weapon_name = txt("weapon_flamethrower");
            break;
        case spr_weapon_flamethrower_pickup:
            weapon_name = txt("weapon_flamethrower");
            break;
        case 9:
            weapon_name = txt("weapon_minismg");
            break;
        case spr_weapon_bouncesmg_pickup:
            weapon_name = txt("weapon_minismg");
            break;
        case 10:
            weapon_name = txt("weapon_spreadthrower");
            break;
        case spr_weapon_spreadthrower_pickup:
            weapon_name = txt("weapon_spreadthrower");
            break;
        case 11:
            weapon_name = txt("weapon_minigun");
            break;
        case spr_weapon_minigun_pickup:
            weapon_name = txt("weapon_minigun");
            break;
        case 12:
            weapon_name = txt("weapon_heavymg");
            break;
        case 13:
            weapon_name = txt("weapon_auto_shotgun");
            break;
        case spr_weapon_auto_shotgun_pickup:
            weapon_name = txt("weapon_auto_shotgun");
            break;
        case 14:
            weapon_name = txt("weapon_auto_crossbow");
            break;
        case spr_weapon_crossbow_pickup:
            weapon_name = txt("weapon_auto_crossbow");
            break;
        case 15:
            weapon_name = txt("weapon_blaster");
            break;
        case spr_weapon_blaster_pickup:
            weapon_name = txt("weapon_blaster");
            break;
        case 16:
            weapon_name = txt("weapon_blower");
            break;
        case spr_weapon_blower_pickup:
            weapon_name = txt("weapon_blower");
            break;
        case 17:
            weapon_name = txt("weapon_shorty_shotty");
            break;
        case spr_weapon_shorty_pickup:
            weapon_name = txt("weapon_shorty_shotty");
            break;
        case 18:
            weapon_name = txt("weapon_nailgun");
            break;
        case spr_weapon_nailgun_pickup:
            weapon_name = txt("weapon_nailgun");
            break;
        case 19:
            weapon_name = txt("weapon_kebab");
            break;
        case spr_weapon_kebab_pickup:
            weapon_name = txt("weapon_kebab");
            break;
        default:
            weapon_name = "none";
            break;
    }
    return weapon_name;
}
