function drop_item(arg0, arg1, arg2)
{
    var drop_amount = 1;
    if (global.item_double_pickup_spawn == true)
    {
        if (floor(random(2)) == 0)
        {
            drop_amount = 2;
        }
    }
    if (arg0 == "ITEM")
    {
        drop_amount = 1;
    }
    for (var i = 0; i < drop_amount; i += 1)
    {
        switch (arg0)
        {
            case "WEAPON":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_weapon_pickup);
                drop.sprite_index = get_random_weapon();
                drop.variant = 0;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                break;
            case "KEY":
                if (floor(random(12)) == 0 && global.unlocks_all[17] >= 2)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_pickup_key_bloody;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.cost = 1;
                }
                else
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_pickup_key;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                }
                break;
            case "KEY_NOT_BLOODY":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_pickup_key;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                break;
            case "HP":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_hp_pickup;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                break;
            case "HP_EXTRA":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_hp_extra_pickup;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                if (global.unlocks_all[11] != 0)
                {
                    drop.image_index = choose(0, 0, 0, 1, 1, 2, 3, 3, 4, 4);
                }
                else
                {
                    drop.image_index = 0;
                }
                break;
            case "INVERTED_HP":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_hp_extra_pickup;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(3, 4);
                drop.image_index = 6;
                break;
            case "COIN":
                if (floor(random(17)) == 0 && global.unlocks_all[17] >= 2)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup_bloody;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.spd_decrease = random_range(0.05, 0.07);
                    drop.cost = 1;
                }
                else if (floor(random(10)) == 0)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                else
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup_silver;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                break;
            case "COIN_SILVER":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_coin_pickup_silver;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                drop.spd_decrease = random_range(0.05, 0.07);
                break;
            case "COIN_GOLD":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_coin_pickup;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                drop.spd_decrease = random_range(0.05, 0.07);
                break;
            case "COIN_NOT_BLOODY":
                if (floor(random(10)) == 0)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                else
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup_silver;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                break;
            case "COIN_AFTER_BOSS":
                if (floor(random(25)) == 0 && global.unlocks_all[17] >= 2)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup_bloody;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 4);
                    drop.spd_decrease = random_range(0.05, 0.07);
                    drop.cost = 1;
                }
                else if (floor(random(10)) == 0)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 4);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                else
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_coin_pickup_silver;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 5);
                    drop.spd_decrease = random_range(0.05, 0.07);
                }
                break;
            case "ITEM":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_item_pickup);
                drop.in_clam = false;
                drop.my_pool = UnknownEnum.Value_0;
                drop.image_index = get_item_index(drop.my_pool);
                break;
            case "BOTTLE":
                if (global.unlocks_all[8] >= 2)
                {
                    drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                    drop.sprite_index = spr_bottle_pickup;
                    drop.direction = random_range(0, 360);
                    drop.spd = random_range(2, 3);
                }
                break;
            case "AMMO_CRATE":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_ammo_crate);
                drop.direction = random_range(0, 359);
                drop.spd = 2;
                break;
            case "ITEM_CHEST":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_chest);
                drop.sprite_index = spr_chest_purple;
                drop.direction = random_range(0, 359);
                drop.spd = 2;
                break;
            case "COIN_BLOODY_TEST":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_coin_pickup_bloody;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                drop.spd_decrease = random_range(0.05, 0.07);
                drop.cost = 1;
                break;
            case "KEY_BLOODY_TEST":
                drop = instance_create_layer(arg1, arg2, "Instances", obj_pickup_item_pickup);
                drop.sprite_index = spr_pickup_key_bloody;
                drop.direction = random_range(0, 360);
                drop.spd = random_range(2, 3);
                drop.cost = 1;
                break;
        }
    }
}

enum UnknownEnum
{
    Value_0
}
