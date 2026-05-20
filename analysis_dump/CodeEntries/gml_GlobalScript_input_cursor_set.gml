function input_cursor_set(arg0, arg1, arg2 = 0, arg3 = false)
{
    if (arg2 == -3)
    {
        var _p = 0;
        repeat (4)
        {
            input_cursor_set(arg0, arg1, _p, arg3);
            _p++;
        }
        exit;
    }
    if (arg2 < 0)
    {
        __input_error("Invalid player index provided (", arg2, ")");
        return undefined;
    }
    if (arg2 >= 4)
    {
        __input_error("Player index too large (", arg2, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    return global.__input_players[arg2].__cursor.__set(arg0, arg1, arg3);
}
