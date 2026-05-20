function input_consume(arg0, arg1 = 0)
{
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
    if (arg0 == -3)
    {
        var _verb_names = variable_struct_get_names(global.__input_players[arg1].__verb_state_dict);
        var _v = 0;
        repeat (array_length(_verb_names))
        {
            input_consume(_verb_names[_v], arg1);
            _v++;
        }
    }
    else if (is_array(arg0))
    {
        var _v = 0;
        repeat (array_length(arg0))
        {
            input_consume(arg0[_v], arg1);
            _v++;
        }
    }
    else
    {
        var _verb_struct = variable_struct_get(global.__input_players[arg1].__verb_state_dict, arg0);
        if (!is_struct(_verb_struct))
        {
            __input_error("Verb not recognised (", arg0, ")");
            return undefined;
        }
        with (_verb_struct)
        {
            __consumed = true;
            previous_held = true;
            __inactive = true;
            __toggle_state = false;
        }
        var _combo_state = variable_struct_get(global.__input_players[arg1].__combo_state_dict, arg0);
        if (is_struct(_combo_state))
        {
            _combo_state.__reset();
        }
    }
}
