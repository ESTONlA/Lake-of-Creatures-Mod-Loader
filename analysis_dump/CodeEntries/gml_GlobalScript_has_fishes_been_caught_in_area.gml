function has_fishes_been_caught_in_area()
{
    var lake_type = get_lake_type(global.current_lake);
    var total_fish = 0;
    if (lake_has_boss(global.current_lake))
    {
        switch (lake_type)
        {
            case 1:
                total_fish = global.lake_array[1].fishes_total_this_lake + global.lake_array[2].fishes_total_this_lake;
                show_debug_message("total fish: " + string(total_fish));
                if (global.total_fish_caught_this_area == total_fish)
                {
                    if (global.difficulty_selection == 0)
                    {
                        show_debug_message(".....................1, easy");
                        global.all_fish_caught_lake_easy[0][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.difficulty_selection == 1)
                    {
                        show_debug_message(".....................1, hard");
                        global.all_fish_caught_lake_hard[0][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.item_fishing_rewarded == true)
                    {
                        global.item_fishing_rewarded_active = true;
                    }
                }
                break;
            case 2:
                total_fish = global.lake_array[3].fishes_total_this_lake + global.lake_array[4].fishes_total_this_lake;
                if (global.total_fish_caught_this_area == total_fish)
                {
                    if (global.difficulty_selection == 0)
                    {
                        show_debug_message(".....................2, easy");
                        global.all_fish_caught_lake_easy[1][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.difficulty_selection == 1)
                    {
                        show_debug_message(".....................2, hard");
                        global.all_fish_caught_lake_hard[1][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.item_fishing_rewarded == true)
                    {
                        global.item_fishing_rewarded_active = true;
                    }
                }
                break;
            case 3:
                total_fish = global.lake_array[5].fishes_total_this_lake + global.lake_array[6].fishes_total_this_lake;
                if (global.total_fish_caught_this_area == total_fish)
                {
                    if (global.difficulty_selection == 0)
                    {
                        show_debug_message(".....................3, easy");
                        global.all_fish_caught_lake_easy[2][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.difficulty_selection == 1)
                    {
                        show_debug_message(".....................3, hard");
                        global.all_fish_caught_lake_hard[2][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.item_fishing_rewarded == true)
                    {
                        global.item_fishing_rewarded_active = true;
                    }
                }
                break;
            case 4:
                total_fish = global.lake_array[7].fishes_total_this_lake + global.lake_array[8].fishes_total_this_lake;
                if (global.total_fish_caught_this_area == total_fish)
                {
                    if (global.difficulty_selection == 0)
                    {
                        show_debug_message(".....................4, easy");
                        global.all_fish_caught_lake_easy[3][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.difficulty_selection == 1)
                    {
                        show_debug_message(".....................4, hard");
                        global.all_fish_caught_lake_hard[3][global.playable_characters_selected] += badge_progress_add(1);
                    }
                    if (global.item_fishing_rewarded == true)
                    {
                        global.item_fishing_rewarded_active = true;
                    }
                }
                break;
        }
    }
    global.total_fish_caught_this_area = 0;
}
