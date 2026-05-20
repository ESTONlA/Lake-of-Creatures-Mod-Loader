function input_chord_create()
{
    __input_initialize();
    var _name = argument[0];
    var _max_time = argument[1] ?? 4;
    __input_ensure_unique_verb_name(_name);
    var _verb_array = array_create(argument_count - 2);
    var _i = 0;
    repeat (array_length(_verb_array))
    {
        array_set(_verb_array, _i, argument[_i + 2]);
        _i++;
    }
    var _chord_definition = new __input_class_chord_definition(_name, _max_time, _verb_array);
    variable_struct_set(global.__input_all_verb_dict, _name, true);
    array_push(global.__input_all_verb_array, _name);
    variable_struct_set(global.__input_chord_verb_dict, _name, _chord_definition);
    array_push(global.__input_chord_verb_array, _name);
    var _p = 0;
    repeat (4)
    {
        global.__input_players[_p].__add_chord(_name);
        _p++;
    }
}
