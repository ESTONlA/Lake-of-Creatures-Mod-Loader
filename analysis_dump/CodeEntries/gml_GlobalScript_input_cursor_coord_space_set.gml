function input_cursor_coord_space_set(arg0, arg1 = 0)
{
    if (arg1 == -3)
    {
        var _p = 0;
        repeat (4)
        {
            input_cursor_coord_space_set(arg0, _p);
            _p++;
        }
        exit;
    }
    if (arg1 < 0)
    {
        __input_error("Invalid player index provided (", arg1, ")");
        return undefined;
    }
    if (arg1 >= 4)
    {
        __input_error("Player index too large (", arg1, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    global.__input_players[arg1].__cursor.__coord_space = arg0;
}
