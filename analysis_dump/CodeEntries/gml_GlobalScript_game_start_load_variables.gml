function game_start_load_variables()
{
    global.fullscreen = true;
    global.resolution_current_width = 1920;
    global.resolution_current_height = 1080;
    global.pause_menu_bg_xscale = 0.25;
    global.pause_menu_bg_yscale = 0.25;
    global.screen_res_width = display_get_width();
    global.screen_res_height = display_get_height();
    global.resolution_option = 2;
    global.resolution_option_current = 2;
    global.resolution_option_width = 1920;
    global.resolution_option_height = 1080;
    global.screenshake_enabled = true;
    global.mouselock_enabled = true;
    global.freezeframe_enabled = true;
    global.particles_enabled = true;
    global.volume_master = 100;
    global.volume_music = 100;
    global.volume_sound = 100;
    global.volume_music_final = 1;
    global.volume_sound_final = 1;
    update_volume();
    global.speed_boost_auto = false;
    global.gamepad_enabled = false;
    global.difficulty_selection = 0;
    global.magic_run_cost = 5;
    global.challenge_run_cost = 5;
    global.current_tutorial_arrow = 0;
    for (var i = 0; i < 10; i += 1)
    {
        global.tutorial_success[i] = 0;
    }
    for (var i = 0; i < 60; i += 1)
    {
        global.newspaper_state[i] = 0;
    }
    global.story_event_current = 0;
    global.story_event_block_run = false;
    global.fish_caught_tutorial_all_time = 0;
    global.visited_tentacle_without_g_crickets = 0;
    global.start_tutorial_completion = 0;
    for (var i = 0; i < 20; i += 1)
    {
        global.challenge_completed[i] = 0;
    }
    for (var i = 0; i < 4; i += 1)
    {
        global.task[i][0] = -1;
        global.task[i][1] = 0;
        global.task[i][2] = 0;
        global.task[i][3] = 0;
    }
    global.task_target_multiplier = 0;
    global.tasks_completed = 0;
    global.tasks_left = 3;
    task_init_all();
    for (var i = 0; i < 100; i += 1)
    {
        global.button_unlock[i] = 2;
    }
    for (var i = 0; i < 203; i += 1)
    {
        global.fish_that_have_been_caught[i] = 0;
    }
    global.button_unlock[19] = 0;
    global.button_unlock[53] = 0;
    global.intro_skipped_times = 0;
    global.lake_finished_amount[0] = 0;
    global.lake_finished_amount[1] = 0;
    global.lake_finished_amount[2] = 0;
    global.lake_finished_amount[3] = 0;
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        global.lake_finished_amount_char_easy[0][i] = 0;
        global.lake_finished_amount_char_easy[1][i] = 0;
        global.lake_finished_amount_char_easy[2][i] = 0;
        global.lake_finished_amount_char_easy[3][i] = 0;
        global.lake_finished_amount_char_easy[4][i] = 0;
        global.lake_finished_amount_char_hard[0][i] = 0;
        global.lake_finished_amount_char_hard[1][i] = 0;
        global.lake_finished_amount_char_hard[2][i] = 0;
        global.lake_finished_amount_char_hard[3][i] = 0;
        global.lake_finished_amount_char_hard[4][i] = 0;
        global.all_fish_caught_lake_easy[0][i] = 0;
        global.all_fish_caught_lake_easy[1][i] = 0;
        global.all_fish_caught_lake_easy[2][i] = 0;
        global.all_fish_caught_lake_easy[3][i] = 0;
        global.all_fish_caught_lake_easy[4][i] = 0;
        global.all_fish_caught_lake_hard[0][i] = 0;
        global.all_fish_caught_lake_hard[1][i] = 0;
        global.all_fish_caught_lake_hard[2][i] = 0;
        global.all_fish_caught_lake_hard[3][i] = 0;
        global.all_fish_caught_lake_hard[4][i] = 0;
    }
    global.killed_enemies_total = 0;
    global.killed_enemies_explosions_total = 0;
    global.killed_bosses_total = 0;
    global.collected_crickets_total = 0;
    global.collected_ammo_crates_total = 0;
    global.collected_treasures_total = 0;
    global.collected_evil_clam_treasures_total = 0;
    global.collected_hp_total = 0;
    global.damage_taken_amount = 0;
    global.damage_taken_explosion_total = 0;
    global.caught_fish_total = 0;
    global.restock_stone_uses_total = 0;
    global.damage_taken_spikes_total = 0;
    global.secondary_ammo_shot_total = 0;
    global.fishing_line_hits_total = 0;
    global.melee_attack_hits_total = 0;
    global.bought_treasures_total = 0;
    global.perfect_casts_total = 0;
    global.bottles_collected_total = 0;
    global.bottles_spent_total = 0;
    global.area4_visited = false;
    global.deaths_total = 0;
}
