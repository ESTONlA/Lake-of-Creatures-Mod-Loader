function input_axis_threshold_set(arg0, arg1, arg2, arg3 = 0)
{
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
    return global.__input_players[arg3].__axis_threshold_set(arg0, arg1, arg2);
}
