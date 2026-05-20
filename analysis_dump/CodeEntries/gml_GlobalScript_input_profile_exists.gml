function input_profile_exists(arg0, arg1 = 0)
{
    __input_initialize();
    if (is_string(arg1) && arg1 == "default")
    {
        return global.__input_default_player.__profile_exists(arg0);
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
    return global.__input_players[arg1].__profile_exists(arg0);
}
