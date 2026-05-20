function cutscene_started()
{
    if (instance_exists(obj_overworld_land_bg))
    {
        obj_overworld_land_bg.alarm[0] = -1;
        obj_overworld_land_bg.alarm[2] = -1;
        obj_overworld_land_bg.show_tip = false;
        obj_overworld_land_bg.can_show_tip = false;
        obj_overworld_land_bg.tip_alpha = 0;
        obj_overworld_land_bg.fadeout = false;
        obj_overworld_land_bg.tip_number = floor(random_range(1, obj_overworld_land_bg.tips_total + 1));
        obj_overworld_land_bg.lake_cleared_anim_length = 0;
        obj_overworld_land_bg.alarm[1] = 5;
    }
    var target_x = cutscene_get_target_position(global.cutscene_current_lake);
    if (global.area_transition_cutscene_ended == false)
    {
        global.overworld_x_offset_player = target_x;
        global.overworld_x_offset = target_x * -1;
    }
    global.cutscene_current_lake += 1;
    global.area_transition_animation_end_timer = 0;
}
