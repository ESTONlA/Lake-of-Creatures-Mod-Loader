function get_weapon_ammo(arg0, arg1)
{
    var new_style = true;
    if (new_style == true)
    {
        if (my_bullets == 0)
        {
            var temp_my_bullets = 10 + global.player_weapon_secondary_ammo_increase;
            my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
            if (temp_my_bullets < 1)
            {
                temp_my_bullets = 1;
            }
            my_bullets = floor(my_bullets);
            max_bullets = my_bullets;
        }
    }
    else
    {
        var capacity_decrease_multiplier = 1 - (arg1 / 10);
        if (capacity_decrease_multiplier < 0.1)
        {
            capacity_decrease_multiplier = 0.1;
        }
        if (my_bullets == 0)
        {
            switch (arg0)
            {
                case spr_weapon_machinegun_pickup:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 2:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_shotgun_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 3:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_bow_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 4:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_melee_pickup:
                    var temp_my_bullets = 9999;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 5:
                    var temp_my_bullets = 9999;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_uzi_pickup:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 6:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_harpoon_pickup:
                    var temp_my_bullets = 50;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 7:
                    var temp_my_bullets = 50;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_flamethrower_pickup:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 8:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_bouncesmg_pickup:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 9:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_spreadthrower_pickup:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 10:
                    var temp_my_bullets = 1000;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_minigun_pickup:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 11:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 12:
                    var temp_my_bullets = 100;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_auto_shotgun_pickup:
                    var temp_my_bullets = 100;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 13:
                    var temp_my_bullets = 100;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_crossbow_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 14:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_blaster_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 15:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_blower_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 16:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_shorty_pickup:
                    var temp_my_bullets = 100;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 17:
                    var temp_my_bullets = 100;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_nailgun_pickup:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 18:
                    var temp_my_bullets = 500;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case spr_weapon_kebab_pickup:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
                case 19:
                    var temp_my_bullets = 250;
                    my_bullets = (temp_my_bullets + (global.item_double_ammo * temp_my_bullets)) - (global.item_half_ammo * floor(temp_my_bullets / 2));
                    break;
            }
            my_bullets = floor(my_bullets * capacity_decrease_multiplier);
            max_bullets = my_bullets;
        }
    }
}
