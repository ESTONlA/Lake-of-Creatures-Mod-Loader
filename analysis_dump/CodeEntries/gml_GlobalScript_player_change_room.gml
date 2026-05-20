function player_change_room()
{
    var fish_hooked = false;
    if (instance_exists(obj_rope_holder_end))
    {
        if (obj_rope_holder_end.fish_on_underwater == true)
        {
            fish_hooked = true;
        }
    }
    if (instance_exists(obj_fish_caught))
    {
        fish_hooked = true;
    }
    var room_change_allowed = false;
    var allowed_enemy_amount = 0;
    if (global.run_ongoing == false)
    {
        allowed_enemy_amount = 3;
    }
    var current_room_name = room_get_name(room);
    current_room_name = string_copy(current_room_name, 1, 9);
    if (global.room_transition == 0 && !instance_exists(obj_transition) && !instance_exists(obj_transition_area_start) && global.player_is_dead == false && !instance_exists(obj_enemy_wave_spawner) && !instance_exists(obj_enemy_spawn_square) && (global.in_boss_room == false || (global.in_boss_room == true && current_room_name == "rm_CHOICE")))
    {
        room_change_allowed = true;
    }
    if (global.room_leave_cooldown > 0)
    {
        room_change_allowed = false;
    }
    if (x < 16)
    {
        if (global.can_leave_room == true && (instance_number(obj_enemy_spawner) + instance_number(obj_enemy) + instance_number(obj_sausage_room_rewards) + instance_number(obj_enemy_wave_battle_spawner)) <= allowed_enemy_amount && fish_hooked == false && !instance_exists(obj_cricket_gold_use) && room_change_allowed == true)
        {
            t = instance_create_depth(0, 0, -1000, obj_transition);
            t.player_target_x = room_width - 20;
            t.player_target_y = y;
            global.room_transition = 1;
            global.previous_world_block_id = instance_nearest(obj_world_gen_block_player_start.x, obj_world_gen_block_player_start.y, obj_world_gen_block);
            leaving_room();
            save_room_items();
            obj_world_gen_block_player_start.x -= 16;
            obj_world_gen_block_player_start.my_x -= 16;
            obj_camera.transition_x_target -= 480;
            global.boost_speed_multiplier_saved = global.boost_speed_multiplier_current;
            global.player_h_spd_saved = h_spd;
            global.player_v_spd_saved = v_spd;
            if (instance_exists(obj_skull))
            {
                with (obj_skull)
                {
                    x_to_change = 512;
                }
            }
        }
        else
        {
            x = 16;
        }
    }
    if (x > (room_width - 16))
    {
        if (global.can_leave_room == true && (instance_number(obj_enemy_spawner) + instance_number(obj_enemy) + instance_number(obj_sausage_room_rewards) + instance_number(obj_enemy_wave_battle_spawner)) <= allowed_enemy_amount && fish_hooked == false && !instance_exists(obj_cricket_gold_use) && room_change_allowed == true)
        {
            t = instance_create_depth(0, 0, -1000, obj_transition);
            t.player_target_x = 20;
            t.player_target_y = y;
            global.room_transition = 1;
            global.previous_world_block_id = instance_nearest(obj_world_gen_block_player_start.x, obj_world_gen_block_player_start.y, obj_world_gen_block);
            leaving_room();
            save_room_items();
            obj_world_gen_block_player_start.x += 16;
            obj_world_gen_block_player_start.my_x += 16;
            obj_camera.transition_x_target += 480;
            global.boost_speed_multiplier_saved = global.boost_speed_multiplier_current;
            global.player_h_spd_saved = h_spd;
            global.player_v_spd_saved = v_spd;
            if (instance_exists(obj_skull))
            {
                with (obj_skull)
                {
                    x_to_change = -512;
                }
            }
        }
        else
        {
            x = room_width - 16;
        }
    }
    if (y < 16)
    {
        if (global.can_leave_room == true && (instance_number(obj_enemy_spawner) + instance_number(obj_enemy) + instance_number(obj_sausage_room_rewards) + instance_number(obj_enemy_wave_battle_spawner)) <= allowed_enemy_amount && fish_hooked == false && !instance_exists(obj_cricket_gold_use) && room_change_allowed == true)
        {
            t = instance_create_depth(0, 0, -1000, obj_transition);
            t.player_target_x = x;
            t.player_target_y = room_height - 20;
            global.room_transition = 1;
            global.previous_world_block_id = instance_nearest(obj_world_gen_block_player_start.x, obj_world_gen_block_player_start.y, obj_world_gen_block);
            leaving_room();
            save_room_items();
            obj_world_gen_block_player_start.y -= 16;
            obj_world_gen_block_player_start.my_y -= 16;
            obj_camera.transition_y_target -= 270;
            global.boost_speed_multiplier_saved = global.boost_speed_multiplier_current;
            global.player_h_spd_saved = h_spd;
            global.player_v_spd_saved = v_spd;
            if (instance_exists(obj_skull))
            {
                with (obj_skull)
                {
                    y_to_change = 302;
                }
            }
        }
        else
        {
            y = 16;
        }
    }
    if (y > (room_height - 16))
    {
        if (global.can_leave_room == true && (instance_number(obj_enemy_spawner) + instance_number(obj_enemy) + instance_number(obj_sausage_room_rewards) + instance_number(obj_enemy_wave_battle_spawner)) <= allowed_enemy_amount && fish_hooked == false && !instance_exists(obj_cricket_gold_use) && room_change_allowed == true)
        {
            t = instance_create_depth(0, 0, -1000, obj_transition);
            t.player_target_x = x;
            t.player_target_y = 20;
            global.room_transition = 1;
            global.previous_world_block_id = instance_nearest(obj_world_gen_block_player_start.x, obj_world_gen_block_player_start.y, obj_world_gen_block);
            leaving_room();
            save_room_items();
            obj_world_gen_block_player_start.y += 16;
            obj_world_gen_block_player_start.my_y += 16;
            obj_camera.transition_y_target += 270;
            global.boost_speed_multiplier_saved = global.boost_speed_multiplier_current;
            global.player_h_spd_saved = h_spd;
            global.player_v_spd_saved = v_spd;
            if (instance_exists(obj_skull))
            {
                with (obj_skull)
                {
                    y_to_change = -302;
                }
            }
        }
        else
        {
            y = room_height - 16;
        }
    }
}
