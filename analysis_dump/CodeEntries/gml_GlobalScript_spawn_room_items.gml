function spawn_room_items()
{
    if (global.current_world_block_id.weapon_pickups > 0)
    {
        for (i = 0; i < global.current_world_block_id.weapon_pickups; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.weapon_pickup_array[i][0];
            spawner.spawn_y = global.current_world_block_id.weapon_pickup_array[i][1];
            spawner.obj_to_spawn = obj_weapon_pickup;
            spawner.spr_index = global.current_world_block_id.weapon_pickup_array[i][2];
            spawner.natural_spawn = 0;
            spawner.ammo_left = global.current_world_block_id.weapon_pickup_array[i][3];
            spawner.variant = global.current_world_block_id.weapon_pickup_array[i][4];
            spawner.ammo_capacity_decrease_amount = global.current_world_block_id.weapon_pickup_array[i][5];
            spawner.level = global.current_world_block_id.weapon_pickup_array[i][6];
            spawner.xp = global.current_world_block_id.weapon_pickup_array[i][7];
            spawner.max_bullets = global.current_world_block_id.weapon_pickup_array[i][8];
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.cricket_pickups > 0)
    {
        for (i = 0; i < global.current_world_block_id.cricket_pickups; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.cricket_pickup_array[i][0];
            spawner.spawn_y = global.current_world_block_id.cricket_pickup_array[i][1];
            spawner.spr_index = global.current_world_block_id.cricket_pickup_array[i][2];
            spawner.obj_to_spawn = obj_cricket;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.environment_objects > 0)
    {
        for (i = 0; i < global.current_world_block_id.environment_objects; i += 1)
        {
            if (global.current_world_block_id.environment_array[i][10] == true)
            {
                spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
                spawner.spawn_x = global.current_world_block_id.environment_array[i][0];
                spawner.spawn_y = global.current_world_block_id.environment_array[i][1];
                spawner.spr_index = global.current_world_block_id.environment_array[i][2];
                spawner.img_index = global.current_world_block_id.environment_array[i][3];
                spawner.obj_to_spawn = global.current_world_block_id.environment_array[i][4];
                spawner.cost = global.current_world_block_id.environment_array[i][5];
                spawner.my_item_type = global.current_world_block_id.environment_array[i][6];
                spawner.dir = global.current_world_block_id.environment_array[i][7];
                spawner.spd = global.current_world_block_id.environment_array[i][8];
                spawner.total_uses = global.current_world_block_id.environment_array[i][9];
                spawner.natural_spawn = 0;
                spawner.randomized = 0;
            }
        }
    }
    if (global.current_world_block_id.nonsolid_objects > 0)
    {
        for (i = 0; i < global.current_world_block_id.nonsolid_objects; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.nonsolid_array[i][0];
            spawner.spawn_y = global.current_world_block_id.nonsolid_array[i][1];
            spawner.spr_index = global.current_world_block_id.nonsolid_array[i][2];
            spawner.img_index = global.current_world_block_id.nonsolid_array[i][3];
            spawner.obj_to_spawn = global.current_world_block_id.nonsolid_array[i][4];
            spawner.cost = global.current_world_block_id.nonsolid_array[i][5];
            spawner.my_item_type = global.current_world_block_id.nonsolid_array[i][6];
            spawner.dir = global.current_world_block_id.nonsolid_array[i][7];
            spawner.spd = global.current_world_block_id.nonsolid_array[i][8];
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.pickup_items > 0)
    {
        for (i = 0; i < global.current_world_block_id.pickup_items; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.pickup_items_array[i][0];
            spawner.spawn_y = global.current_world_block_id.pickup_items_array[i][1];
            spawner.spr_index = global.current_world_block_id.pickup_items_array[i][2];
            spawner.cost = global.current_world_block_id.pickup_items_array[i][3];
            spawner.img_index = global.current_world_block_id.pickup_items_array[i][4];
            spawner.cost_type = global.current_world_block_id.pickup_items_array[i][5];
            spawner.additional_cost = global.current_world_block_id.pickup_items_array[i][6];
            spawner.obj_to_spawn = obj_pickup_item_pickup;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.hotspots > 0)
    {
        for (i = 0; i < global.current_world_block_id.hotspots; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.hotspots_array[i][0];
            spawner.spawn_y = global.current_world_block_id.hotspots_array[i][1];
            spawner.spr_index = global.current_world_block_id.hotspots_array[i][2];
            spawner.image_xscale = global.current_world_block_id.hotspots_array[i][3];
            spawner.image_yscale = global.current_world_block_id.hotspots_array[i][4];
            spawner.my_catch_chance = global.current_world_block_id.hotspots_array[i][5];
            spawner.my_fishes_left = global.current_world_block_id.hotspots_array[i][6];
            spawner.obj_to_spawn = obj_hotspot;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.items > 0)
    {
        for (i = 0; i < global.current_world_block_id.items; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.items_array[i][0];
            spawner.spawn_y = global.current_world_block_id.items_array[i][1];
            spawner.img_index = global.current_world_block_id.items_array[i][2];
            spawner.cost = global.current_world_block_id.items_array[i][3];
            spawner.in_clam = global.current_world_block_id.items_array[i][4];
            spawner.my_pool = global.current_world_block_id.items_array[i][5];
            spawner.rerolled = global.current_world_block_id.items_array[i][6];
            spawner.additional_cost = global.current_world_block_id.items_array[i][7];
            spawner.obj_to_spawn = obj_item_pickup;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.cast_blockers > 0)
    {
        for (i = 0; i < global.current_world_block_id.cast_blockers; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.cast_blockers_array[i][0];
            spawner.spawn_y = global.current_world_block_id.cast_blockers_array[i][1];
            spawner.spr_index = global.current_world_block_id.cast_blockers_array[i][2];
            spawner.image_xscale = global.current_world_block_id.cast_blockers_array[i][3];
            spawner.image_yscale = global.current_world_block_id.cast_blockers_array[i][4];
            spawner.my_type = global.current_world_block_id.cast_blockers_array[i][5];
            spawner.obj_to_spawn = obj_cast_blocker;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.water_plants > 0)
    {
        for (i = 0; i < global.current_world_block_id.water_plants; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.water_plants_array[i][0];
            spawner.spawn_y = global.current_world_block_id.water_plants_array[i][1];
            spawner.img_index = global.current_world_block_id.water_plants_array[i][2];
            spawner.spr_index = global.current_world_block_id.water_plants_array[i][3];
            spawner.obj_to_spawn = obj_water_plant;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.chests > 0)
    {
        for (i = 0; i < global.current_world_block_id.chests; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.chests_array[i][0];
            spawner.spawn_y = global.current_world_block_id.chests_array[i][1];
            spawner.cost = global.current_world_block_id.chests_array[i][2];
            spawner.spr_index = global.current_world_block_id.chests_array[i][3];
            spawner.rerolled = global.current_world_block_id.chests_array[i][4];
            spawner.additional_cost = global.current_world_block_id.chests_array[i][5];
            spawner.obj_to_spawn = obj_chest;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.machines > 0)
    {
        for (i = 0; i < global.current_world_block_id.machines; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.machines_array[i][0];
            spawner.spawn_y = global.current_world_block_id.machines_array[i][1];
            spawner.img_index = global.current_world_block_id.machines_array[i][2];
            spawner.times_used = global.current_world_block_id.machines_array[i][3];
            spawner.can_use = global.current_world_block_id.machines_array[i][4];
            spawner.spr_index = spr_machine;
            spawner.obj_to_spawn = obj_machine;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.fish_left > 0)
    {
        for (i = 0; i < global.current_world_block_id.fish_left; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.fish_array[i][0];
            spawner.spawn_y = global.current_world_block_id.fish_array[i][1];
            spawner.time_until_despawn = global.current_world_block_id.fish_array[i][2];
            spawner.fish_id = global.current_world_block_id.fish_array[i][3];
            spawner.spr_index = global.current_world_block_id.fish_array[i][4];
            spawner.fish_id_real = global.current_world_block_id.fish_array[i][5];
            spawner.fish_rarity_point = global.current_world_block_id.fish_array[i][6];
            spawner.successful_cast_attempts_left = global.current_world_block_id.fish_array[i][7];
            spawner.catch_fish = global.current_world_block_id.fish_array[i][8];
            spawner.obj_to_spawn = obj_fish_underwater;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.clams > 0)
    {
        for (i = 0; i < global.current_world_block_id.clams; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.clams_array[i][0];
            spawner.spawn_y = global.current_world_block_id.clams_array[i][1];
            spawner.img_index = global.current_world_block_id.clams_array[i][2];
            spawner.spr_index = global.current_world_block_id.clams_array[i][3];
            spawner.clam_my_item = global.current_world_block_id.clams_array[i][4];
            spawner.clam_shut = global.current_world_block_id.clams_array[i][5];
            spawner.clam_do_not_spawn_item = global.current_world_block_id.clams_array[i][6];
            spawner.obj_to_spawn = obj_clam;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.mud > 0)
    {
        for (i = 0; i < global.current_world_block_id.mud; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.mud_array[i][0];
            spawner.spawn_y = global.current_world_block_id.mud_array[i][1];
            spawner.img_index = global.current_world_block_id.mud_array[i][2];
            spawner.spr_index = global.current_world_block_id.mud_array[i][3];
            spawner.obj_to_spawn = obj_mud;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.pink_button > 0)
    {
        for (i = 0; i < global.current_world_block_id.pink_button; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.pink_button_array[i][0];
            spawner.spawn_y = global.current_world_block_id.pink_button_array[i][1];
            spawner.img_index = global.current_world_block_id.pink_button_array[i][2];
            spawner.obj_to_spawn = obj_pink_button;
            spawner.spr_index = spr_pink_button;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
    if (global.current_world_block_id.secret_rooms > 0)
    {
        for (i = 0; i < global.current_world_block_id.secret_rooms; i += 1)
        {
            spawner = instance_create_depth(0, 0, 0, obj_persistent_spawner);
            spawner.spawn_x = global.current_world_block_id.secret_room_array[i][0];
            spawner.spawn_y = global.current_world_block_id.secret_room_array[i][1];
            spawner.hp = global.current_world_block_id.secret_room_array[i][2];
            spawner.obj_to_spawn = obj_secret_room_setter;
            spawner.spr_index = spr_secret_room_setter;
            spawner.natural_spawn = 0;
            spawner.randomized = 0;
        }
    }
}
