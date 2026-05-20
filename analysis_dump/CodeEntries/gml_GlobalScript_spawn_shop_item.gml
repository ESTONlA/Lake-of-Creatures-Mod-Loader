function spawn_shop_item(arg0, arg1, arg2, arg3)
{
    var item_cost = 150;
    var pickup_cost = 40;
    var mystery_cost = 20;
    if (global.difficulty_selection == 1)
    {
        item_cost = 150;
        pickup_cost = 50;
        mystery_cost = 25;
    }
    switch (arg2)
    {
        case 1:
            cost = item_cost + arg3;
            item = instance_create_depth(arg0, arg1, 50, obj_item_pickup);
            item.cost = floor(cost * global.current_world_block_id.shop_item_cost_multiplier);
            item.my_pool = UnknownEnum.Value_1;
            item.image_index = get_item_index(item.my_pool);
            item.additional_cost = arg3;
            break;
        case 2:
            cost = pickup_cost + arg3;
            item = instance_create_depth(arg0, arg1, 50, obj_pickup_item_pickup);
            item.sprite_index = spr_hp_pickup;
            item.cost = floor(cost * global.current_world_block_id.shop_item_cost_multiplier);
            item.my_pool = UnknownEnum.Value_1;
            item.additional_cost = arg3;
            break;
        case 3:
            cost = pickup_cost + arg3;
            item = instance_create_depth(arg0, arg1, 50, obj_pickup_item_pickup);
            item.sprite_index = spr_pickup_key;
            item.cost = floor(cost * global.current_world_block_id.shop_item_cost_multiplier);
            item.my_pool = UnknownEnum.Value_1;
            item.additional_cost = arg3;
            break;
        case 4:
            cost = 5;
            item = instance_create_depth(arg0, arg1, 50, obj_pickup_item_pickup);
            item.sprite_index = spr_hp_pickup;
            item.cost = cost;
            item.my_pool = UnknownEnum.Value_1;
            item.additional_cost = arg3;
            break;
        case 5:
            cost = 5;
            item = instance_create_depth(arg0, arg1, 50, obj_pickup_item_pickup);
            item.sprite_index = spr_pickup_key;
            item.cost = cost;
            item.my_pool = UnknownEnum.Value_1;
            item.additional_cost = arg3;
            break;
        case 6:
            cost = 5;
            item = instance_create_depth(arg0, arg1, 50, obj_pickup_item_pickup);
            item.sprite_index = spr_hp_extra_pickup;
            item.cost = cost;
            item.my_pool = UnknownEnum.Value_1;
            item.additional_cost = arg3;
            break;
        case 7:
            cost = mystery_cost + arg3;
            item = instance_create_depth(arg0, arg1, 50, obj_chest);
            item.sprite_index = spr_chest_mystery;
            item.cost = floor(cost * global.current_world_block_id.shop_item_cost_multiplier);
            item.additional_cost = arg3;
            item.my_pool = UnknownEnum.Value_1;
            break;
    }
}

enum UnknownEnum
{
    Value_1 = 1
}
