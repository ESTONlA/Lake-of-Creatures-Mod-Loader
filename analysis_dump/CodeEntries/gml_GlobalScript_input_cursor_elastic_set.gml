function input_cursor_elastic_set(arg0, arg1, arg2, arg3 = 0)
{
    if (arg3 == -3)
    {
        var _p = 0;
        repeat (4)
        {
            input_cursor_elastic_set(arg0, arg1, arg2, _p);
            _p++;
        }
        exit;
    }
    if (arg3 < 0)
    {
        __input_error("Invalid player index provided (", arg3, ")");
        return undefined;
    }
    if (arg3 >= 4)
    {
        __input_error("Player index too large (", arg3, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    with (global.__input_players[arg3].__cursor)
    {
        if (__elastic_strength > 0)
        {
            input_cursor_set(arg0 - __elastic_x, arg1 - __elastic_y, arg3, true);
        }
        __elastic_x = arg0;
        __elastic_y = arg1;
        __elastic_strength = arg2;
    }
}
