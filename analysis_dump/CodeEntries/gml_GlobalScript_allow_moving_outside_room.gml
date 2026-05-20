function allow_moving_outside_room(arg0, arg1)
{
    if (global.current_world_block_id != -4)
    {
        var moved_outside_spawn_x = 0;
        var moved_outside_spawn_y = 0;
        var moved_outside = false;
        var room_to_move_to_id = -4;
        if (x < 16)
        {
            moved_outside = true;
            moved_outside_spawn_x = room_width - 32;
            moved_outside_spawn_y = y;
            room_to_move_to_id = instance_nearest(global.current_world_block_id.x - 16, global.current_world_block_id.y, obj_world_gen_block);
        }
        if (x > (room_width - 16))
        {
            moved_outside = true;
            moved_outside_spawn_x = 32;
            moved_outside_spawn_y = y;
            room_to_move_to_id = instance_nearest(global.current_world_block_id.x + 16, global.current_world_block_id.y, obj_world_gen_block);
        }
        if (y < 16)
        {
            moved_outside = true;
            moved_outside_spawn_x = x;
            moved_outside_spawn_y = room_height - 32;
            room_to_move_to_id = instance_nearest(global.current_world_block_id.x, global.current_world_block_id.y - 16, obj_world_gen_block);
        }
        if (y > (room_height - 16))
        {
            moved_outside = true;
            moved_outside_spawn_x = x;
            moved_outside_spawn_y = 32;
            room_to_move_to_id = instance_nearest(global.current_world_block_id.x, global.current_world_block_id.y + 16, obj_world_gen_block);
        }
        if (moved_outside == true && room_to_move_to_id != -4)
        {
            switch (arg0)
            {
                case 0:
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][0] = moved_outside_spawn_x;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][1] = moved_outside_spawn_y;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][2] = arg1.sprite_index;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][3] = arg1.image_index;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][4] = arg1.object_index;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][5] = arg1.cost;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][6] = arg1.my_item_type;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][7] = arg1.direction;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][8] = arg1.spd;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][9] = arg1.total_uses;
                    room_to_move_to_id.environment_array[room_to_move_to_id.environment_objects][10] = arg1.save_object_in_room;
                    room_to_move_to_id.environment_objects += 1;
                    break;
            }
            for (var i = 0; i < 4; i += 1)
            {
                var animation = instance_create_depth(x + random_range(-18, 18), y + random_range(-18, 18), depth - 5, obj_animation);
                animation.sprite_index = spr_poof;
                animation.image_index = random_range(0, 1);
                animation.image_speed = random_range(0.7, 0.9);
                animation.image_angle = random_range(0, 360);
                animation.xscale_ext = 1.1;
                animation.yscale_ext = 1.1;
            }
            instance_destroy();
        }
    }
}
