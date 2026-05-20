function input_player_ghost_set(arg0, arg1 = 0)
{
    __input_initialize();
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
    if (global.__input_players[arg1].__ghost == arg0)
    {
        exit;
    }
    global.__input_players[arg1].__ghost = arg0;
    if (arg0)
    {
        input_source_clear(arg1);
    }
}
