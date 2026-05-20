function is_badge_unlocked(arg0, arg1)
{
    var result = false;
    switch (arg0)
    {
        case 0:
            if (global.lake_finished_amount_char_easy[2][arg1] > 0 || global.lake_finished_amount_char_hard[2][arg1] > 0)
            {
                result = true;
            }
            break;
        case 1:
            if (global.all_fish_caught_lake_easy[0][arg1] > 0 || global.all_fish_caught_lake_hard[0][arg1] > 0)
            {
                result = true;
            }
            break;
        case 2:
            if (global.all_fish_caught_lake_easy[1][arg1] > 0 || global.all_fish_caught_lake_hard[1][arg1] > 0)
            {
                result = true;
            }
            break;
        case 3:
            if (global.all_fish_caught_lake_easy[2][arg1] > 0 || global.all_fish_caught_lake_hard[2][arg1] > 0)
            {
                result = true;
            }
            break;
        case 4:
            if (global.lake_finished_amount_char_hard[2][arg1] > 0)
            {
                result = true;
                achievement_get("GET_BADGE_HARD");
            }
            break;
        case 5:
            if (global.all_fish_caught_lake_hard[0][arg1] > 0)
            {
                result = true;
                achievement_get("GET_BADGE_HARD");
            }
            break;
        case 6:
            if (global.all_fish_caught_lake_hard[1][arg1] > 0)
            {
                result = true;
                achievement_get("GET_BADGE_HARD");
            }
            break;
        case 7:
            if (global.all_fish_caught_lake_hard[2][arg1] > 0)
            {
                result = true;
                achievement_get("GET_BADGE_HARD");
            }
            break;
        case 8:
            if (global.lake_finished_amount_char_hard[3][arg1] > 0)
            {
                result = true;
            }
            break;
        case 9:
            if (global.all_fish_caught_lake_hard[3][arg1] > 0)
            {
                result = true;
            }
            break;
    }
    if (result == true)
    {
        achievement_get("GET_BADGE");
    }
    return result;
}
