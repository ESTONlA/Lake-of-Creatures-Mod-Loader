function input_cursor_limit_remove(arg0 = 0)
{
    if (arg0 == -3)
    {
        var _p = 0;
        repeat (4)
        {
            input_cursor_limit_remove(_p);
            _p++;
        }
        exit;
    }
    if (arg0 < 0)
    {
        __input_error("Invalid player index provided (", arg0, ")");
        return undefined;
    }
    if (arg0 >= 4)
    {
        __input_error("Player index too large (", arg0, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    with (global.__input_players[arg0].__cursor)
    {
        __limit_l = undefined;
        __limit_t = undefined;
        __limit_r = undefined;
        __limit_b = undefined;
        __limit_x = undefined;
        __limit_y = undefined;
        __limit_radius = undefined;
        __limit();
    }
}
