function hymy_spawn_smiley()
{
    if (global.playable_characters_selected == 5 && !global.boss_battle && global.player_hp > 1)
    {
        var time_to_pickup_smiley = 5;
        if (global.difficulty_selection == 0)
        {
            time_to_pickup_smiley = 8;
        }
        var spawn_x = random_range(64, room_width - 64);
        var spawn_y = random_range(64, room_height - 64);
        if (!place_meeting(spawn_x, spawn_y, obj_solid) && !collision_circle(spawn_x, spawn_y, 40, obj_player, 0, 0) && !place_meeting(spawn_x, spawn_y, obj_solid_environment) && !place_meeting(spawn_x, spawn_y, obj_solid_half))
        {
            global.hymy_smiley_can_spawn = false;
            global.hymy_smiley_can_spawn_timer = 0;
            global.hymy_time_left_to_pick_up_smiley = time_to_pickup_smiley * 60;
            instance_create_depth(spawn_x, spawn_y, -spawn_y, obj_smiley);
        }
    }
}
