function __input_player_tick_sources()
{
    if (__profile_name == undefined)
    {
        exit;
    }
    var _current_profile_dict = variable_struct_get(__profiles_dict, __profile_name);
    var _is_multidevice_player = global.__input_source_mode == UnknownEnum.Value_4 && __index == 0;
    var _v = 0;
    repeat (array_length(global.__input_basic_verb_array))
    {
        var _verb_name = global.__input_basic_verb_array[_v];
        var _verb_struct = variable_struct_get(__verb_state_dict, _verb_name);
        var _raw = 0;
        var _value = 0;
        var _analogue = false;
        var _raw_analogue = false;
        var _min_threshold = 0;
        var _max_threshold = 1;
        with (_verb_struct)
        {
            if (force_value != undefined && force_analogue != undefined)
            {
                _raw = force_value;
                _value = force_value;
                _analogue = force_analogue;
                _raw_analogue = force_analogue;
                _min_threshold = 0;
                _max_threshold = 1;
                force_value = undefined;
                force_analogue = undefined;
            }
        }
        var _s = 0;
        repeat (array_length(__source_array))
        {
            var _source_struct = __source_array[_s];
            var _source_type = _source_struct.__source;
            var _source_gamepad = _source_struct.__gamepad;
            var _alternate_array = variable_struct_get(_current_profile_dict, _verb_name);
            switch (_source_type)
            {
                case UnknownEnum.Value_0:
                    var _alternate = 0;
                    repeat (2)
                    {
                        var _binding = _alternate_array[_alternate];
                        switch (_binding.type)
                        {
                            case "key":
                                if (keyboard_check(_binding.value))
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case undefined:
                                break;
                            case "mouse button":
                                if (input_mouse_check(_binding.value))
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case "mouse wheel up":
                                if (mouse_wheel_up())
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case "mouse wheel down":
                                if (mouse_wheel_down())
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            default:
                                if (global.__input_source_mode != UnknownEnum.Value_3 && global.__input_source_mode != UnknownEnum.Value_4)
                                {
                                    __input_error("Binding unsupported for ", _source_struct, "\n", _binding);
                                }
                                break;
                        }
                        _alternate++;
                    }
                    break;
                case UnknownEnum.Value_1:
                    var _alternate = 0;
                    repeat (2)
                    {
                        var _binding = _alternate_array[_alternate];
                        switch (_binding.type)
                        {
                            case "mouse button":
                                if (input_mouse_check(_binding.value))
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case "mouse wheel up":
                                if (mouse_wheel_up())
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case "mouse wheel down":
                                if (mouse_wheel_down())
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case undefined:
                                break;
                            default:
                                if (global.__input_source_mode != UnknownEnum.Value_3 && global.__input_source_mode != UnknownEnum.Value_4)
                                {
                                    __input_error("Binding unsupported for ", _source_struct, "\n", _binding);
                                }
                                break;
                        }
                        _alternate++;
                    }
                    break;
                case UnknownEnum.Value_2:
                    if (!input_gamepad_is_connected(_source_gamepad))
                    {
                        _s++;
                        continue;
                    }
                    var _alternate = 0;
                    repeat (2)
                    {
                        var _binding = _alternate_array[_alternate];
                        if (_is_multidevice_player && _binding.__gamepad_index != undefined && _source_gamepad != _binding.__gamepad_index)
                        {
                            continue;
                        }
                        switch (_binding.type)
                        {
                            case "gamepad button":
                                if (input_gamepad_check(_source_gamepad, _binding.value))
                                {
                                    _value = 1;
                                    _raw = 1;
                                    _analogue = false;
                                    _raw_analogue = false;
                                }
                                break;
                            case "gamepad axis":
                                var _found_raw = input_gamepad_value(_source_gamepad, _binding.value);
                                var _binding_threshold_min = _binding.__threshold_min;
                                var _binding_threshold_max = _binding.__threshold_max;
                                if (_binding_threshold_min == undefined || _binding_threshold_max == undefined)
                                {
                                    var _threshold_struct = __axis_threshold_get(_binding.value);
                                    _binding_threshold_min = _threshold_struct.mini;
                                    _binding_threshold_max = _threshold_struct.maxi;
                                }
                                if (_binding.axis_negative)
                                {
                                    _found_raw = -_found_raw;
                                }
                                var _found_value = _found_raw;
                                _found_value = (_found_value - _binding_threshold_min) / (_binding_threshold_max - _binding_threshold_min);
                                _found_value = clamp(_found_value, 0, 1);
                                if (_found_raw > _raw)
                                {
                                    _raw = _found_raw;
                                    _raw_analogue = true;
                                    _min_threshold = _binding_threshold_min;
                                    _max_threshold = _binding_threshold_max;
                                }
                                if (_found_value > _value)
                                {
                                    _value = _found_value;
                                    _analogue = true;
                                }
                                break;
                            case undefined:
                                break;
                            default:
                                if (global.__input_source_mode != UnknownEnum.Value_3 && global.__input_source_mode != UnknownEnum.Value_4)
                                {
                                    __input_error("Binding unsupported for ", _source_struct, "\n", _binding);
                                }
                                break;
                        }
                        _alternate++;
                    }
                    break;
            }
            _s++;
        }
        with (_verb_struct)
        {
            value = _value;
            raw = _raw;
            if (_raw_analogue != undefined)
            {
                raw_analogue = _raw_analogue;
            }
            if (_analogue != undefined)
            {
                analogue = _analogue;
            }
            min_threshold = _min_threshold;
            max_threshold = _max_threshold;
        }
        _v++;
    }
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4
}
