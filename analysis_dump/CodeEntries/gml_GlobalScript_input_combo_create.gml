function input_combo_create(arg0, arg1 = 20)
{
    __input_initialize();
    __input_ensure_unique_verb_name(arg0);
    var _combo_definition = new __input_class_combo_definition(arg0, arg1);
    variable_struct_set(global.__input_all_verb_dict, arg0, true);
    array_push(global.__input_all_verb_array, arg0);
    variable_struct_set(global.__input_combo_verb_dict, arg0, _combo_definition);
    array_push(global.__input_combo_verb_array, arg0);
    var _p = 0;
    repeat (4)
    {
        global.__input_players[_p].__add_combo(arg0);
        _p++;
    }
    return _combo_definition;
}
