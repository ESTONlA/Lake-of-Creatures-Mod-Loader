function input_cursor_elastic_remove(arg0 = 0)
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
        __elastic_x = undefined;
        __elastic_y = undefined;
        __elastic_strength = 0;
    }
}
