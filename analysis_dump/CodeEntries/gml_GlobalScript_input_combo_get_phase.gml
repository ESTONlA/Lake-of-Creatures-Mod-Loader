function input_combo_get_phase(arg0, arg1 = 0)
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
    var _combo_state = variable_struct_get(global.__input_players[arg1].__combo_state_dict, arg0);
    if (!is_struct(_combo_state))
    {
        __input_error("Combo not recognised (", arg0, ")");
        return undefined;
    }
    return _combo_state.__phase;
}
