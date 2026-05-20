function input_combo_get_phase_count(arg0)
{
    var _combo_definition = variable_struct_get(global.__input_combo_verb_dict, arg0);
    if (!is_struct(_combo_definition))
    {
        __input_error("Combo not recognised (", arg0, ")");
        return undefined;
    }
    return array_length(_combo_definition.__phase_array);
}
