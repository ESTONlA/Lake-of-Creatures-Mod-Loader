function input_binding_is_valid(arg0, arg1 = 0)
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
    if (arg0 == undefined)
    {
        return false;
    }
    else if (!input_value_is_binding(arg0))
    {
        __input_error("Value provided is not a binding");
        return false;
    }
    with (global.__input_players[arg1])
    {
        return __sources_validate_binding(arg0);
    }
}
