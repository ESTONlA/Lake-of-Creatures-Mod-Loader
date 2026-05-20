function input_binding_scan_get_params(arg0 = 0)
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
    with (global.__input_players[arg0])
    {
        return 
        {
            ignore_array: is_struct(__rebind_ignore_struct) ? variable_struct_get_names(__rebind_ignore_struct) : undefined,
            allow_array: is_struct(__rebind_allow_struct) ? variable_struct_get_names(__rebind_allow_struct) : undefined
        };
    }
}
