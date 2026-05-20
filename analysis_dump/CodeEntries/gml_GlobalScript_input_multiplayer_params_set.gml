function input_multiplayer_params_set(arg0, arg1, arg2 = true, arg3 = true)
{
    __input_initialize();
    if (arg1 < 1)
    {
        __input_error("Invalid maximum player count provided (", arg1, ")");
        return undefined;
    }
    if (arg1 > 4)
    {
        __input_error("Maximum player count too large (", arg1, " must not be greater than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    if (arg0 < 1)
    {
        __input_error("Invalid minimum player count provided (", arg0, ")");
        return undefined;
    }
    if (arg0 > arg1)
    {
        __input_error("Minimum player count larger than maximum (", arg0, " must be less than ", arg1, ")");
        return undefined;
    }
    global.__input_multiplayer_min = arg0;
    global.__input_multiplayer_max = arg1;
    global.__input_multiplayer_drop_down = arg2;
    global.__input_multiplayer_allow_abort = arg3;
}
