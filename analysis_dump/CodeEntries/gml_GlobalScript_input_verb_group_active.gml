function input_verb_group_active(arg0, arg1, arg2 = 0, arg3 = false)
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
    if (!variable_struct_exists(global.__input_group_to_verbs_dict, arg0))
    {
        __input_error("Verb group \"", arg0, "\" doesn't exist\nPlease make sure it has been defined in __input_config_verbs()");
    }
    global.__input_players[arg2].__verb_group_active(arg0, arg1, arg3);
}
