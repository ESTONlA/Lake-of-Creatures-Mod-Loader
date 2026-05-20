function data_save()
{
    if (file_exists("loc_save.sav"))
    {
        file_delete("loc_save.sav");
    }
    ini_open("loc_save.sav");
    var save_file = "save_1";
    ini_write_real(save_file, "fullscreen", global.fullscreen);
    ini_write_real(save_file, "resolution_current_width", global.resolution_current_width);
    ini_write_real(save_file, "resolution_current_height", global.resolution_current_height);
    ini_write_real(save_file, "pause_menu_bg_xscale", global.pause_menu_bg_xscale);
    ini_write_real(save_file, "pause_menu_bg_yscale", global.pause_menu_bg_yscale);
    ini_write_real(save_file, "screen_res_width", global.screen_res_width);
    ini_write_real(save_file, "screen_res_height", global.screen_res_height);
    ini_write_real(save_file, "resolution_option", global.resolution_option);
    ini_write_real(save_file, "resolution_option_current", global.resolution_option_current);
    ini_write_real(save_file, "resolution_option_width", global.resolution_option_width);
    ini_write_real(save_file, "resolution_option_height", global.resolution_option_height);
    ini_write_real(save_file, "screenshake_enabled", global.screenshake_enabled);
    ini_write_real(save_file, "mouselock_enabled", global.mouselock_enabled);
    ini_write_real(save_file, "freezeframe_enabled", global.freezeframe_enabled);
    ini_write_real(save_file, "particles_enabled", global.particles_enabled);
    ini_write_real(save_file, "volume_master", global.volume_master);
    ini_write_real(save_file, "volume_music", global.volume_music);
    ini_write_real(save_file, "volume_sound", global.volume_sound);
    ini_write_real(save_file, "volume_music_final", global.volume_music_final);
    ini_write_real(save_file, "volume_sound_final", global.volume_sound_final);
    ini_write_real(save_file, "speedboostauto", global.speed_boost_auto);
    update_volume();
    ini_write_real(save_file, "gamepad_enabled", global.gamepad_enabled);
    ini_write_real(save_file, "locale", global.locale);
    ini_write_real(save_file, "difficulty", global.difficulty_selection);
    ini_write_real(save_file, "lake_finished_amount_0", global.lake_finished_amount[0]);
    ini_write_real(save_file, "lake_finished_amount_1", global.lake_finished_amount[1]);
    ini_write_real(save_file, "lake_finished_amount_2", global.lake_finished_amount[2]);
    ini_write_real(save_file, "lake_finished_amount_3", global.lake_finished_amount[3]);
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        ini_write_real(save_file, "lake_finished_amount_char_easy_0_" + string(i), global.lake_finished_amount_char_easy[0][i]);
        ini_write_real(save_file, "lake_finished_amount_char_easy_1_" + string(i), global.lake_finished_amount_char_easy[1][i]);
        ini_write_real(save_file, "lake_finished_amount_char_easy_2_" + string(i), global.lake_finished_amount_char_easy[2][i]);
        ini_write_real(save_file, "lake_finished_amount_char_easy_3_" + string(i), global.lake_finished_amount_char_easy[3][i]);
        ini_write_real(save_file, "lake_finished_amount_char_easy_4_" + string(i), global.lake_finished_amount_char_easy[4][i]);
        ini_write_real(save_file, "lake_finished_amount_char_hard_0_" + string(i), global.lake_finished_amount_char_hard[0][i]);
        ini_write_real(save_file, "lake_finished_amount_char_hard_1_" + string(i), global.lake_finished_amount_char_hard[1][i]);
        ini_write_real(save_file, "lake_finished_amount_char_hard_2_" + string(i), global.lake_finished_amount_char_hard[2][i]);
        ini_write_real(save_file, "lake_finished_amount_char_hard_3_" + string(i), global.lake_finished_amount_char_hard[3][i]);
        ini_write_real(save_file, "lake_finished_amount_char_hard_4_" + string(i), global.lake_finished_amount_char_hard[4][i]);
        ini_write_real(save_file, "all_fish_caught_lake_easy_0_" + string(i), global.all_fish_caught_lake_easy[0][i]);
        ini_write_real(save_file, "all_fish_caught_lake_easy_1_" + string(i), global.all_fish_caught_lake_easy[1][i]);
        ini_write_real(save_file, "all_fish_caught_lake_easy_2_" + string(i), global.all_fish_caught_lake_easy[2][i]);
        ini_write_real(save_file, "all_fish_caught_lake_easy_3_" + string(i), global.all_fish_caught_lake_easy[3][i]);
        ini_write_real(save_file, "all_fish_caught_lake_easy_4_" + string(i), global.all_fish_caught_lake_easy[4][i]);
        ini_write_real(save_file, "all_fish_caught_lake_hard_0_" + string(i), global.all_fish_caught_lake_hard[0][i]);
        ini_write_real(save_file, "all_fish_caught_lake_hard_1_" + string(i), global.all_fish_caught_lake_hard[1][i]);
        ini_write_real(save_file, "all_fish_caught_lake_hard_2_" + string(i), global.all_fish_caught_lake_hard[2][i]);
        ini_write_real(save_file, "all_fish_caught_lake_hard_3_" + string(i), global.all_fish_caught_lake_hard[3][i]);
        ini_write_real(save_file, "all_fish_caught_lake_hard_4_" + string(i), global.all_fish_caught_lake_hard[4][i]);
    }
    ini_write_real(save_file, "killed_enemies_total", global.killed_enemies_total);
    ini_write_real(save_file, "killed_enemies_explosions_total", global.killed_enemies_explosions_total);
    ini_write_real(save_file, "killed_bosses_total", global.killed_bosses_total);
    ini_write_real(save_file, "collected_crickets_total", global.collected_crickets_total);
    ini_write_real(save_file, "collected_ammo_crates_total", global.collected_ammo_crates_total);
    ini_write_real(save_file, "collected_treasures_total", global.collected_treasures_total);
    ini_write_real(save_file, "collected_evil_clam_treasures_total", global.collected_evil_clam_treasures_total);
    ini_write_real(save_file, "collected_hp_total", global.collected_hp_total);
    ini_write_real(save_file, "damage_taken_amount", global.damage_taken_amount);
    ini_write_real(save_file, "damage_taken_explosion_total", global.damage_taken_explosion_total);
    ini_write_real(save_file, "caught_fish_total", global.caught_fish_total);
    ini_write_real(save_file, "restock_stone_uses_total", global.restock_stone_uses_total);
    ini_write_real(save_file, "damage_taken_spikes_total", global.damage_taken_spikes_total);
    ini_write_real(save_file, "secondary_ammo_shot_total", global.secondary_ammo_shot_total);
    ini_write_real(save_file, "fishing_line_hits_total", global.fishing_line_hits_total);
    ini_write_real(save_file, "melee_attack_hits_total", global.melee_attack_hits_total);
    ini_write_real(save_file, "bought_treasures_total", global.bought_treasures_total);
    ini_write_real(save_file, "intro_skipped_times", global.intro_skipped_times);
    ini_write_real(save_file, "task_target_multiplier", global.task_target_multiplier);
    ini_write_real(save_file, "tasks_completed", global.tasks_completed);
    ini_write_real(save_file, "tasks_left", global.tasks_left);
    ini_write_real(save_file, "magic_run_cost", global.magic_run_cost);
    ini_write_real(save_file, "challenge_run_cost", global.challenge_run_cost);
    ini_write_real(save_file, "current_tutorial_arrow", global.current_tutorial_arrow);
    ini_write_real(save_file, "perfect_casts_total", global.perfect_casts_total);
    ini_write_real(save_file, "bottles_collected_total", global.bottles_collected_total);
    ini_write_real(save_file, "bottles_spent_total", global.bottles_spent_total);
    ini_write_real(save_file, "area4_visited", global.area4_visited);
    ini_write_real(save_file, "deaths_total", global.deaths_total);
    ini_write_real(save_file, "fish_caught_tutorial_all_time", global.fish_caught_tutorial_all_time);
    ini_write_real(save_file, "visited_tentacle_without_g_crickets", global.visited_tentacle_without_g_crickets);
    ini_write_real(save_file, "start_tutorial_completion", global.start_tutorial_completion);
    for (var i = 0; i < 10; i += 1)
    {
        var unlock_name = "tutorial_completed_" + string(i);
        ini_write_real(save_file, unlock_name, global.tutorial_success[i]);
    }
    for (var i = 0; i < 60; i += 1)
    {
        var unlock_name = "newspaper_" + string(i);
        ini_write_real(save_file, unlock_name, global.newspaper_state[i]);
    }
    ini_write_real(save_file, "story_event_current", global.story_event_current);
    ini_write_real(save_file, "story_event_block_run", global.story_event_block_run);
    for (var i = 0; i < 20; i += 1)
    {
        ini_write_real(save_file, "challenge_completed_" + string(i), global.challenge_completed[i]);
    }
    for (var i = 0; i < 4; i += 1)
    {
        ini_write_real(save_file, "task_" + string(i) + "_type", global.task[i][0]);
        ini_write_real(save_file, "task_" + string(i) + "_progress", global.task[i][1]);
        ini_write_real(save_file, "task_" + string(i) + "_progress_previous", global.task[i][2]);
        ini_write_real(save_file, "task_" + string(i) + "_progress_target", global.task[i][3]);
    }
    for (var i = 0; i < 100; i += 1)
    {
        ini_write_real(save_file, "button_" + string(i), global.button_unlock[i]);
    }
    for (var i = 0; i < global.fish_species_total; i += 1)
    {
        var fish_name = "fish_total_" + string(i);
        ini_write_real(save_file, fish_name, global.fishes_caught[i][0]);
        fish_name = "fish_biggest_" + string(i);
        ini_write_real(save_file, fish_name, global.fishes_caught[i][1]);
    }
    for (var i = 0; i < 203; i += 1)
    {
        var fish_name = "fish_caught_" + string(i);
        ini_write_real(save_file, fish_name, global.fish_that_have_been_caught[i]);
    }
    for (var i = 0; i < global.unlocks_total[0]; i += 1)
    {
        var unlock_name = "unlock_treasure_" + string(i);
        ini_write_real(save_file, unlock_name, global.unlocks[0][i]);
    }
    for (var i = 0; i < global.unlocks_all_total; i += 1)
    {
        var unlock_name = "unlock_" + string(i);
        ini_write_real(save_file, unlock_name, global.unlocks_all[i]);
    }
    ini_write_real(save_file, "bottles", global.bottles);
    ini_close();
}
