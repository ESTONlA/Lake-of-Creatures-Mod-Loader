function __input_finalize_default_profiles()
{
    if (global.__input_initialization_phase != "__input_finalize_default_profiles")
    {
        exit;
    }
    if (!is_struct(global.__input_default_profile_dict))
    {
        __input_error("INPUT_DEFAULT_PROFILES must contain a struct (was ", typeof(global.__input_default_profile_dict), ")\nDocumentation on INPUT_DEFAULT_PROFILES can be found offline in __input_config_profiles_and_default_bindings()\nOnline documentation can be found at https://jujuadams.github.io/Input");
    }
    if (variable_struct_names_count(global.__input_default_profile_dict) <= 0)
    {
        __input_error("INPUT_DEFAULT_PROFILES must contain at least one profile");
    }
    global.__input_strict_binding_check = true;
    global.__input_profile_array = variable_struct_get_names(global.__input_default_profile_dict);
    global.__input_profile_dict = {};
    var _f = 0;
    repeat (array_length(global.__input_profile_array))
    {
        var _profile_name = global.__input_profile_array[_f];
        var _profile_struct = variable_struct_get(global.__input_default_profile_dict, _profile_name);
        if (!is_struct(_profile_struct))
        {
            __input_error("Profile \"", _profile_name, "\" definition must be a struct (was ", typeof(_profile_struct), ")");
        }
        variable_struct_set(global.__input_profile_dict, _profile_name, _profile_struct);
        global.__input_default_player.__profile_ensure(_profile_name);
        var _profile_verb_names = variable_struct_get_names(_profile_struct);
        var _v = 0;
        repeat (array_length(_profile_verb_names))
        {
            var _verb_name = _profile_verb_names[_v];
            if (!variable_struct_exists(global.__input_basic_verb_dict, _verb_name))
            {
                array_push(global.__input_basic_verb_array, _verb_name);
                variable_struct_set(global.__input_basic_verb_dict, _verb_name, true);
                array_push(global.__input_all_verb_array, _verb_name);
                variable_struct_set(global.__input_all_verb_dict, _verb_name, true);
            }
            var _verb_data = variable_struct_get(_profile_struct, _verb_name);
            if (!is_array(_verb_data))
            {
                _verb_data = [_verb_data];
            }
            if (array_length(_verb_data) > 2)
            {
                __input_error("Verb \"", _verb_name, "\" for default profile \"", _profile_name, "\" has too many alternate bindings (", array_length(_verb_data), " versus max ", 2, ")\nPlease increase INPUT_MAX_ALTERNATE_BINDINGS if you'd like to use more alternate bindings");
            }
            global.__input_default_player.__verb_ensure(_profile_name, _verb_name);
            var _a = 0;
            repeat (array_length(_verb_data))
            {
                var _binding = _verb_data[_a];
                if (_binding == undefined)
                {
                    _binding = input_binding_empty();
                }
                else if (!input_value_is_binding(_binding))
                {
                    __input_error("Binding for profile \"", _profile_name, "\", verb \"", _verb_name, "\", alternate ", _a, " is not a binding\nPlease use one of the input_binding_*() functions to create bindings");
                }
                else
                {
                    switch (_binding.__get_source_type())
                    {
                        case UnknownEnum.Value_0:
                            global.__input_any_keyboard_binding_defined = true;
                            break;
                        case UnknownEnum.Value_1:
                            global.__input_any_mouse_binding_defined = true;
                            break;
                        case UnknownEnum.Value_2:
                            global.__input_any_gamepad_binding_defined = true;
                            break;
                    }
                }
                if (global.__input_swap_ab)
                {
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
                }
                global.__input_default_player.__binding_set(_profile_name, _verb_name, _a, _binding);
                _a++;
            }
            _v++;
        }
        _f++;
    }
    if (!variable_struct_exists(global.__input_profile_dict, "keyboard_and_mouse"))
    {
        __input_trace("Warning! Default profile for keyboard \"", "keyboard_and_mouse", "\" has not been defined in INPUT_DEFAULT_PROFILES");
    }
    if (!variable_struct_exists(global.__input_profile_dict, "keyboard_and_mouse"))
    {
        __input_trace("Warning! Default profile for mouse \"", "keyboard_and_mouse", "\" has not been defined in INPUT_DEFAULT_PROFILES");
    }
    if (!variable_struct_exists(global.__input_profile_dict, "gamepad"))
    {
        __input_trace("Warning! Default profile for gamepad \"", "gamepad", "\" has not been defined in INPUT_DEFAULT_PROFILES");
    }
    if (!variable_struct_exists(global.__input_profile_dict, "mixed"))
    {
        __input_trace("Warning! Default profile for mixed \"", "mixed", "\" has not been defined in INPUT_DEFAULT_PROFILES");
    }
    if (!variable_struct_exists(global.__input_profile_dict, "multidevice"))
    {
        __input_trace("Warning! Default profile for multidevice \"", "multidevice", "\" has not been defined in INPUT_DEFAULT_PROFILES");
    }
    global.__input_cursor_verbs_valid = true;
    if (!variable_struct_exists(global.__input_basic_verb_dict, "aim_up"))
    {
        __input_trace("Warning! Default cursor up verb \"", "aim_up", "\" has not been defined for any profile");
        global.__input_cursor_verbs_valid = false;
    }
    if (!variable_struct_exists(global.__input_basic_verb_dict, "aim_down"))
    {
        __input_trace("Warning! Default cursor down verb \"", "aim_down", "\" has not been defined for any profile");
        global.__input_cursor_verbs_valid = false;
    }
    if (!variable_struct_exists(global.__input_basic_verb_dict, "aim_left"))
    {
        __input_trace("Warning! Default cursor left verb \"", "aim_left", "\" has not been defined for any profile");
        global.__input_cursor_verbs_valid = false;
    }
    if (!variable_struct_exists(global.__input_basic_verb_dict, "aim_right"))
    {
        __input_trace("Warning! Default cursor right verb \"", "aim_right", "\" has not been defined for any profile");
        global.__input_cursor_verbs_valid = false;
    }
    _f = 0;
    repeat (array_length(global.__input_profile_array))
    {
        var _profile_name = global.__input_profile_array[_f];
        var _profile_struct = variable_struct_get(global.__input_default_profile_dict, _profile_name);
        var _p = 0;
        repeat (4)
        {
            global.__input_players[_p].__profile_ensure(_profile_name);
            _p++;
        }
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            if (!variable_struct_exists(_profile_struct, _verb_name))
            {
                __input_trace("Warning! Default profile \"", _profile_name, "\" does not include a definition for basic verb \"", _verb_name, "\"");
                global.__input_default_player.__verb_ensure(_profile_name, _verb_name);
            }
            _p = 0;
            repeat (4)
            {
                global.__input_players[_p].__verb_ensure(_profile_name, _verb_name);
                _p++;
            }
            _v++;
        }
        _f++;
    }
    input_system_reset();
    global.__input_strict_binding_check = false;
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2
}
