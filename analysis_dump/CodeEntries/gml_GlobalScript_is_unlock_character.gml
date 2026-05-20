function is_unlock_character(arg0)
{
    var result = "";
    switch (arg0)
    {
        case 2:
            result = "X";
            if (global.unlocks_all[2] > 0)
            {
                result = get_player_name(1);
            }
            break;
        case 4:
            result = "X";
            if (global.unlocks_all[4] > 0)
            {
                result = get_player_name(2);
            }
            break;
        case 5:
            result = "X";
            if (global.unlocks_all[5] > 0)
            {
                result = get_player_name(3);
            }
            break;
        case 26:
            result = "X";
            if (global.unlocks_all[26] > 0)
            {
                result = get_player_name(5);
            }
            break;
        case 27:
            result = "X";
            if (global.unlocks_all[27] > 0)
            {
                result = get_player_name(4);
            }
            break;
    }
    return result;
}
