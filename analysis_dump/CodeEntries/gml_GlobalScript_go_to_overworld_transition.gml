function go_to_overworld_transition()
{
    if (!instance_exists(obj_transition_area_start))
    {
        global.in_gameplay = false;
        global.main_menu_buttons_disabled = true;
        global.playable_characters_selected = 0;
        get_character_specific_starting_stats();
        get_weapon_variables();
        get_difficulty_modifiers();
        task_reset_all();
        task_reset_all_row();
        var transition = instance_create_depth(0, 0, -1000, obj_transition_area_start);
        transition.overworld_fade_in = true;
    }
}
