function get_total_blocks_to_spawn()
{
    var lake_number;
    if (global.world_generation_version == 1)
    {
        lake_number = global.current_lake;
    }
    else
    {
        lake_number = my_lake_id;
    }
    switch (lake_number)
    {
        case 1:
            total_blocks_to_spawn = 7;
            if (global.difficulty_selection == 1)
            {
                total_blocks_to_spawn = 8;
            }
            total_dead_ends_limit = 3;
            item_rooms_to_spawn = 1;
            stones_spawned_cap = 0;
            spawn_shop = false;
            lake_type = get_lake_type(lake_number);
            special_common_room_chance = 9999999;
            special_common_room_amount_max = 1;
            break;
        case 2:
            total_blocks_to_spawn = 14;
            if (global.difficulty_selection == 1)
            {
                total_blocks_to_spawn = 15;
            }
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 2;
            stones_spawned_cap = 1;
            spawn_shop = true;
            lake_type = get_lake_type(lake_number);
            break;
        case 3:
            total_blocks_to_spawn = 10;
            if (global.difficulty_selection == 1)
            {
                total_blocks_to_spawn = 13;
            }
            total_dead_ends_limit = 3;
            item_rooms_to_spawn = 1;
            stones_spawned_cap = 1;
            spawn_shop = false;
            lake_type = get_lake_type(lake_number);
            break;
        case 4:
            total_blocks_to_spawn = 16;
            if (global.difficulty_selection == 1)
            {
                total_blocks_to_spawn = 18;
            }
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 2;
            stones_spawned_cap = 2;
            spawn_shop = true;
            lake_type = get_lake_type(lake_number);
            break;
        case 5:
            total_blocks_to_spawn = 15;
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 1;
            stones_spawned_cap = 2;
            spawn_shop = false;
            lake_type = get_lake_type(lake_number);
            break;
        case 6:
            total_blocks_to_spawn = 18;
            if (global.difficulty_selection == 1)
            {
                total_blocks_to_spawn = 19;
            }
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 2;
            stones_spawned_cap = 2;
            spawn_shop = true;
            lake_type = get_lake_type(lake_number);
            break;
        case 7:
            total_blocks_to_spawn = 15;
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 1;
            stones_spawned_cap = 2;
            spawn_shop = false;
            lake_type = get_lake_type(lake_number);
            break;
        case 8:
            total_blocks_to_spawn = 19;
            total_dead_ends_limit = 4;
            item_rooms_to_spawn = 2;
            stones_spawned_cap = 2;
            spawn_shop = true;
            lake_type = get_lake_type(lake_number);
            break;
    }
}
