function input_check_repeat(arg0, arg1 = 0, arg2 = 10, arg3 = 30)
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
    var _verb_struct = variable_struct_get(global.__input_players[arg1].__verb_state_dict, arg0);
    if (!is_struct(_verb_struct))
    {
        __input_error("Verb not recognised (", arg0, ")");
        return undefined;
    }
    if (global.__input_cleared || _verb_struct.__inactive || !_verb_struct.held)
    {
        return false;
    }
    var _time = __input_get_time() - _verb_struct.press_time - arg3;
    if (_time < 0)
    {
        return false;
    }
    var _prev_time = __input_get_previous_time() - _verb_struct.press_time - arg3;
    return floor(_time / arg2) > floor(_prev_time / arg2);
}
