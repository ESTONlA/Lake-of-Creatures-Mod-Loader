function spawn_object(arg0, arg1)
{
    switch (arg1)
    {
        case 1:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_machinegun_pickup;
            obj.natural_spawn = arg0;
            break;
        case 2:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_cricket);
            obj.natural_spawn = arg0;
            break;
        case 3:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_shotgun_pickup;
            obj.natural_spawn = arg0;
            break;
        case 4:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_grass_block);
            obj.natural_spawn = arg0;
            break;
        case 5:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_mine);
            obj.natural_spawn = arg0;
            break;
        case 6:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pickup_item_pickup);
            obj.sprite_index = spr_hud_hp;
            obj.natural_spawn = arg0;
            break;
        case 7:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_hotspot);
            obj.natural_spawn = arg0;
            obj.image_xscale = choose(1, 2, 3, 4, 5);
            obj.image_yscale = choose(1, 2, 3, 4, 5);
            obj.my_catch_chance = choose(100, 200, 300, 400, 500);
            obj.my_fishes_left = choose(1, 2, 3);
            break;
        case 8:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_stones);
            obj.natural_spawn = arg0;
            break;
        case 9:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_item_pickup);
            obj.natural_spawn = arg0;
            break;
        case 10:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_block_lock);
            obj.natural_spawn = arg0;
            break;
        case 11:
            drop_item("KEY", mouse_x, mouse_y);
            break;
        case 12:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_bow_pickup;
            obj.natural_spawn = arg0;
            break;
        case 13:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_flower);
            obj.natural_spawn = arg0;
            break;
        case 14:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_money_lock);
            obj.natural_spawn = arg0;
            break;
        case 15:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_platform);
            obj.natural_spawn = arg0;
            break;
        case 16:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_npc);
            obj.natural_spawn = arg0;
            break;
        case 17:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_chest);
            obj.natural_spawn = arg0;
            obj.sprite_index = choose(spr_chest_regular, spr_chest_hp, spr_chest_weapon, spr_chest_purple, spr_chest_moon, spr_chest_golden);
            break;
        case 18:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_machine);
            obj.natural_spawn = arg0;
            obj.sprite_index = choose(spr_machine);
            break;
        case 19:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_melee_pickup;
            obj.natural_spawn = arg0;
            break;
        case 20:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_fish_underwater);
            obj.natural_spawn = arg0;
            break;
        case 21:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_uzi_pickup;
            obj.natural_spawn = arg0;
            break;
        case 22:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_harpoon_pickup;
            obj.natural_spawn = arg0;
            break;
        case 23:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_flamethrower_pickup;
            obj.natural_spawn = arg0;
            break;
        case 24:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_bouncesmg_pickup;
            obj.natural_spawn = arg0;
            break;
        case 25:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_spreadthrower_pickup;
            obj.natural_spawn = arg0;
            break;
        case 26:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_minigun_pickup;
            obj.natural_spawn = arg0;
            break;
        case 27:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = spr_weapon_heavymg_pickup;
            obj.natural_spawn = arg0;
            break;
        case 28:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_spikes);
            obj.sprite_index = spr_spikes;
            obj.natural_spawn = arg0;
            break;
        case 29:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_clam);
            obj.sprite_index = spr_clam;
            obj.natural_spawn = arg0;
            break;
        case 30:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_ammo_crate);
            obj.natural_spawn = arg0;
            break;
        case 31:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pickup_item_pickup);
            obj.sprite_index = spr_hp_extra_pickup;
            obj.image_index = choose(0, 1, 2, 3, 4, 5, 6, 7);
            obj.natural_spawn = arg0;
            break;
        case 32:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_shopkeeper_flash);
            obj.natural_spawn = arg0;
            break;
        case 33:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_cricket);
            obj.natural_spawn = arg0;
            obj.sprite_index = spr_cricket_gold;
            break;
        case 34:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_mud);
            obj.natural_spawn = arg0;
            break;
        case 35:
            drop_item("COIN", mouse_x, mouse_y);
            break;
        case 36:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_time_lock_outline);
            obj.natural_spawn = arg0;
            break;
        case 37:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_moon_lock);
            obj.natural_spawn = arg0;
            break;
        case 38:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pink_button);
            obj.natural_spawn = arg0;
            break;
        case 39:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pink_lock_outline);
            obj.natural_spawn = arg0;
            break;
        case 40:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pink_lock);
            obj.natural_spawn = arg0;
            break;
        case 41:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_moneycap_lock);
            obj.natural_spawn = arg0;
            break;
        case 42:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_weapon_pickup);
            obj.sprite_index = get_random_weapon(true);
            obj.natural_spawn = arg0;
            break;
        case 43:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_leaf);
            obj.natural_spawn = arg0;
            break;
        case 44:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_secret_room_setter);
            obj.natural_spawn = arg0;
            break;
        case 45:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_spikes_hidden);
            obj.natural_spawn = arg0;
            break;
        case 46:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_stones);
            obj.natural_spawn = arg0;
            obj.sprite_index = spr_stone_battle;
            obj.image_index = 0;
            break;
        case 47:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_move_lock);
            obj.natural_spawn = arg0;
            obj.sprite_index = choose(spr_move_lock, spr_tnt_block, spr_blo_block);
            break;
        case 48:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_yellow_button);
            obj.natural_spawn = arg0;
            break;
        case 49:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_yellow_lock);
            obj.natural_spawn = arg0;
            break;
        case 50:
            drop_item("BOTTLE", mouse_x, mouse_y);
            break;
        case 51:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_chest);
            obj.sprite_index = spr_chest_mystery;
            obj.natural_spawn = arg0;
            break;
        case 52:
            drop = instance_create_layer(mouse_x, mouse_y, "Instances", obj_pickup_item_pickup);
            drop.sprite_index = spr_pickup_key_spec;
            drop.direction = random_range(0, 360);
            drop.spd = random_range(2, 3);
            break;
        case 53:
            drop = instance_create_layer(mouse_x, mouse_y, "Instances", obj_hatch);
            break;
        case 54:
            drop_item("KEY_BLOODY_TEST", mouse_x, mouse_y);
            break;
    }
}
