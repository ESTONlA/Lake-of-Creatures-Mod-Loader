function input_swap_gamepad_ab(arg0)
{
    __input_initialize();
    if (arg0 == global.__input_swap_ab)
    {
        exit;
    }
    global.__input_swap_ab = arg0;
    if (global.__input_default_profile_dict == undefined)
    {
        exit;
    }
    var _profile_name_array = variable_struct_get_names(global.__input_default_profile_dict);
    var _f = 0;
    repeat (array_length(_profile_name_array))
    {
        var _profile_name = _profile_name_array[_f];
        var _profile_dict = variable_struct_get(global.__input_default_player.__profiles_dict, _profile_name);
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            var _alternate_array = variable_struct_get(_profile_dict, _verb_name);
            var _a = 0;
            repeat (array_length(_alternate_array))
            {
                var _binding = _alternate_array[_a];
                if (_binding.type == "gamepad button")
                {
                    if (_binding.value == 32769)
                    {
                        __input_trace("Swapping A/X -> B/O for profile \"", _profile_name, "\", verb \"", _verb_name, "\", alternate ", _a);
                        _binding.value = 32770;
                    }
                    else if (_binding.value == 32770)
                    {
                        __input_trace("Swapping B/O -> A/X for profile \"", _profile_name, "\", verb \"", _verb_name, "\", alternate ", _a);
                        _binding.value = 32769;
                    }
                }
                _a++;
            }
            _v++;
        }
        _f++;
    }
    input_system_reset();
}
