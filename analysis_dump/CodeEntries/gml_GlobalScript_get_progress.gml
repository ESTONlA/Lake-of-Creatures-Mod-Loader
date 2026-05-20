function get_progress()
{
    var progress_current = 0;
    var progress_max = 0;
    var treasure_find_worth = 1;
    var unlock_worth = 5;
    var feature_unlock_worth = 25;
    var fish_find_worth = 1;
    var badge_worth = 15;
    var progress = 0;
    var fishes_caught = 0;
    for (var i = 0; i < global.fish_species_total; i += 1)
    {
        if (global.fish_that_have_been_caught[i] > 0)
        {
            progress_current += (1 * fish_find_worth);
            fishes_caught += 1;
        }
        progress_max += (1 * fish_find_worth);
    }
    var treasures_unlocked = 0;
    var treasures_found = 0;
    for (var i = 0; i < global.unlocks_total[0]; i += 1)
    {
        if (global.unlocks[0][i] == 1 || global.unlocks[0][i] == 2)
        {
            progress_current += (1 * unlock_worth);
            treasures_unlocked += 1;
        }
        if (global.unlocks[0][i] == 3)
        {
            progress_current += (1 + (1 * treasure_find_worth));
            progress_current += (1 * unlock_worth);
            treasures_unlocked += 1;
            treasures_found += 1;
        }
        progress_max += (1 + (1 * unlock_worth));
        progress_max += (1 + (1 * treasure_find_worth));
    }
    for (var i = 1; i < global.unlocks_all_total; i += 1)
    {
        if (global.unlocks_all[i] != 0)
        {
            progress_current += (1 + (1 * feature_unlock_worth));
        }
        progress_max += (1 + (1 * feature_unlock_worth));
    }
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        for (var ii = 0; ii < 9; ii += 1)
        {
            if (is_badge_unlocked(ii, i) == true)
            {
                progress_current += (1 + (1 * badge_worth));
            }
            progress_max += (1 + (1 * badge_worth));
        }
    }
    progress_current -= (global.pre_unlocked_treasured * unlock_worth);
    progress_max -= (global.pre_unlocked_treasured * unlock_worth);
    progress = round((progress_current / progress_max) * 100);
    get_progress_achievements(progress);
    get_unlock_achievements(treasures_unlocked - global.pre_unlocked_treasured, treasures_found);
    get_fish_achievements(fishes_caught);
    return progress;
}
