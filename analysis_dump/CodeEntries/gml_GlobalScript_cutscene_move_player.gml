function cutscene_move_player()
{
    var player_x = cutscene_get_target_position(global.cutscene_current_lake);
    if (global.overworld_x_offset_player >= (player_x - 16) || global.area_transition_animation_end_timer > 0)
    {
        global.area_transition_animation_end_timer += 1;
        overworld_x_offset_spd += approach(overworld_x_offset_player_spd, 0, 0.04);
        overworld_x_offset_player_spd += approach(overworld_x_offset_player_spd, 0, 0.04);
        global.overworld_x_offset_player += approach(global.overworld_x_offset_player, player_x, 0.04);
    }
}
