function input_profile_import(arg0, arg1, arg2 = 0)
{
    __input_initialize();
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
    return global.__input_players[arg2].__profile_import(arg0, arg1);
}
