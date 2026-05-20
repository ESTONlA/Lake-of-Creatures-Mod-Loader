function save_room_items()
{
    var save_enabled = true;
    if (global.run_ongoing == false)
    {
        save_enabled = false;
    }
    if (save_enabled == true)
    {
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_weapon_pickup); i += 1)
            {
                find_weapons_array[i] = instance_find(obj_weapon_pickup, i);
                global.previous_world_block_id.weapon_pickup_array[i][0] = find_weapons_array[i].x;
                global.previous_world_block_id.weapon_pickup_array[i][1] = find_weapons_array[i].y;
                global.previous_world_block_id.weapon_pickup_array[i][2] = find_weapons_array[i].sprite_index;
                global.previous_world_block_id.weapon_pickup_array[i][3] = find_weapons_array[i].my_bullets;
                global.previous_world_block_id.weapon_pickup_array[i][4] = find_weapons_array[i].variant;
                global.previous_world_block_id.weapon_pickup_array[i][5] = find_weapons_array[i].ammo_capacity_decrease_amount;
                global.previous_world_block_id.weapon_pickup_array[i][6] = find_weapons_array[i].level;
                global.previous_world_block_id.weapon_pickup_array[i][7] = find_weapons_array[i].xp;
                global.previous_world_block_id.weapon_pickup_array[i][8] = find_weapons_array[i].max_bullets;
                global.previous_world_block_id.weapon_pickups += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_cricket); i += 1)
            {
                find_cricket_array[i] = instance_find(obj_cricket, i);
                global.previous_world_block_id.cricket_pickup_array[i][0] = find_cricket_array[i].x + random_range(-60, 60);
                global.previous_world_block_id.cricket_pickup_array[i][1] = find_cricket_array[i].y + random_range(-60, 60);
                global.previous_world_block_id.cricket_pickup_array[i][2] = find_cricket_array[i].sprite_index;
                global.previous_world_block_id.cricket_pickups += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_solid_environment); i += 1)
            {
                find_environment_array[i] = instance_find(obj_solid_environment, i);
                global.previous_world_block_id.environment_array[i][0] = find_environment_array[i].x;
                global.previous_world_block_id.environment_array[i][1] = find_environment_array[i].y;
                global.previous_world_block_id.environment_array[i][2] = find_environment_array[i].sprite_index;
                global.previous_world_block_id.environment_array[i][3] = find_environment_array[i].image_index;
                global.previous_world_block_id.environment_array[i][4] = find_environment_array[i].object_index;
                global.previous_world_block_id.environment_array[i][5] = find_environment_array[i].cost;
                global.previous_world_block_id.environment_array[i][6] = find_environment_array[i].my_item_type;
                global.previous_world_block_id.environment_array[i][7] = find_environment_array[i].direction;
                global.previous_world_block_id.environment_array[i][8] = find_environment_array[i].spd;
                global.previous_world_block_id.environment_array[i][9] = find_environment_array[i].total_uses;
                global.previous_world_block_id.environment_array[i][10] = find_environment_array[i].save_object_in_room;
                global.previous_world_block_id.environment_objects += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_nonsolid_prop_parent); i += 1)
            {
                find_nonsolid_array[i] = instance_find(obj_nonsolid_prop_parent, i);
                global.previous_world_block_id.nonsolid_array[i][0] = find_nonsolid_array[i].x;
                global.previous_world_block_id.nonsolid_array[i][1] = find_nonsolid_array[i].y;
                global.previous_world_block_id.nonsolid_array[i][2] = find_nonsolid_array[i].sprite_index;
                global.previous_world_block_id.nonsolid_array[i][3] = find_nonsolid_array[i].image_index;
                global.previous_world_block_id.nonsolid_array[i][4] = find_nonsolid_array[i].object_index;
                global.previous_world_block_id.nonsolid_array[i][5] = find_nonsolid_array[i].cost;
                global.previous_world_block_id.nonsolid_array[i][6] = find_nonsolid_array[i].my_item_type;
                global.previous_world_block_id.nonsolid_array[i][7] = find_nonsolid_array[i].direction;
                global.previous_world_block_id.nonsolid_array[i][8] = find_nonsolid_array[i].spd;
                global.previous_world_block_id.nonsolid_objects += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_pickup_item_pickup); i += 1)
            {
                find_pickup_items_array[i] = instance_find(obj_pickup_item_pickup, i);
                global.previous_world_block_id.pickup_items_array[i][0] = find_pickup_items_array[i].x;
                global.previous_world_block_id.pickup_items_array[i][1] = find_pickup_items_array[i].y;
                global.previous_world_block_id.pickup_items_array[i][2] = find_pickup_items_array[i].sprite_index;
                global.previous_world_block_id.pickup_items_array[i][3] = find_pickup_items_array[i].cost;
                global.previous_world_block_id.pickup_items_array[i][4] = find_pickup_items_array[i].image_index;
                global.previous_world_block_id.pickup_items_array[i][5] = find_pickup_items_array[i].cost_type;
                global.previous_world_block_id.pickup_items_array[i][6] = find_pickup_items_array[i].additional_cost;
                global.previous_world_block_id.pickup_items += 1;
            }
        }
        if (global.fish_farm_time_left == -1)
        {
            if (global.previous_world_block_id != -4)
            {
                for (i = 0; i < instance_number(obj_hotspot); i += 1)
                {
                    find_hotspots_array[i] = instance_find(obj_hotspot, i);
                    global.previous_world_block_id.hotspots_array[i][0] = find_hotspots_array[i].x;
                    global.previous_world_block_id.hotspots_array[i][1] = find_hotspots_array[i].y;
                    global.previous_world_block_id.hotspots_array[i][2] = find_hotspots_array[i].sprite_index;
                    global.previous_world_block_id.hotspots_array[i][3] = find_hotspots_array[i].image_xscale;
                    global.previous_world_block_id.hotspots_array[i][4] = find_hotspots_array[i].image_yscale;
                    global.previous_world_block_id.hotspots_array[i][5] = find_hotspots_array[i].my_catch_chance;
                    global.previous_world_block_id.hotspots_array[i][6] = find_hotspots_array[i].my_fishes_left;
                    global.previous_world_block_id.hotspots += 1;
                }
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_item_pickup); i += 1)
            {
                find_items_array[i] = instance_find(obj_item_pickup, i);
                global.previous_world_block_id.items_array[i][0] = find_items_array[i].x;
                global.previous_world_block_id.items_array[i][1] = find_items_array[i].y;
                global.previous_world_block_id.items_array[i][2] = find_items_array[i].image_index;
                global.previous_world_block_id.items_array[i][3] = find_items_array[i].cost;
                global.previous_world_block_id.items_array[i][4] = find_items_array[i].in_clam;
                global.previous_world_block_id.items_array[i][5] = find_items_array[i].my_pool;
                global.previous_world_block_id.items_array[i][6] = find_items_array[i].rerolled;
                global.previous_world_block_id.items_array[i][7] = find_items_array[i].additional_cost;
                global.previous_world_block_id.items += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_cast_blocker); i += 1)
            {
                find_cast_blockers_array[i] = instance_find(obj_cast_blocker, i);
                global.previous_world_block_id.cast_blockers_array[i][0] = find_cast_blockers_array[i].x;
                global.previous_world_block_id.cast_blockers_array[i][1] = find_cast_blockers_array[i].y;
                global.previous_world_block_id.cast_blockers_array[i][2] = find_cast_blockers_array[i].sprite_index;
                global.previous_world_block_id.cast_blockers_array[i][3] = find_cast_blockers_array[i].image_xscale;
                global.previous_world_block_id.cast_blockers_array[i][4] = find_cast_blockers_array[i].image_yscale;
                global.previous_world_block_id.cast_blockers_array[i][5] = find_cast_blockers_array[i].my_type;
                global.previous_world_block_id.cast_blockers += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_water_plant); i += 1)
            {
                find_water_plants_array[i] = instance_find(obj_water_plant, i);
                global.previous_world_block_id.water_plants_array[i][0] = find_water_plants_array[i].x;
                global.previous_world_block_id.water_plants_array[i][1] = find_water_plants_array[i].y;
                global.previous_world_block_id.water_plants_array[i][2] = find_water_plants_array[i].image_index;
                global.previous_world_block_id.water_plants_array[i][3] = find_water_plants_array[i].sprite_index;
                global.previous_world_block_id.water_plants += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_chest); i += 1)
            {
                find_chests_array[i] = instance_find(obj_chest, i);
                if (find_chests_array[i].opened == false)
                {
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][0] = find_chests_array[i].x;
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][1] = find_chests_array[i].y;
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][2] = find_chests_array[i].cost;
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][3] = find_chests_array[i].sprite_index;
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][4] = find_chests_array[i].rerolled;
                    global.previous_world_block_id.chests_array[global.previous_world_block_id.chests][5] = find_chests_array[i].additional_cost;
                    global.previous_world_block_id.chests += 1;
                }
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_machine); i += 1)
            {
                find_machines_array[i] = instance_find(obj_machine, i);
                global.previous_world_block_id.machines_array[global.previous_world_block_id.machines][0] = find_machines_array[i].x;
                global.previous_world_block_id.machines_array[global.previous_world_block_id.machines][1] = find_machines_array[i].y;
                global.previous_world_block_id.machines_array[global.previous_world_block_id.machines][2] = find_machines_array[i].image_index;
                global.previous_world_block_id.machines_array[global.previous_world_block_id.machines][3] = find_machines_array[i].times_used;
                global.previous_world_block_id.machines_array[global.previous_world_block_id.machines][4] = find_machines_array[i].can_use;
                global.previous_world_block_id.machines += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_fish_underwater); i += 1)
            {
                find_fish_array[i] = instance_find(obj_fish_underwater, i);
                if (find_fish_array[i].time_until_despawn > 0)
                {
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][0] = find_fish_array[i].x;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][1] = find_fish_array[i].y;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][2] = find_fish_array[i].time_until_despawn;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][3] = find_fish_array[i].fish_index;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][4] = find_fish_array[i].sprite_index;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][5] = find_fish_array[i].fish_id;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][6] = find_fish_array[i].fish_rarity_point;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][7] = find_fish_array[i].successful_cast_attempts_left;
                    global.previous_world_block_id.fish_array[global.previous_world_block_id.fish_left][8] = find_fish_array[i].catch_fish;
                    global.previous_world_block_id.fish_left += 1;
                }
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_clam); i += 1)
            {
                find_clams_array[i] = instance_find(obj_clam, i);
                global.previous_world_block_id.clams_array[i][0] = find_clams_array[i].x;
                global.previous_world_block_id.clams_array[i][1] = find_clams_array[i].y;
                global.previous_world_block_id.clams_array[i][2] = find_clams_array[i].image_index;
                global.previous_world_block_id.clams_array[i][3] = find_clams_array[i].sprite_index;
                global.previous_world_block_id.clams_array[i][4] = find_clams_array[i].my_item;
                global.previous_world_block_id.clams_array[i][5] = find_clams_array[i].shut;
                global.previous_world_block_id.clams_array[i][6] = find_clams_array[i].do_not_spawn_item;
                global.previous_world_block_id.clams += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_mud); i += 1)
            {
                find_mud_array[i] = instance_find(obj_mud, i);
                global.previous_world_block_id.mud_array[i][0] = find_mud_array[i].x;
                global.previous_world_block_id.mud_array[i][1] = find_mud_array[i].y;
                global.previous_world_block_id.mud_array[i][2] = find_mud_array[i].image_index;
                global.previous_world_block_id.mud_array[i][3] = find_mud_array[i].sprite_index;
                global.previous_world_block_id.mud += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_pink_button); i += 1)
            {
                find_pink_button_array[i] = instance_find(obj_pink_button, i);
                global.previous_world_block_id.pink_button_array[i][0] = find_pink_button_array[i].x;
                global.previous_world_block_id.pink_button_array[i][1] = find_pink_button_array[i].y;
                global.previous_world_block_id.pink_button_array[i][2] = find_pink_button_array[i].image_index;
                global.previous_world_block_id.pink_button += 1;
            }
        }
        if (global.previous_world_block_id != -4)
        {
            for (i = 0; i < instance_number(obj_secret_room_setter); i += 1)
            {
                find_secret_room_array[i] = instance_find(obj_secret_room_setter, i);
                global.previous_world_block_id.secret_room_array[i][0] = find_secret_room_array[i].x;
                global.previous_world_block_id.secret_room_array[i][1] = find_secret_room_array[i].y;
                global.previous_world_block_id.secret_room_array[i][2] = find_secret_room_array[i].hp;
                global.previous_world_block_id.secret_rooms += 1;
            }
        }
    }
}
