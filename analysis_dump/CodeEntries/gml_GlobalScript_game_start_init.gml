function game_start_init()
{
    global.sounds_on = true;
    global.music_on = true;
    global.volume_music_multiplier = 1;
    global.volume_music_multiplier_spd = 0.02;
    global.new_fishing = false;
    global.font_current = font_hope_gold;
    set_font();
    global.newspaper_current = 0;
    global.newspaper_unread = false;
    global.story_event_current = 0;
    global.story_event_block_run = false;
    alarm[3] = 10;
    global.run_ongoing = false;
    global.magic_run_active = false;
    global.new_bullet_style = true;
    global.intro_tutorial_spawned = false;
    global.tooltip_enabled = false;
    global.tooltip_text = "";
    global.area_transition_cutscene_active = false;
    global.area_transition_cutscene_ended = false;
    global.area_transition_animation = false;
    global.overworld_x_offset = 0;
    global.overworld_x_offset_player = 0;
    global.cutscene_played = false;
    global.cutscene_phase = 0;
    global.feature_unlocks_total = 1;
    global.default_rope_damp_ratio = 0.7;
    global.default_rope_freq = 10;
    global.default_rope_len = 9;
    create_fish_rarity_points();
    global.debug_rope_damp_ratio = global.default_rope_damp_ratio;
    global.debug_rope_freq = global.default_rope_freq;
    global.debug_rope_len = global.default_rope_len;
    global.debug_rope = false;
    global.debug_rope_setting = 0;
    for (var i = 0; i < 10; i += 1)
    {
        global.debug_rope_toss_distance[i] = 0;
    }
    global.playable_characters_total = 6;
    global.playable_characters_selected = 0;
    global.challenge_run_selected = -1;
    randomize();
    run_start_reset_variables();
    global.pre_unlocked_treasured = 80;
    global.unlocks_total[0] = 110;
    global.unlocks_total[1] = 6;
    global.unlocks_total[2] = 20;
    global.unlocks_total[3] = 0;
    global.fish_species_total = 201;
    global.fishes_caught[0][0] = 0;
    global.unlocks[0][0] = 0;
    global.unlocks[1][0] = 0;
    global.unlocks[2][0] = 0;
    global.unlocks[3][0] = 0;
    for (var i = 0; i < 4; i += 1)
    {
        for (var j = 0; j < global.unlocks_total[i]; j += 1)
        {
            global.unlocks[i][j] = 0;
        }
    }
    global.unlocks[2][0] = 3;
    global.unlocks[2][1] = 3;
    global.unlocks[2][2] = 3;
    global.unlocks[2][3] = 3;
    global.unlocks[2][4] = 3;
    global.unlocks[2][5] = 3;
    global.unlocks[2][6] = 3;
    global.unlocks[2][7] = 3;
    global.unlocks[2][8] = 3;
    global.unlocks[2][9] = 3;
    global.unlocks[2][10] = 3;
    global.unlocks[2][11] = 3;
    global.unlocks[2][12] = 3;
    global.unlocks[2][13] = 3;
    global.unlocks[2][14] = 3;
    global.unlocks[2][15] = 3;
    global.unlocks[2][16] = 3;
    global.unlocks[2][17] = 3;
    global.unlocks[2][18] = 3;
    global.unlocks[2][19] = 3;
    global.unlocks[2][20] = 3;
    global.unlocks[2][21] = 3;
    for (var i = 0; i < global.badges_total; i += 1)
    {
        for (var j = 0; j < global.playable_characters_total; j += 1)
        {
            global.badge[i][j] = 1;
        }
    }
    global.unlocks_all[0] = 2;
    global.unlocks_all_total = 28;
    global.coin_pitch_increase = 0;
    global.line_color_current_1 = 255;
    global.line_color_current_2 = 255;
    global.line_color_current_3 = 255;
    global.line_color_target_1 = 255;
    global.line_color_target_2 = 255;
    global.line_color_target_3 = 255;
    global.line_color = make_color_rgb(global.line_color_current_1, global.line_color_current_2, global.line_color_current_3);
    global.line_color_red = 2366719;
    global.line_color_white = 16777215;
    global.line_always_in_water = true;
    global.pause_menu_real = true;
    global.game_version = 0;
    global.color_yellow = 571877;
    global.color_green = 1821485;
    global.color_red = 2165729;
    global.color_pink = 8599794;
    global.color_cyan = 13149710;
    global.color_green_area1 = 1821485;
    global.color_yellow_area2 = 571877;
    global.color_blue_area3 = 13987428;
    global.color_green_dark = 1211654;
    global.color_outline = 1710618;
    global.color_outline_brown = 1844797;
    global.font_numbers = font_add_sprite(spr_font_numbers, 33, 1, 0);
    global.font_text = font_add_sprite(spr_font_numbers, 33, 1, 1);
    global.fishing_line_physics_version = 1;
    global.casting_version = 1;
    global.fishling_multi_catch_enabled = false;
    global.world_generation_version = 2;
    global.enemy_randomized_spawn = true;
    global.enemy_state_enums[0] = "attack";
    global.enemy_state_enums[1] = "attack_anticipation";
    global.enemy_state_enums[2] = "attack_dash";
    global.enemy_state_enums[3] = "attack_charge_up";
    global.enemy_state_enums[4] = "attack_shoot";
    global.enemy_state_enums[5] = "look_for_position";
    global.enemy_state_enums[6] = "cooldown";
    global.enemy_state_enums[7] = "approach_player";
    global.enemy_state_enums[8] = "dash";
    global.enemy_state_enums[9] = "follow";
    global.enemy_state_enums[10] = "hide";
    global.enemy_state_enums[11] = "patrol";
    global.enemy_state_enums[12] = "idle";
    global.enemy_state_enums[13] = "look_for_player";
    global.enemy_state_enums[14] = "move";
    global.enemy_state_enums[15] = "death";
    global.enemy_state_enums[16] = "hidden";
    global.enemy_state_enums[17] = "seek_underwater";
    global.enemy_state_enums[18] = "alerted";
    for (var i = 0; i < 30; i += 1)
    {
        global.enemy_uses_states[i] = false;
    }
    global.tutorial_current = 0;
    global.magic_run_cost_ongoing = 10;
    global.challenge_run_cost_ongoing = 10;
    instance_create_depth(0, 0, 300, obj_draw_water_elements);
    instance_create_depth(0, 0, -900, obj_draw_front_hud);
    instance_create_depth(0, 0, -996, obj_draw_behind_hud);
    data_load();
    fix_unlocks();
    window_set_fullscreen(global.fullscreen);
    set_resolution();
    alarm[0] = 10;
    alarm[1] = 60;
    data_load_bindings();
    if (!audio_group_is_loaded(bgm_ambient_intestines))
    {
        audio_group_load(bgm_ambient_intestines);
    }
    update_music_volume();
    play_music_init();
    update_unlocks();
}
