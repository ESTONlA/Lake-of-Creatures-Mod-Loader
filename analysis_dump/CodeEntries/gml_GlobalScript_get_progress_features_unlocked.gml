function get_progress_features_unlocked()
{
    var progress = 0;
    for (var i = 1; i < global.unlocks_all_total; i += 1)
    {
        if (i != 2 && i != 4 && i != 5)
        {
            if (i != 9 && i != 15 && i != 16)
            {
                if (global.unlocks_all[i] >= 1)
                {
                    progress += 1;
                }
            }
        }
    }
    return progress;
}
