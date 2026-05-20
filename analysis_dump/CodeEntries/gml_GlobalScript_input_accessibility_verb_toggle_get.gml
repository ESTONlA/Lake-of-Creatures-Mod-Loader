function input_accessibility_verb_toggle_get(arg0)
{
    __input_initialize();
    if (variable_struct_exists(global.__input_chord_verb_dict, arg0))
    {
        __input_error("\"", arg0, "\" is a chord verb. Verbs passed to this function must be basic verb");
    }
    if (variable_struct_exists(global.__input_combo_verb_dict, arg0))
    {
        __input_error("\"", arg0, "\" is a combo verb. Verbs passed to this function must be basic verb");
    }
    if (!variable_struct_exists(global.__input_basic_verb_dict, arg0))
    {
        __input_error("Verb \"", arg0, "\" not recognised");
    }
    return variable_struct_exists(global.__input_toggle_momentary_dict, arg0);
}
