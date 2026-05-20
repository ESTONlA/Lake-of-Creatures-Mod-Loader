function data_load()
{
    if (file_exists("loc_save.sav"))
    {
        ini_open("loc_save.sav");
        var screen_res_width_default = display_get_width();
        var screen_res_height_default = display_get_height();
        var save_file = "save_1";
        global.fullscreen = ini_read_real(save_file, "fullscreen", 1);
        global.resolution_current_width = ini_read_real(save_file, "resolution_current_width", 1920);
        global.resolution_current_height = ini_read_real(save_file, "resolution_current_height", 1080);
        global.pause_menu_bg_xscale = ini_read_real(save_file, "pause_menu_bg_xscale", 0.25);
        global.pause_menu_bg_yscale = ini_read_real(save_file, "pause_menu_bg_yscale", 0.25);
        global.screen_res_width = ini_read_real(save_file, "screen_res_width", screen_res_width_default);
        global.screen_res_height = ini_read_real(save_file, "screen_res_height", screen_res_height_default);
        global.resolution_option = ini_read_real(save_file, "resolution_option", 2);
        global.resolution_option_current = ini_read_real(save_file, "resolution_option_current", 2);
        global.resolution_option_width = ini_read_real(save_file, "resolution_option_width", 1920);
        global.resolution_option_height = ini_read_real(save_file, "resolution_option_height", 1080);
        global.screenshake_enabled = ini_read_real(save_file, "screenshake_enabled", 1);
        global.mouselock_enabled = ini_read_real(save_file, "mouselock_enabled", 1);
        global.freezeframe_enabled = ini_read_real(save_file, "freezeframe_enabled", 1);
        global.particles_enabled = ini_read_real(save_file, "particles_enabled", 1);
        global.volume_master = ini_read_real(save_file, "volume_master", 100);
        global.volume_music = ini_read_real(save_file, "volume_music", 100);
        global.volume_sound = ini_read_real(save_file, "volume_sound", 100);
        global.volume_music_final = ini_read_real(save_file, "volume_music_final", 1);
        global.volume_sound_final = ini_read_real(save_file, "volume_sound_final", 1);
        update_volume();
        global.gamepad_enabled = ini_read_real(save_file, "gamepad_enabled", 0);
        global.locale = ini_read_real(save_file, "locale", UnknownEnum.Value_0);
        global.difficulty_selection = ini_read_real(save_file, "difficulty", 0);
        global.speed_boost_auto = ini_read_real(save_file, "speedboostauto", 0);
        global.lake_finished_amount[0] = ini_read_real(save_file, "lake_finished_amount_0", 0);
        global.lake_finished_amount[1] = ini_read_real(save_file, "lake_finished_amount_1", 0);
        global.lake_finished_amount[2] = ini_read_real(save_file, "lake_finished_amount_2", 0);
        global.lake_finished_amount[3] = ini_read_real(save_file, "lake_finished_amount_3", 0);
        for (var i = 0; i < global.playable_characters_total; i += 1)
        {
            global.lake_finished_amount_char_easy[0][i] = ini_read_real(save_file, "lake_finished_amount_char_easy_0_" + string(i), 0);
            global.lake_finished_amount_char_easy[1][i] = ini_read_real(save_file, "lake_finished_amount_char_easy_1_" + string(i), 0);
            global.lake_finished_amount_char_easy[2][i] = ini_read_real(save_file, "lake_finished_amount_char_easy_2_" + string(i), 0);
            global.lake_finished_amount_char_easy[3][i] = ini_read_real(save_file, "lake_finished_amount_char_easy_3_" + string(i), 0);
            global.lake_finished_amount_char_easy[4][i] = ini_read_real(save_file, "lake_finished_amount_char_easy_4_" + string(i), 0);
            global.lake_finished_amount_char_hard[0][i] = ini_read_real(save_file, "lake_finished_amount_char_hard_0_" + string(i), 0);
            global.lake_finished_amount_char_hard[1][i] = ini_read_real(save_file, "lake_finished_amount_char_hard_1_" + string(i), 0);
            global.lake_finished_amount_char_hard[2][i] = ini_read_real(save_file, "lake_finished_amount_char_hard_2_" + string(i), 0);
            global.lake_finished_amount_char_hard[3][i] = ini_read_real(save_file, "lake_finished_amount_char_hard_3_" + string(i), 0);
            global.lake_finished_amount_char_hard[4][i] = ini_read_real(save_file, "lake_finished_amount_char_hard_4_" + string(i), 0);
            global.all_fish_caught_lake_easy[0][i] = ini_read_real(save_file, "all_fish_caught_lake_easy_0_" + string(i), 0);
            global.all_fish_caught_lake_easy[1][i] = ini_read_real(save_file, "all_fish_caught_lake_easy_1_" + string(i), 0);
            global.all_fish_caught_lake_easy[2][i] = ini_read_real(save_file, "all_fish_caught_lake_easy_2_" + string(i), 0);
            global.all_fish_caught_lake_easy[3][i] = ini_read_real(save_file, "all_fish_caught_lake_easy_3_" + string(i), 0);
            global.all_fish_caught_lake_easy[4][i] = ini_read_real(save_file, "all_fish_caught_lake_easy_4_" + string(i), 0);
            global.all_fish_caught_lake_hard[0][i] = ini_read_real(save_file, "all_fish_caught_lake_hard_0_" + string(i), 0);
            global.all_fish_caught_lake_hard[1][i] = ini_read_real(save_file, "all_fish_caught_lake_hard_1_" + string(i), 0);
            global.all_fish_caught_lake_hard[2][i] = ini_read_real(save_file, "all_fish_caught_lake_hard_2_" + string(i), 0);
            global.all_fish_caught_lake_hard[3][i] = ini_read_real(save_file, "all_fish_caught_lake_hard_3_" + string(i), 0);
            global.all_fish_caught_lake_hard[4][i] = ini_read_real(save_file, "all_fish_caught_lake_hard_4_" + string(i), 0);
        }
        global.killed_enemies_total = ini_read_real(save_file, "killed_enemies_total", 0);
        global.killed_enemies_explosions_total = ini_read_real(save_file, "killed_enemies_explosions_total", 0);
        global.killed_bosses_total = ini_read_real(save_file, "killed_bosses_total", 0);
        global.collected_crickets_total = ini_read_real(save_file, "collected_crickets_total", 0);
        global.collected_ammo_crates_total = ini_read_real(save_file, "collected_ammo_crates_total", 0);
        global.collected_treasures_total = ini_read_real(save_file, "collected_treasures_total", 0);
        global.collected_evil_clam_treasures_total = ini_read_real(save_file, "collected_evil_clam_treasures_total", 0);
        global.collected_hp_total = ini_read_real(save_file, "collected_hp_total", 0);
        global.damage_taken_amount = ini_read_real(save_file, "damage_taken_amount", 0);
        global.damage_taken_explosion_total = ini_read_real(save_file, "damage_taken_explosion_total", 0);
        global.caught_fish_total = ini_read_real(save_file, "caught_fish_total", 0);
        global.restock_stone_uses_total = ini_read_real(save_file, "restock_stone_uses_total", 0);
        global.damage_taken_spikes_total = ini_read_real(save_file, "damage_taken_spikes_total", 0);
        global.secondary_ammo_shot_total = ini_read_real(save_file, "secondary_ammo_shot_total", 0);
        global.fishing_line_hits_total = ini_read_real(save_file, "fishing_line_hits_total", 0);
        global.bought_treasures_total = ini_read_real(save_file, "bought_treasures_total", 0);
        global.melee_attack_hits_total = ini_read_real(save_file, "melee_attack_hits_total", 0);
        global.intro_skipped_times = ini_read_real(save_file, "intro_skipped_times", 0);
        global.task_target_multiplier = ini_read_real(save_file, "task_target_multiplier", 0);
        global.tasks_completed = ini_read_real(save_file, "tasks_completed", 0);
        global.tasks_left = ini_read_real(save_file, "tasks_left", 3);
        global.magic_run_cost = ini_read_real(save_file, "magic_run_cost", 10);
        global.challenge_run_cost = ini_read_real(save_file, "challenge_run_cost", 10);
        global.current_tutorial_arrow = ini_read_real(save_file, "current_tutorial_arrow", 0);
        global.perfect_casts_total = ini_read_real(save_file, "perfect_casts_total", 0);
        global.bottles_collected_total = ini_read_real(save_file, "bottles_collected_total", 0);
        global.bottles_spent_total = ini_read_real(save_file, "bottles_spent_total", 0);
        global.area4_visited = ini_read_real(save_file, "area4_visited", false);
        global.deaths_total = ini_read_real(save_file, "deaths_total", false);
        global.fish_caught_tutorial_all_time = ini_read_real(save_file, "fish_caught_tutorial_all_time", 0);
        global.visited_tentacle_without_g_crickets = ini_read_real(save_file, "visited_tentacle_without_g_crickets", 0);
        global.start_tutorial_completion = ini_read_real(save_file, "start_tutorial_completion", 0);
        for (var i = 0; i < 10; i += 1)
        {
            var unlock_name = "tutorial_completed_" + string(i);
            global.tutorial_success[i] = ini_read_real(save_file, unlock_name, 0);
        }
        for (var i = 0; i < 60; i += 1)
        {
            var unlock_name = "newspaper_" + string(i);
            global.newspaper_state[i] = ini_read_real(save_file, unlock_name, 0);
        }
        global.story_event_current = ini_read_real(save_file, "story_event_current", 0);
        global.story_event_block_run = ini_read_real(save_file, "story_event_block_run", false);
        for (var i = 0; i < 20; i += 1)
        {
            global.challenge_completed[i] = ini_read_real(save_file, "challenge_completed_" + string(i), 0);
        }
        for (var i = 0; i < 4; i += 1)
        {
            global.task[i][0] = ini_read_real(save_file, "task_" + string(i) + "_type", -1);
            global.task[i][1] = ini_read_real(save_file, "task_" + string(i) + "_progress", 0);
            global.task[i][2] = ini_read_real(save_file, "task_" + string(i) + "_progress_previous", 0);
            global.task[i][3] = ini_read_real(save_file, "task_" + string(i) + "_progress_target", 0);
        }
        for (var i = 0; i < 100; i += 1)
        {
            var default_button_value = 2;
            if (i == 19 || i == 53)
            {
                default_button_value = 0;
            }
            global.button_unlock[i] = ini_read_real(save_file, "button_" + string(i), default_button_value);
        }
        for (var i = 0; i < global.fish_species_total; i += 1)
        {
            var fish_name = "fish_total_" + string(i);
            global.fishes_caught[i][0] = ini_read_real(save_file, fish_name, 0);
            fish_name = "fish_biggest_" + string(i);
            global.fishes_caught[i][1] = ini_read_real(save_file, fish_name, 0);
        }
        for (var i = 0; i < 203; i += 1)
        {
            var fish_name = "fish_caught_" + string(i);
            global.fish_that_have_been_caught[i] = ini_read_real(save_file, fish_name, 0);
        }
        for (var i = 0; i < global.unlocks_total[0]; i += 1)
        {
            var unlock_name = "unlock_treasure_" + string(i);
            global.unlocks[0][i] = ini_read_real(save_file, unlock_name, 0);
        }
        for (var i = 0; i < global.unlocks_all_total; i += 1)
        {
            var unlock_name = "unlock_" + string(i);
            global.unlocks_all[i] = ini_read_real(save_file, unlock_name, 0);
        }
        global.bottles = ini_read_real(save_file, "bottles", 0);
        ini_close();
        set_font();
    }
    else
    {
        game_start_load_variables();
        get_default_unlocks();
        switch (os_get_language())
        {
            case "pl":
                global.locale = UnknownEnum.Value_2;
                break;
            case "cs":
                global.locale = UnknownEnum.Value_3;
                break;
            case "zh":
                global.locale = UnknownEnum.Value_1;
                break;
            default:
                global.locale = UnknownEnum.Value_0;
                break;
        }
        set_font();
    }
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3
}
