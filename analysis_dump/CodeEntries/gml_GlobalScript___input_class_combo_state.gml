function __input_class_combo_state(arg0, arg1) constructor
{
    static __reset = function()
    {
        if (__phase != 0)
        {
            array_resize(__held_verbs_array, 0);
            __held_verbs_struct = {};
            array_resize(__pressed_verbs_array, 0);
            __pressed_verbs_dict = {};
            __phase = 0;
            __initialize_phase();
        }
        __success = false;
        __phase_start_time = infinity;
    };
    
    static __tick = function(arg0)
    {
        var _phase_count = array_length(__phase_array);
        if (_phase_count <= 0)
        {
            __input_error("Combo \"", __definition_struct.__name, "\" has no phases\nPlease add phases with either the .press() or .hold_start() method");
        }
        if (!__initialized)
        {
            __initialize_phase();
        }
        if (__success)
        {
            if (array_length(__held_verbs_array) <= 0)
            {
                __reset();
                return UnknownEnum.Value_m1;
            }
            else
            {
                var _i = 0;
                repeat (array_length(__held_verbs_array))
                {
                    if (!variable_struct_get(arg0, @@array_get@@(__held_verbs_array, _i)).held)
                    {
                        __reset();
                        return UnknownEnum.Value_m1;
                    }
                    _i++;
                }
            }
            return UnknownEnum.Value_1;
        }
        else
        {
            var _state = __evaluate_phase(arg0);
            switch (_state)
            {
                case UnknownEnum.Value_m1:
                    __reset();
                    return UnknownEnum.Value_m1;
                    break;
                case UnknownEnum.Value_1:
                    __phase++;
                    __phase_start_time = __input_get_time();
                    if (__phase < _phase_count)
                    {
                        __initialize_phase();
                    }
                    else
                    {
                        __success = true;
                        __phase = _phase_count;
                        return UnknownEnum.Value_1;
                    }
                    break;
            }
        }
        return UnknownEnum.Value_0;
    };
    
    static __initialize_phase = function()
    {
        __initialized = true;
        var _phase = __phase_array[__phase];
        var _phase_type = _phase.__type;
        if (_phase_type == UnknownEnum.Value_2 || _phase_type == UnknownEnum.Value_1)
        {
            var _phase_verb = _phase.__verb;
            var _i = 0;
            repeat (array_length(__held_verbs_array))
            {
                if (__held_verbs_array[_i] == _phase_verb)
                {
                    array_delete(__held_verbs_array, _i, 1);
                    variable_struct_remove(__held_verbs_struct, _phase_verb);
                }
                else
                {
                    _i++;
                }
            }
        }
    };
    
    static __capture_all_presses = function(arg0)
    {
        var _basic_verb_array = global.__input_basic_verb_array;
        var _i = 0;
        repeat (array_length(_basic_verb_array))
        {
            var _verb_name = _basic_verb_array[_i];
            if (variable_struct_get(arg0, _verb_name).press && !variable_struct_exists(__held_verbs_struct, _verb_name) && !variable_struct_exists(__pressed_verbs_dict, _verb_name))
            {
                array_push(__pressed_verbs_array, _verb_name);
                variable_struct_set(__pressed_verbs_dict, _verb_name, true);
            }
            _i++;
        }
    };
    
    static __capture_all_holds = function(arg0)
    {
        var _basic_verb_array = global.__input_basic_verb_array;
        var _i = 0;
        repeat (array_length(_basic_verb_array))
        {
            var _verb_name = _basic_verb_array[_i];
            if (variable_struct_get(arg0, _verb_name).press && !variable_struct_exists(__held_verbs_struct, _verb_name) && !variable_struct_exists(__pressed_verbs_dict, _verb_name))
            {
                array_push(__held_verbs_array, _verb_name);
                variable_struct_set(__held_verbs_struct, _verb_name, true);
            }
            _i++;
        }
    };
    
    static __evaluate_phase = function(arg0)
    {
        var _phase = __phase_array[__phase];
        var _phase_type = _phase.__type;
        var _phase_verb = _phase.__verb;
        var _phase_timeout = _phase.__timeout;
        if ((__input_get_time() - __phase_start_time) > _phase_timeout)
        {
            return UnknownEnum.Value_m1;
        }
        var _i = 0;
        repeat (array_length(__pressed_verbs_array))
        {
            var _verb_name = __pressed_verbs_array[_i];
            if (!variable_struct_get(arg0, _verb_name).held)
            {
                array_delete(__pressed_verbs_array, _i, 1);
                variable_struct_remove(__pressed_verbs_dict, _verb_name);
            }
            else
            {
                _i++;
            }
        }
        switch (_phase_type)
        {
            case UnknownEnum.Value_0:
                if (variable_struct_get(arg0, _phase_verb).press)
                {
                    __capture_all_presses(arg0);
                    return UnknownEnum.Value_1;
                }
                break;
            case UnknownEnum.Value_3:
                if (variable_struct_get(arg0, _phase_verb).press)
                {
                    __capture_all_holds(arg0);
                    return UnknownEnum.Value_1;
                }
                break;
            case UnknownEnum.Value_1:
                var _verb_struct = variable_struct_get(arg0, _phase_verb);
                if (_verb_struct.release || !_verb_struct.held)
                {
                    return UnknownEnum.Value_1;
                }
                break;
            case UnknownEnum.Value_2:
                var _verb_struct = variable_struct_get(arg0, _phase_verb);
                if (_verb_struct.press)
                {
                    __capture_all_presses(arg0);
                    return UnknownEnum.Value_1;
                }
                else if (_verb_struct.release)
                {
                    return UnknownEnum.Value_1;
                }
                break;
            default:
                __input_error("Combo phase type \"", _phase_type, "\" not recognised");
                break;
        }
        _i = 0;
        repeat (array_length(__held_verbs_array))
        {
            if (!variable_struct_get(arg0, @@array_get@@(__held_verbs_array, _i)).held)
            {
                return UnknownEnum.Value_m1;
            }
            _i++;
        }
        var _basic_verb_array = global.__input_basic_verb_array;
        _i = 0;
        repeat (array_length(_basic_verb_array))
        {
            var _verb_name = _basic_verb_array[_i];
            if (variable_struct_get(arg0, _verb_name).held && !variable_struct_exists(__held_verbs_struct, _verb_name) && !variable_struct_exists(__pressed_verbs_dict, _verb_name) && _verb_name != _phase_verb)
            {
                return UnknownEnum.Value_m1;
            }
            _i++;
        }
        return UnknownEnum.Value_0;
    };
    
    __name = arg0;
    __definition_struct = arg1;
    __phase_array = __definition_struct.__phase_array;
    __success = false;
    __held_verbs_array = [];
    __held_verbs_struct = {};
    __pressed_verbs_array = [];
    __pressed_verbs_dict = {};
    __phase = 0;
    __phase_start_time = infinity;
    __initialized = false;
}

enum UnknownEnum
{
    Value_m1 = -1,
    Value_0,
    Value_1,
    Value_2,
    Value_3
}
