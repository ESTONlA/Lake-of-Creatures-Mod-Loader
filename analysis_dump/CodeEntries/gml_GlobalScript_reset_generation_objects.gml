function reset_generation_objects()
{
    if (global.world_generation_version == 1)
    {
        instance_destroy(obj_world_gen_block);
        instance_destroy(obj_world_gen_block_dead_end);
        instance_destroy(obj_world_gen_block_player_start);
        instance_destroy();
        instance_create_depth(0, 0, 0, obj_world_gen);
    }
    else
    {
        global.lake_array_state[my_lake_id] = 0;
        var my_blocks_list = ds_list_create();
        var my_blocks_num = collision_rectangle_list(check_range_x1, check_range_y1, check_range_x2, check_range_y2, obj_world_gen_block, false, true, my_blocks_list, false);
        if (my_blocks_num > 0)
        {
            for (var i = 0; i < my_blocks_num; i += 1)
            {
                instance_destroy(ds_list_find_value(my_blocks_list, i));
            }
        }
        ds_list_destroy(my_blocks_list);
        my_blocks_list = ds_list_create();
        my_blocks_num = collision_rectangle_list(check_range_x1, check_range_y1, check_range_x2, check_range_y2, obj_world_gen_block_dead_end, false, true, my_blocks_list, false);
        if (my_blocks_num > 0)
        {
            for (var i = 0; i < my_blocks_num; i += 1)
            {
                instance_destroy(ds_list_find_value(my_blocks_list, i));
            }
        }
        ds_list_destroy(my_blocks_list);
        instance_destroy(my_player_id);
        var lake_gen = instance_create_depth(0, 0, 0, obj_world_gen);
        lake_gen.my_lake_id = my_lake_id;
        global.lake_array[my_lake_id] = lake_gen;
        instance_destroy();
    }
    show_debug_message("-------------- Generation FAILED - Lake: " + string(my_lake_id) + " - restarting generation");
}
