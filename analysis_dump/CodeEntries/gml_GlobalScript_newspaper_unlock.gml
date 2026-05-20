function newspaper_unlock()
{
    var hard_mode_wins = get_hard_mode_wins();
    if (hard_mode_wins >= 1)
    {
        newspaper_enable(6);
    }
    if (global.unlocks_all[7] >= 1 || global.unlocks_all[9] >= 1 || global.unlocks_all[10] >= 1)
    {
        newspaper_enable(9);
    }
    var times_cleared_1st_area = 0;
    for (var ii = 0; ii < 4; ii += 1)
    {
        times_cleared_1st_area += global.lake_finished_amount_char_easy[0][ii];
    }
    if (times_cleared_1st_area >= 5)
    {
        newspaper_enable(10);
    }
    if (get_progress_fishes() >= 100)
    {
        newspaper_enable(11);
    }
    if (get_progress_badges() > 0 && global.unlocks_all[6] >= 1)
    {
        newspaper_enable(12);
    }
    if (get_progress_fishes() >= 25)
    {
        newspaper_enable(13);
    }
}
