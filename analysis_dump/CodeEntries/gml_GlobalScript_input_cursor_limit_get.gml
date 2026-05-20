function input_cursor_limit_get(arg0 = 0)
{
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
        return 
        {
            left: __limit_l,
            top: __limit_t,
            right: __limit_r,
            bottom: __limit_b,
            circle_x: __limit_x,
            circle_y: __limit_y,
            circle_radius: __limit_radius
        };
    }
}
