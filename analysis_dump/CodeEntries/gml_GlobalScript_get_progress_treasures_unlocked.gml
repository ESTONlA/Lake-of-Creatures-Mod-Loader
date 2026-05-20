function get_progress_treasures_unlocked()
{
    var progress = 0;
    for (var i = 0; i < global.unlocks_total[0]; i += 1)
    {
        if (global.unlocks[0][i] >= 1)
        {
            progress += 1;
        }
    }
    if (progress >= global.unlocks_total[0])
    {
        achievement_get("UNLOCK_ALL_ITEMS");
    }
    return progress;
}
