function __input_class_player() constructor
{
    static __profile_create = function(arg0)
    {
        if (variable_struct_exists(__profiles_dict, arg0))
        {
            __input_error("Profile \"", arg0, "\" already exists for player ", __index);
        }
        var _new_profile_struct = {};
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            var _alternate_array = array_create(2, undefined);
            var _a = 0;
            repeat (2)
            {
                array_set(_alternate_array, _a, input_binding_empty());
                _a++;
            }
            variable_struct_set(_new_profile_struct, _verb_name, _alternate_array);
            _v++;
        }
        variable_struct_set(__profiles_dict, arg0, _new_profile_struct);
    };
    
    static __profile_destroy = function(arg0)
    {
        if (variable_struct_exists(global.__input_default_profile_dict, arg0))
        {
            __input_error("Cannot remove profile \"", arg0, "\" as it is a default profile");
        }
        if (__profile_name == arg0)
        {
            __profile_name = undefined;
        }
        variable_struct_remove(__profiles_dict, arg0);
        if (__profile_name == undefined)
        {
            __profile_set(__profile_get_auto());
        }
    };
    
    static __profile_exists = function(arg0)
    {
        if (arg0 == undefined)
        {
            return true;
        }
        return variable_struct_exists(__profiles_dict, arg0);
    };
    
    static __profile_get_array = function()
    {
        return variable_struct_get_names(__profiles_dict);
    };
    
    static __profile_set = function(arg0)
    {
        if (arg0 == undefined)
        {
            __input_trace("Warning! Failed to set profile for player ", __index, " (was ", arg0, ")");
            exit;
        }
        if (!variable_struct_exists(__profiles_dict, arg0))
        {
            __input_error("Profile \"", arg0, "\" doesn't exist for player ", __index);
        }
        if (__profile_name != arg0)
        {
            __input_trace("Setting player ", __index, " profile to \"", arg0, "\"");
        }
        __profile_name = arg0;
    };
    
    static __profile_get = function(arg0 = undefined)
    {
        if (arg0 == undefined)
        {
            return __profile_name;
        }
        if (!variable_struct_exists(__profiles_dict, arg0))
        {
            __input_error("Profile \"", arg0, "\" doesn't exist for player ", __index);
        }
        return arg0;
    };
    
    static __profile_get_auto = function()
    {
        if (__ghost)
        {
            return undefined;
        }
        if (global.__input_source_mode == UnknownEnum.Value_4 && __index == 0)
        {
            return "multidevice";
        }
        var _count = array_length(__source_array);
        if (_count == 0)
        {
            return undefined;
        }
        if (_count == 1)
        {
            switch (__source_array[0].__source)
            {
                case UnknownEnum.Value_0:
                    return "keyboard_and_mouse";
                    break;
                case UnknownEnum.Value_1:
                    return "keyboard_and_mouse";
                    break;
                case UnknownEnum.Value_2:
                    return "gamepad";
                    break;
                default:
                    __input_error("Invalid source (", __source_array[0].__source, ")");
                    break;
            }
        }
        return "mixed";
    };
    
    static __profile_set_auto = function()
    {
        var _profile_name = __profile_get_auto();
        if (_profile_name != undefined)
        {
            __profile_set(_profile_name);
        }
    };
    
    static __profile_ensure = function(arg0)
    {
        if (arg0 == "")
        {
            __input_error("Profile name cannot be an empty string");
            return undefined;
        }
        var _profile_struct = variable_struct_get(__profiles_dict, arg0);
        if (!is_struct(_profile_struct))
        {
            _profile_struct = {};
            variable_struct_set(__profiles_dict, arg0, _profile_struct);
            var _v = 0;
            repeat (array_length(global.__input_basic_verb_array))
            {
                var _verb_name = global.__input_basic_verb_array[_v];
                __verb_ensure(arg0, _verb_name);
                _v++;
            }
        }
    };
    
    static __profile_reset_bindings = function(arg0)
    {
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            var _alternate = 0;
            repeat (2)
            {
                __binding_reset(arg0, _verb_name, _alternate);
                _alternate++;
            }
            _v++;
        }
    };
    
    static __profile_export = function(arg0, arg1, arg2)
    {
        if (!variable_struct_exists(__profiles_dict, arg0))
        {
            __input_error("Profile \"", arg0, "\" doesn't exist for player ", __index);
        }
        var _output = {};
        var _profile_struct = variable_struct_get(__profiles_dict, arg0);
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            var _new_alternate_array = [];
            variable_struct_set(_output, _verb_name, _new_alternate_array);
            var _alternate_array = variable_struct_get(_profile_struct, _verb_name);
            var _a = 0;
            repeat (2)
            {
                array_push(_new_alternate_array, _alternate_array[_a].__export());
                _a++;
            }
            _v++;
        }
        if (arg1)
        {
            if (arg2)
            {
                return __input_snap_to_json(_output, true, true);
            }
            else
            {
                return json_stringify(_output);
            }
        }
        else
        {
            return _output;
        }
    };
    
    static __profile_import = function(arg0, arg1)
    {
        var _json;
        if (is_string(arg0))
        {
            _json = json_parse(arg0);
        }
        else
        {
            _json = arg0;
        }
        if (!is_struct(_json) && !is_array(_json))
        {
            __input_error("Input must be valid JSON (typeof=", arg0, ")");
            exit;
        }
        __profile_ensure(arg1);
        var _existing_verb_dict = variable_struct_get(__profiles_dict, arg1);
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            var _verb_name = global.__input_basic_verb_array[_v];
            var _existing_alternate_array = variable_struct_get(_existing_verb_dict, _verb_name);
            if (!is_array(_existing_alternate_array))
            {
                _existing_alternate_array = array_create(2, undefined);
                _a = 0;
                repeat (2)
                {
                    array_set(_existing_alternate_array, _a, input_binding_empty());
                    _a++;
                }
                variable_struct_set(_existing_verb_dict, _verb_name, _existing_alternate_array);
            }
            var _alternate_array = variable_struct_get(_json, _verb_name);
            if (!is_array(_alternate_array))
            {
                __input_error("Player ", __index, " data is missing verb \"", _verb_name, "\"");
            }
            if (array_length(_alternate_array) != 2)
            {
                __input_error("JSON malformed, player ", __index, " verb \"", _verb_name, "\" should have ", 2, " alternate bindings, but it had ", array_length(_alternate_array));
            }
            var _a = 0;
            repeat (2)
            {
                @@array_get@@(_existing_alternate_array, _a).__import(_alternate_array[_a]);
                _a++;
            }
            _v++;
        }
    };
    
    static __sources_clear = function()
    {
        if (__rebind_state > 0 && array_length(__source_array) > 0)
        {
            __binding_scan_failure(UnknownEnum.Value_m11);
        }
        array_resize(__source_array, 0);
        __last_input_time = global.__input_current_time;
    };
    
    static __source_add = function(arg0)
    {
        var _i = 0;
        repeat (array_length(__source_array))
        {
            if (__source_array[_i] == arg0)
            {
                exit;
            }
            _i++;
        }
        if (__rebind_state > 0)
        {
            __binding_scan_failure(UnknownEnum.Value_m11);
        }
        array_push(__source_array, arg0);
        __last_input_time = global.__input_current_time;
    };
    
    static __source_remove = function(arg0)
    {
        var _i = 0;
        repeat (array_length(__source_array))
        {
            if (__source_array[_i] == arg0)
            {
                array_delete(__source_array, _i, 1);
            }
            else
            {
                _i++;
            }
        }
    };
    
    static __source_contains = function(arg0)
    {
        if (arg0 == global.__input_source_gamepad)
        {
            _i = 0;
            repeat (array_length(__source_array))
            {
                if (__source_array[_i].__source == UnknownEnum.Value_2)
                {
                    return true;
                }
                _i++;
            }
            return false;
        }
        var _i = 0;
        repeat (array_length(__source_array))
        {
            if (__source_array[_i].__equal_to(arg0))
            {
                return true;
            }
            _i++;
        }
        return false;
    };
    
    static __source_get_gamepad = function()
    {
        var _i = 0;
        repeat (array_length(__source_array))
        {
            var _gamepad = __source_array[_i].__gamepad;
            if (input_gamepad_is_connected(_gamepad))
            {
                return _gamepad;
            }
            _i++;
        }
        return -1;
    };
    
    static __sources_any_input = function()
    {
        var _i = 0;
        repeat (array_length(__source_array))
        {
            if (__source_array[_i].__scan_for_binding(__index, true, 0, undefined))
            {
                return true;
            }
            _i++;
        }
        return false;
    };
    
    static __sources_validate_binding = function(arg0)
    {
        var _i = 0;
        repeat (array_length(__source_array))
        {
            if (__source_array[_i].__validate_binding(arg0))
            {
                return true;
            }
            _i++;
        }
        return false;
    };
    
    static __binding_get = function(arg0, arg1, arg2)
    {
        arg0 = __profile_get(arg0);
        if (arg0 == undefined)
        {
            return global.__input_null_binding;
        }
        return @@array_get@@(variable_struct_get(variable_struct_get(__profiles_dict, arg0), arg1), arg2);
    };
    
    static __binding_set = function(arg0, arg1, arg2, arg3)
    {
        arg0 = __profile_get(arg0);
        if (arg0 == undefined)
        {
            __input_trace("Warning! Cannot set binding, profile was <undefined>");
            exit;
        }
        if ((arg0 == "keyboard_and_mouse" || arg0 == "keyboard_and_mouse" || arg0 == "gamepad") && arg0 != "mixed" && arg0 != "multidevice")
        {
            switch (arg3.__get_source_type())
            {
                case UnknownEnum.Value_0:
                    if (!(arg0 == "keyboard_and_mouse" || (true && arg0 == "keyboard_and_mouse")))
                    {
                        if (global.__input_strict_binding_check)
                        {
                            __input_error("Keyboard binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        else
                        {
                            __input_trace("Warning! Keyboard binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        exit;
                    }
                    break;
                case UnknownEnum.Value_1:
                    if (!(arg0 == "keyboard_and_mouse" || (true && arg0 == "keyboard_and_mouse")))
                    {
                        if (global.__input_strict_binding_check)
                        {
                            __input_error("Mouse binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        else
                        {
                            __input_trace("Warning! Mouse binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        exit;
                    }
                    break;
                case UnknownEnum.Value_2:
                    if (!(arg0 == "gamepad"))
                    {
                        if (global.__input_strict_binding_check)
                        {
                            __input_error("Gamepad binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        else
                        {
                            __input_trace("Warning! Gamepad binding \"", input_binding_get_name(arg3), "\" not supported for profile \"", arg0, "\"");
                        }
                        exit;
                    }
                    break;
            }
        }
        array_set(variable_struct_get(variable_struct_get(__profiles_dict, arg0), arg1), arg2, arg3);
        __input_trace("Binding for profile \"", arg0, "\" verb \"", arg1, "\" alternate ", arg2, " set to ", arg3);
    };
    
    static __binding_remove = function(arg0, arg1, arg2)
    {
        arg0 = __profile_get(arg0);
        if (arg0 == undefined)
        {
            __input_trace("Warning! Cannot remove binding, profile was <undefined>");
            exit;
        }
        array_set(variable_struct_get(variable_struct_get(__profiles_dict, arg0), arg1), arg2, input_binding_empty());
    };
    
    static __binding_reset = function(arg0, arg1, arg2)
    {
        arg0 = __profile_get(arg0);
        if (arg0 == undefined)
        {
            __input_trace("Warning! Cannot reset binding, profile was <undefined>");
            exit;
        }
        var _default_profile_struct = variable_struct_get(global.__input_default_player.__profiles_dict, arg0);
        if (!is_struct(_default_profile_struct))
        {
            __input_error("Profile \"", arg0, "\" doesn't exist as a default profile");
        }
        var _binding_struct = @@array_get@@(variable_struct_get(_default_profile_struct, arg1), arg2);
        if (is_struct(_binding_struct))
        {
            _binding_struct = _binding_struct.__duplicate();
        }
        array_set(variable_struct_get(variable_struct_get(__profiles_dict, arg0), arg1), arg2, _binding_struct);
    };
    
    static __verb_group_ensure = function(arg0)
    {
        if (!variable_struct_exists(__verb_group_state_dict, arg0))
        {
            variable_struct_set(__verb_group_state_dict, arg0, true);
        }
    };
    
    static __verb_group_active = function(arg0, arg1, arg2)
    {
        var _old_state = variable_struct_get(__verb_group_state_dict, arg0);
        if (_old_state != arg1)
        {
            variable_struct_set(__verb_group_state_dict, arg0, arg1);
            var _array = variable_struct_get(global.__input_group_to_verbs_dict, arg0);
            if (arg1)
            {
                var _i = 0;
                repeat (array_length(_array))
                {
                    variable_struct_get(__verb_state_dict, @@array_get@@(_array, _i)).__group_inactive = false;
                    _i++;
                }
            }
            else
            {
                var _i = 0;
                repeat (array_length(_array))
                {
                    with (variable_struct_get(__verb_state_dict, @@array_get@@(_array, _i)))
                    {
                        __group_inactive = true;
                        previous_held = true;
                        __inactive = true;
                        __toggle_state = false;
                    }
                    _i++;
                }
            }
        }
        if (arg1 && arg2)
        {
            var _i = 0;
            repeat (array_length(global.__input_verb_group_array))
            {
                var _found_group = global.__input_verb_group_array[_i];
                if (_found_group != arg0)
                {
                    __verb_group_active(_found_group, false, false);
                }
                _i++;
            }
        }
    };
    
    static __verb_group_is_active = function(arg0)
    {
        return variable_struct_get(__verb_group_state_dict, arg0);
    };
    
    static __verb_ensure = function(arg0, arg1)
    {
        if (arg1 == "")
        {
            __input_error("Verb name cannot be an empty string");
            return undefined;
        }
        var _profile_struct = variable_struct_get(__profiles_dict, arg0);
        if (!is_struct(_profile_struct))
        {
            __input_error("Profile \"", arg0, "\" does not exist for player ", __index);
        }
        if (!is_struct(variable_struct_get(__verb_state_dict, arg1)))
        {
            var _verb = new __input_class_verb_state();
            _verb.__player = self;
            _verb.name = arg1;
            _verb.type = UnknownEnum.Value_0;
            variable_struct_set(__verb_state_dict, arg1, _verb);
        }
        var _verb_alternate_array = variable_struct_get(_profile_struct, arg1);
        if (!is_array(_verb_alternate_array))
        {
            _verb_alternate_array = array_create(2);
            var _i = 0;
            repeat (2)
            {
                array_set(_verb_alternate_array, _i, input_binding_empty());
                _i++;
            }
            variable_struct_set(_profile_struct, arg1, _verb_alternate_array);
        }
    };
    
    static __add_chord = function(arg0)
    {
        if (is_struct(variable_struct_get(__verb_state_dict, arg0)))
        {
            __input_error("Chord \"", arg0, "\" has already been added to player ", __index);
        }
        else
        {
            var _verb_state_struct = new __input_class_verb_state();
            _verb_state_struct.__player = self;
            _verb_state_struct.name = arg0;
            _verb_state_struct.type = UnknownEnum.Value_1;
            _verb_state_struct.analogue = false;
            variable_struct_set(__verb_state_dict, arg0, _verb_state_struct);
            variable_struct_set(__chord_state_dict, arg0, new __input_class_chord_state(arg0, variable_struct_get(global.__input_chord_verb_dict, arg0)));
        }
    };
    
    static __add_combo = function(arg0)
    {
        if (is_struct(variable_struct_get(__verb_state_dict, arg0)))
        {
            __input_error("Combo \"", arg0, "\" has already been added to this player");
        }
        else
        {
            var _verb_state_struct = new __input_class_verb_state();
            _verb_state_struct.__player = self;
            _verb_state_struct.name = arg0;
            _verb_state_struct.type = UnknownEnum.Value_2;
            _verb_state_struct.analogue = false;
            variable_struct_set(__verb_state_dict, arg0, _verb_state_struct);
            variable_struct_set(__combo_state_dict, arg0, new __input_class_combo_state(arg0, variable_struct_get(global.__input_combo_verb_dict, arg0)));
        }
    };
    
    static __axis_threshold_set = function(arg0, arg1, arg2)
    {
        var _axis_struct = variable_struct_get(__axis_thresholds_dict, arg0);
        if (!is_struct(_axis_struct))
        {
            _axis_struct = {};
            variable_struct_set(__axis_thresholds_dict, arg0, _axis_struct);
        }
        _axis_struct.mini = arg1;
        _axis_struct.maxi = arg2;
        return _axis_struct;
    };
    
    static __axis_threshold_get = function(arg0)
    {
        var _struct = variable_struct_get(__axis_thresholds_dict, arg0);
        if (is_struct(_struct))
        {
            return _struct;
        }
        if (__input_axis_is_directional(arg0))
        {
            return __axis_threshold_set(arg0, 0.3, 0.95);
        }
        else
        {
            return __axis_threshold_set(arg0, 0.02, 1);
        }
    };
    
    static __verb_set = function(arg0, arg1, arg2)
    {
        with (variable_struct_get(__verb_state_dict, arg0))
        {
            force_value = arg1;
            force_analogue = arg2;
        }
    };
    
    static __get_invalid_gamepad_bindings = function(arg0 = undefined)
    {
        var _output = [];
        arg0 = __profile_get(arg0);
        if (arg0 == undefined)
        {
            __input_trace("Warning! Cannot get invaliid bindings, profile was <undefined>");
            return _output;
        }
        var _s = 0;
        repeat (array_length(__source_array))
        {
            var _profile_verb_struct = variable_struct_get(__profiles_dict, arg0);
            if (is_struct(_profile_verb_struct))
            {
                var _gamepad_mapping_array = input_gamepad_get_map(gamepad);
                var _v = 0;
                repeat (array_length(global.__input_basic_verb_array))
                {
                    var _verb_name = global.__input_basic_verb_array[_v];
                    var _alternate_array = variable_struct_get(_profile_verb_struct, _verb_name);
                    var _a = 0;
                    repeat (2)
                    {
                        if (is_struct(_alternate_array[_a]))
                        {
                            var _verb_input = _alternate_array[_a].value;
                            var _found = false;
                            var _m = 0;
                            repeat (array_length(_gamepad_mapping_array))
                            {
                                if (_gamepad_mapping_array[_m] == _verb_input)
                                {
                                    _found = true;
                                    break;
                                }
                                _m++;
                            }
                            if (!_found)
                            {
                                array_push(_output, 
                                {
                                    verb: _verb_name,
                                    alternate: _a,
                                    gm: _verb_input
                                });
                            }
                        }
                        _a++;
                    }
                    _v++;
                }
            }
            _s++;
        }
        return _output;
    };
    
    static __export = function(arg0, arg1)
    {
        var _new_profiles_dict = {};
        var _new_axis_thresholds_dict = {};
        var _root_json = 
        {
            profiles: _new_profiles_dict,
            axis_thresholds: _new_axis_thresholds_dict,
            vibration_strength: __vibration_strength
        };
        var _profile_name_array = variable_struct_get_names(__profiles_dict);
        var _f = 0;
        repeat (array_length(_profile_name_array))
        {
            var _profile_name = _profile_name_array[_f];
            variable_struct_set(_new_profiles_dict, _profile_name, __profile_export(_profile_name_array[_f], false, false));
            _f++;
        }
        var _axis_name_array = variable_struct_get_names(__axis_thresholds_dict);
        var _a = 0;
        repeat (array_length(_axis_name_array))
        {
            var _axis_name = _axis_name_array[_a];
            var _thresholds_struct = variable_struct_get(__axis_thresholds_dict, _axis_name);
            variable_struct_set(_new_axis_thresholds_dict, _axis_name, 
            {
                mini: _thresholds_struct.mini,
                maxi: _thresholds_struct.maxi
            });
            _a++;
        }
        if (arg0)
        {
            if (arg1)
            {
                return __input_snap_to_json(_root_json, true, true);
            }
            else
            {
                return json_stringify(_root_json);
            }
        }
        else
        {
            return _root_json;
        }
    };
    
    static __import = function(arg0)
    {
        var _json;
        if (is_string(arg0))
        {
            _json = json_parse(arg0);
        }
        else
        {
            _json = arg0;
        }
        if (!is_struct(_json) && !is_array(_json))
        {
            __input_error("Input must be valid JSON (typeof=", arg0, ")");
            exit;
        }
        if (!is_struct(struct_get_from_hash(_json, variable_get_hash("profiles"))))
        {
            __input_error("Player ", __index, " profiles are corrupted");
            exit;
        }
        var _profiles_dict = _json.profiles;
        var _profile_name_array = variable_struct_get_names(_profiles_dict);
        var _f = 0;
        repeat (array_length(_profile_name_array))
        {
            var _profile_name = _profile_name_array[_f];
            __profile_import(variable_struct_get(_json.profiles, _profile_name), _profile_name);
            _f++;
        }
        if (!is_struct(struct_get_from_hash(_json, variable_get_hash("axis_thresholds"))))
        {
            __input_error("Player ", __index, " gamepad axis thresholds are corrupted");
            exit;
        }
        var _axis_thresholds_dict = _json.axis_thresholds;
        var _axis_name_array = variable_struct_get_names(_axis_thresholds_dict);
        var _a = 0;
        repeat (array_length(_axis_name_array))
        {
            var _axis_name = _axis_name_array[_a];
            var _new_thresholds_struct = variable_struct_get(_axis_thresholds_dict, _axis_name);
            if (!is_struct(_new_thresholds_struct))
            {
                __input_error("Player ", __index, " gamepad axis thresholds are corrupted");
                exit;
            }
            variable_struct_set(__axis_thresholds_dict, _axis_name, 
            {
                mini: _new_thresholds_struct.mini,
                maxi: _new_thresholds_struct.maxi
            });
            _a++;
        }
        if (variable_struct_exists(_json, "vibration_strength"))
        {
            if (!is_numeric(__vibration_strength))
            {
                __input_error("Player ", __index, " vibration strength is corrupted");
                exit;
            }
            __vibration_strength = 1;
        }
        else
        {
            __input_trace("Warning! Player ", __index, " vibration strength not found, defaulting to ", 1);
            __vibration_strength = 1;
        }
    };
    
    static __reset = function()
    {
        var _profile_name_array = variable_struct_get_names(__profiles_dict);
        var _i = 0;
        repeat (array_length(_profile_name_array))
        {
            var _profile_name = _profile_name_array[_i];
            if (!variable_struct_exists(global.__input_default_profile_dict, _profile_name))
            {
                __profile_destroy(_profile_name);
            }
            else
            {
                __profile_reset_bindings(_profile_name);
            }
            _i++;
        }
        __axis_thresholds_dict = {};
    };
    
    static __vibration_add_event = function(arg0)
    {
        if (__vibration_paused && !arg0.__force)
        {
            __input_trace("Warning! New vibration event ignored, player ", __index, " vibration is paused");
        }
        else
        {
            array_push(__vibration_event_array, arg0);
        }
    };
    
    static tick = function()
    {
        if (__ghost)
        {
            __connected = true;
            __post_disconnection_tick = false;
        }
        else
        {
            __connected = false;
            var _i = 0;
            repeat (array_length(__source_array))
            {
                if (__source_array[_i].__is_connected())
                {
                    __connected = true;
                    __post_disconnection_tick = false;
                    break;
                }
                _i++;
            }
        }
        if (!__post_disconnection_tick)
        {
            if (__rebind_state > 0)
            {
                __tick_binding_scan();
            }
            var _v = 0;
            repeat (array_length(global.__input_all_verb_array))
            {
                variable_struct_get(__verb_state_dict, global.__input_all_verb_array[_v]).__clear();
                _v++;
            }
            __input_player_tick_sources();
            tick_basic_verbs();
            tick_chord_verbs();
            tick_combo_verbs();
            __cursor.__tick();
            __tick_vibration();
            if (!__connected)
            {
                __post_disconnection_tick = true;
            }
        }
    };
    
    static tick_basic_verbs = function()
    {
        var _v = 0;
        repeat (array_length(global.__input_basic_verb_array))
        {
            variable_struct_get(__verb_state_dict, global.__input_basic_verb_array[_v]).tick(__verb_group_state_dict);
            _v++;
        }
    };
    
    static tick_chord_verbs = function()
    {
        var _i = 0;
        repeat (array_length(global.__input_chord_verb_array))
        {
            var _chord_name = global.__input_chord_verb_array[_i];
            if (variable_struct_get(__chord_state_dict, _chord_name).__evaluate(__verb_state_dict))
            {
                with (variable_struct_get(__verb_state_dict, _chord_name))
                {
                    value = 1;
                    raw = 1;
                    tick();
                }
            }
            else
            {
                variable_struct_get(__verb_state_dict, _chord_name).tick();
            }
            _i++;
        }
    };
    
    static tick_combo_verbs = function()
    {
        var _i = 0;
        repeat (array_length(global.__input_combo_verb_array))
        {
            var _combo_name = global.__input_combo_verb_array[_i];
            if (variable_struct_get(__combo_state_dict, _combo_name).__tick(__verb_state_dict) == UnknownEnum.Value_1)
            {
                with (variable_struct_get(__verb_state_dict, _combo_name))
                {
                    value = 1;
                    raw = 1;
                    tick();
                }
            }
            else
            {
                variable_struct_get(__verb_state_dict, _combo_name).tick();
            }
            _i++;
        }
    };
    
    static __tick_vibration = function()
    {
        if (__connected && global.__input_source_mode != UnknownEnum.Value_4)
        {
            var _gamepad_index = __source_get_gamepad();
            if (_gamepad_index < 0)
            {
                exit;
            }
            var _not_paused = !__vibration_paused;
            var _left = 0;
            var _right = 0;
            var _time_step = __input_get_time() - __input_get_previous_time();
            var _array = __vibration_event_array;
            var _i = 0;
            repeat (array_length(_array))
            {
                var _result;
                with (_array[_i])
                {
                    if (_not_paused || __force)
                    {
                        _result = __tick(_time_step);
                        _left += __output_left;
                        _right += __output_right;
                    }
                    else
                    {
                        _result = true;
                    }
                }
                if (_result)
                {
                    _i++;
                }
                else
                {
                    array_delete(_array, _i, 1);
                }
            }
            global.__input_gamepads[_gamepad_index].__vibration_set(__vibration_strength * _left, __vibration_strength * _right);
        }
    };
    
    static __tick_binding_scan = function()
    {
        if (array_length(__rebind_source_filter) <= 0)
        {
            __input_trace("Binding scan failed: Source array for player ", __index, " is empty (the player has no source assigned)");
            __binding_scan_failure(UnknownEnum.Value_m10);
            exit;
        }
        if (__ghost)
        {
            __input_trace("Binding scan failed: Player ", __index, " is a ghost");
            __binding_scan_failure(UnknownEnum.Value_m15);
            exit;
        }
        if (!__connected)
        {
            __input_trace("Binding scan failed: Player ", __index, " disconnected");
            __binding_scan_failure(UnknownEnum.Value_m16);
            exit;
        }
        if ((global.__input_current_time - __rebind_start_time) > 10000)
        {
            __input_trace("Binding scan failed: Timed out");
            __binding_scan_failure(UnknownEnum.Value_m20);
            exit;
        }
        if (__rebind_state == 1)
        {
            if (!__sources_any_input())
            {
                __input_trace("Now scanning for a new binding from player ", __index);
                __rebind_state = 2;
            }
        }
        else if (__rebind_state == 2)
        {
            var _new_binding = undefined;
            var _binding_source = undefined;
            var _i = 0;
            repeat (array_length(__rebind_source_filter))
            {
                if (instanceof(__rebind_source_filter[_i]) != "__input_class_source")
                {
                    __input_error("Value in filter array is not a source (index ", _i, ", ", __rebind_source_filter[_i], ")");
                }
                var _source_binding = __rebind_source_filter[_i].__scan_for_binding(__index, false, __rebind_ignore_struct, __rebind_allow_struct);
                if (_source_binding != undefined)
                {
                    _new_binding = _source_binding;
                    _binding_source = __rebind_source_filter[_i];
                }
                _i++;
            }
            if (input_value_is_binding(_new_binding))
            {
                __binding_scan_success(_new_binding);
            }
        }
    };
    
    static __binding_scan_success = function(arg0)
    {
        __input_trace("Binding found for player ", __index, ": \"", arg0, "\"");
        __rebind_state = 0;
        if (is_method(__rebind_success_callback))
        {
            __rebind_success_callback(arg0);
        }
        else if (is_numeric(__rebind_success_callback) && script_exists(__rebind_success_callback))
        {
            script_execute(__rebind_success_callback, arg0);
        }
        else if (__rebind_success_callback != undefined)
        {
            __input_error("Binding scan success callback set to an illegal value (typeof=", typeof(__rebind_success_callback), ")");
        }
    };
    
    static __binding_scan_failure = function(arg0)
    {
        __input_trace("Binding scan for player ", __index, " failed (error=", arg0, ")");
        __rebind_state = 0;
        if (is_method(__rebind_failure_callback))
        {
            __rebind_failure_callback(arg0);
        }
        else if (is_numeric(__rebind_failure_callback) && script_exists(__rebind_failure_callback))
        {
            script_execute(__rebind_failure_callback, arg0);
        }
        else if (__rebind_failure_callback != undefined)
        {
            __input_error("Binding scan failure callback set to an illegal value (typeof=", typeof(__rebind_failure_callback), ")");
        }
    };
    
    __index = undefined;
    __source_array = [];
    __verb_state_dict = {};
    __chord_state_dict = {};
    __combo_state_dict = {};
    __last_input_time = -infinity;
    __verb_group_state_dict = {};
    __vibration_paused = false;
    __vibration_strength = 1;
    __vibration_event_array = [];
    __rebind_state = 0;
    __rebind_start_time = global.__input_current_time;
    __rebind_success_callback = undefined;
    __rebind_failure_callback = undefined;
    __rebind_source_filter = [];
    __rebind_ignore_struct = undefined;
    __rebind_allow_struct = undefined;
    __axis_thresholds_dict = {};
    __profiles_dict = {};
    __profile_name = undefined;
    __ghost = false;
    __connected = false;
    __post_disconnection_tick = false;
    __cursor = new __input_class_cursor();
    __cursor.__player = self;
}

enum UnknownEnum
{
    Value_m20 = -20,
    Value_m16 = -16,
    Value_m15,
    Value_m11 = -11,
    Value_m10,
    Value_0 = 0,
    Value_1,
    Value_2,
    Value_4 = 4
}
