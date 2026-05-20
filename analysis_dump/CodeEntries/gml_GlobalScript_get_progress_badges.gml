function get_progress_badges()
{
    var progress = 0;
    var total_badges = ((global.badges_per_screen * 2) + 2) * global.playable_characters_total;
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        for (var ii = 0; ii < ((global.badges_per_screen * 2) + 2); ii += 1)
        {
            if (is_badge_unlocked(ii, i) == true)
            {
                progress += 1;
                if (progress >= ((global.badges_per_screen * 2) + 2))
                {
                    achievement_get("UNLOCK_BADGES_ALL_CHAR");
                }
            }
        }
    }
    if (progress >= total_badges)
    {
        achievement_get("UNLOCK_BADGES_ALL");
    }
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        if (is_badge_unlocked(0, i) && is_badge_unlocked(1, i) && is_badge_unlocked(2, i) && is_badge_unlocked(3, i))
        {
            switch (i)
            {
                case 0:
                    achievement_get("PAT_ALL_EASY_BADGES");
                    break;
                case 1:
                    achievement_get("BIRGIT_ALL_EASY_BADGES");
                    break;
                case 2:
                    achievement_get("RAIKKU_ALL_EASY_BADGES");
                    break;
                case 3:
                    achievement_get("TYHMYLI_ALL_EASY_BADGES");
                    break;
                case 4:
                    achievement_get("AIJA_ALL_EASY_BADGES");
                    break;
                case 5:
                    achievement_get("HYMY_ALL_EASY_BADGES");
                    break;
            }
        }
        if (is_badge_unlocked(4, i) && is_badge_unlocked(5, i) && is_badge_unlocked(6, i) && is_badge_unlocked(7, i) && is_badge_unlocked(8, i) && is_badge_unlocked(9, i))
        {
            switch (i)
            {
                case 0:
                    achievement_get("PAT_ALL_HARD_BADGES");
                    break;
                case 1:
                    achievement_get("BIRGIT_ALL_HARD_BADGES");
                    break;
                case 2:
                    achievement_get("RAIKKU_ALL_HARD_BADGES");
                    break;
                case 3:
                    achievement_get("TYHMYLI_ALL_HARD_BADGES");
                    break;
                case 4:
                    achievement_get("AIJA_ALL_HARD_BADGES");
                    break;
                case 5:
                    achievement_get("HYMY_ALL_HARD_BADGES");
                    break;
            }
        }
    }
    return progress;
}
