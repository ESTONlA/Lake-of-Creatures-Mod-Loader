function input_cursor_limit_aabb(arg0, arg1, arg2, arg3, arg4 = 0)
{
    if (arg4 == -3)
    {
        var _p = 0;
        repeat (4)
        {
            input_cursor_limit_aabb(arg0, arg1, arg2, arg3, _p);
            _p++;
        }
        exit;
    }
    if (arg4 < 0)
    {
        __input_error("Invalid player index provided (", arg4, ")");
        return undefined;
    }
    if (arg4 >= 4)
    {
        __input_error("Player index too large (", arg4, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    with (global.__input_players[arg4].__cursor)
    {
        __limit_l = arg0;
        __limit_t = arg1;
        __limit_r = arg2;
        __limit_b = arg3;
        __limit_x = undefined;
        __limit_y = undefined;
        __limit_radius = undefined;
        __limit();
    }
}
