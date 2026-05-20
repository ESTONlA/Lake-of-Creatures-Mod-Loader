function go_to_overworld()
{
    global.playable_characters_selected = 0;
    global.main_menu_buttons_disabled = true;
    get_character_specific_starting_stats();
    get_weapon_variables();
    var player_spawn_x = 180;
    var player_spawn_y = 151;
    instance_create_depth(player_spawn_x, player_spawn_y, 0, obj_world_gen_block_player_start);
    start_block = spawn_overworld_rooms_2(player_spawn_x, player_spawn_y);
    global.current_world_block_id = start_block;
    instance_create_depth(room_width / 2, player_spawn_y, 0, obj_player);
    room_goto(start_block.room_index);
    global.current_darkness = 0;
}
