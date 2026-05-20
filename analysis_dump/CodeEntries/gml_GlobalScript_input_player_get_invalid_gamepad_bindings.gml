function input_player_get_invalid_gamepad_bindings(arg0 = 0, arg1 = undefined)
{
    __input_initialize();
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
    if (!input_profile_exists(arg1, arg0))
    {
        __input_error("Profile name \"", arg1, "\" doesn't exist");
    }
    return global.__input_players[arg0].__get_invalid_gamepad_bindings(arg1);
}
