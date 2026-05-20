function get_progress_characters_unlocked()
{
    var progress = 0;
    for (var i = 1; i < global.unlocks_all_total; i += 1)
    {
        if (i == 2 || i == 4 || i == 5 || i == 26 || i == 27)
        {
            if (global.unlocks_all[i] >= 1)
            {
                progress += 1;
            }
        }
    }
    return progress;
}
