function input_held_time_released(arg0, arg1 = 0)
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
    if (_verb_struct.__inactive || global.__input_cleared || !_verb_struct.release)
    {
        return -1;
    }
    return max(0, global.__input_frame - 1 - _verb_struct.press_time);
}
