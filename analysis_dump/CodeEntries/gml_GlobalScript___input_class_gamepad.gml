function __input_class_gamepad(arg0) constructor
{
    static discover = function()
    {
        if (custom_mapping)
        {
            custom_mapping = false;
            __input_trace("Warning! Resetting Input's mapping for gamepad ", index);
            mapping_gm_to_raw = {};
            mapping_raw_to_gm = {};
            mapping_array = [];
        }
        button_count = gamepad_button_count(index);
        axis_count = gamepad_axis_count(index);
        hat_count = gamepad_hat_count(index);
        __input_gamepad_set_vid_pid();
        __input_gamepad_set_description();
        __input_gamepad_find_in_sdl2_database();
        __input_gamepad_set_type();
        __input_gamepad_set_blacklist();
        __input_gamepad_set_mapping();
        __vibration_support = global.__input_vibration_allowed_on_platform && (false || xinput);
        if (__vibration_support)
        {
            gamepad_set_vibration(index, 0, 0);
        }
        __input_trace("Gamepad ", index, " discovered, type = \"", simple_type, "\" (", raw_type, ", guessed=", guessed_type, "), description = \"", description, "\" (vendor=", vendor, ", product=", product, ")");
    };
    
    static get_held = function(arg0)
    {
        if (!custom_mapping)
        {
            return gamepad_button_check(index, arg0);
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return false;
        }
        return _mapping.held;
    };
    
    static get_pressed = function(arg0)
    {
        if (!custom_mapping)
        {
            return gamepad_button_check_pressed(index, arg0);
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return false;
        }
        return _mapping.press;
    };
    
    static get_released = function(arg0)
    {
        if (!custom_mapping)
        {
            return gamepad_button_check_released(index, arg0);
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return false;
        }
        return _mapping.release;
    };
    
    static get_value = function(arg0)
    {
        if (!custom_mapping)
        {
            if (arg0 == 32785 || arg0 == 32786 || arg0 == 32787 || arg0 == 32788)
            {
                return gamepad_axis_value(index, arg0);
            }
            else
            {
                return gamepad_button_check(index, arg0);
            }
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return 0;
        }
        return _mapping.value;
    };
    
    static get_delta = function(arg0)
    {
        if (!custom_mapping)
        {
            return get_value(arg0);
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return 0;
        }
        return _mapping.__value_delta;
    };
    
    static is_axis = function(arg0)
    {
        if (!custom_mapping)
        {
            if (arg0 == 32775 || arg0 == 32776)
            {
                return xinput || false || false || false;
            }
            return arg0 == 32785 || arg0 == 32786 || arg0 == 32787 || arg0 == 32788;
        }
        var _mapping = variable_struct_get(mapping_gm_to_raw, arg0);
        if (_mapping == undefined)
        {
            return false;
        }
        return _mapping.type == UnknownEnum.Value_1;
    };
    
    static set_mapping = function(arg0, arg1, arg2, arg3)
    {
        if (!custom_mapping)
        {
            custom_mapping = true;
            __input_trace("Gamepad ", index, " has a custom mapping, clearing GameMaker's native mapping string");
            gamepad_remove_mapping(index);
        }
        if (mac_cleared_mapping && false)
        {
            if (arg2 == UnknownEnum.Value_1)
            {
                arg1 += 6;
            }
            if (arg2 == UnknownEnum.Value_0)
            {
                arg1 += 17;
            }
        }
        var _mapping = new __input_class_gamepad_mapping(arg0, arg1, arg2, arg3);
        variable_struct_set(mapping_gm_to_raw, arg0, _mapping);
        if (arg1 != undefined)
        {
            variable_struct_set(mapping_raw_to_gm, arg1, _mapping);
        }
        array_push(mapping_array, _mapping);
        return _mapping;
    };
    
    static tick = function(arg0 = false)
    {
        var _scan = current_time > __scan_start_time;
        var _gamepad = index;
        var _i = 0;
        repeat (array_length(mapping_array))
        {
            with (mapping_array[_i])
            {
                tick(_gamepad, arg0, _scan);
            }
            _i++;
        }
        if (__vibration_support)
        {
            if (__vibration_received_this_frame && input_window_has_focus())
            {
                gamepad_set_vibration(index, __vibration_left, __vibration_right);
            }
            else
            {
                gamepad_set_vibration(index, 0, 0);
            }
            __vibration_received_this_frame = false;
        }
    };
    
    static __vibration_set = function(arg0, arg1)
    {
        __vibration_left = arg0;
        __vibration_right = arg1;
        __vibration_received_this_frame = true;
    };
    
    index = arg0;
    description = gamepad_get_description(arg0);
    guid = gamepad_get_guid(arg0);
    xinput = undefined;
    raw_type = undefined;
    simple_type = undefined;
    sdl2_definition = undefined;
    guessed_type = false;
    blacklisted = false;
    vendor = undefined;
    product = undefined;
    custom_mapping = false;
    mac_cleared_mapping = false;
    button_count = undefined;
    axis_count = undefined;
    hat_count = undefined;
    __vibration_support = false;
    __vibration_left = 0;
    __vibration_right = 0;
    __vibration_received_this_frame = false;
    mapping_gm_to_raw = {};
    mapping_raw_to_gm = {};
    mapping_array = [];
    __connection_time = current_time;
    __scan_start_time = __connection_time + 250;
    discover();
}

enum UnknownEnum
{
    Value_0,
    Value_1
}
