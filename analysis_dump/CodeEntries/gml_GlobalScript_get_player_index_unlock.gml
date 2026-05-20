function get_player_index_unlock(arg0)
{
    var result = 0;
    switch (arg0)
    {
        case 1:
            result = 2;
            break;
        case 2:
            result = 4;
            break;
        case 3:
            result = 5;
            break;
        case 4:
            result = 27;
            break;
        case 5:
            result = 26;
            break;
    }
    return result;
}
