function input_verb_group_is_active(arg0, arg1 = 0)
{
    __input_initialize();
    if (!variable_struct_exists(global.__input_group_to_verbs_dict, arg0))
    {
        __input_error("Verb group \"", arg0, "\" doesn't exist\nPlease make sure it has been defined in __input_config_verbs()");
    }
    return global.__input_players[arg1].__verb_group_is_active(arg0);
}
