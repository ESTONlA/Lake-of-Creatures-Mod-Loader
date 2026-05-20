function input_cursor_coord_space_get(arg0 = 0)
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
    return global.__input_players[arg0].__cursor.__coord_space;
}
