function __input_class_binding() constructor
{
    static __source_type_get = function()
    {
        switch (type)
        {
            case "key":
                return global.__input_source_keyboard;
                break;
            case "mouse button":
                return global.__input_source_mouse;
                break;
            case "mouse wheel up":
                return global.__input_source_mouse;
                break;
            case "gamepad button":
                return global.__input_source_gamepad;
                break;
            case "gamepad axis":
                return global.__input_source_gamepad;
                break;
            case undefined:
                __input_trace("Warning! Binding type has not been defined");
                return undefined;
                break;
            default:
                __input_error("Unhandled binding type \"", type, "\"");
                break;
        }
    };
    
    static __gamepad_set = function(arg0)
    {
        if (input_gamepad_is_connected(arg0))
        {
            __gamepad_index = arg0;
            __gamepad_description = gamepad_get_description(arg0);
        }
        return self;
    };
    
    static __gamepad_get = function()
    {
        return __gamepad_index;
    };
    
    static __threshold_set = function(arg0, arg1)
    {
        __threshold_min = arg0;
        __threshold_max = arg1;
        return self;
    };
    
    static __threshold_get = function()
    {
        return 
        {
            mini: __threshold_min,
            maxi: __threshold_max
        };
    };
    
    static __export = function()
    {
        var _binding_shell = {};
        if (type != undefined)
        {
            _binding_shell.type = type;
        }
        if (value != undefined)
        {
            _binding_shell.value = value;
        }
        if (axis_negative != undefined)
        {
            _binding_shell.axis_negative = axis_negative;
        }
        if (__gamepad_description != undefined)
        {
            _binding_shell.gamepad_description = __gamepad_description;
        }
        if (__threshold_min != undefined)
        {
            _binding_shell.threshold_min = __threshold_min;
        }
        if (__threshold_max != undefined)
        {
            _binding_shell.threshold_max = __threshold_max;
        }
        return _binding_shell;
    };
    
    static __import = function(arg0)
    {
        if (!is_struct(arg0))
        {
            __input_trace("Warning! Could not import binding, clearing this binding (typeof=", typeof(arg0), ")");
            arg0 = {};
        }
        if (variable_struct_names_count(arg0) <= 0)
        {
            __set_empty();
            exit;
        }
        if (!variable_struct_exists(arg0, "type"))
        {
            __input_error("Binding \"type\" not found; binding is corrupted");
            exit;
        }
        if (!variable_struct_exists(arg0, "value") && arg0.type != "mouse wheel up" && arg0.type != "mouse wheel down")
        {
            __input_error("Binding \"value\" not found; binding is corrupted");
            exit;
        }
        if (arg0.type == "gamepad axis" && !variable_struct_exists(arg0, "axis_negative"))
        {
            __input_error("Binding \"axis_negative\" not found; binding is corrupted");
            exit;
        }
        var _value = struct_get_from_hash(arg0, variable_get_hash("value"));
        if (arg0.type == "gamepad axis" || arg0.type == "gamepad button")
        {
            switch (_value)
            {
                case 32789:
                    _value = 32889;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32790:
                    _value = 32890;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32791:
                    _value = 32891;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32792:
                    _value = 32892;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32793:
                    _value = 32893;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32794:
                    _value = 32894;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
                case 32795:
                    _value = 32895;
                    __input_trace("Warning! Legacy gamepad constant found, updating value (= ", _value, ")");
                    break;
            }
        }
        type = arg0.type;
        value = _value;
        axis_negative = struct_get_from_hash(arg0, variable_get_hash("axis_negative"));
        __gamepad_description = struct_get_from_hash(arg0, variable_get_hash("gamepad_description"));
        __threshold_min = struct_get_from_hash(arg0, variable_get_hash("threshold_min"));
        __threshold_max = struct_get_from_hash(arg0, variable_get_hash("threshold_max"));
        if (__gamepad_description != undefined)
        {
            var _g = 0;
            repeat (array_length(global.__input_gamepads))
            {
                var _gamepad = global.__input_gamepads[_g];
                if (is_struct(_gamepad) && _gamepad.description == __gamepad_description)
                {
                    __gamepad_index = _g;
                    break;
                }
                _g++;
            }
        }
        __set_android_lowercase();
        __set_label();
    };
    
    static __set_android_lowercase = function()
    {
        if (false && type == "key")
        {
            value = ord(string_upper(chr(value)));
            var _android_lowercase = ord(string_lower(chr(value)));
            __android_lowercase = (_android_lowercase != value) ? _android_lowercase : undefined;
            if (value == 10 || value == 13)
            {
                value = 10;
                __android_lowercase = 13;
            }
        }
    };
    
    static __duplicate = function()
    {
        with (new __input_class_binding())
        {
            type = other.type;
            value = other.value;
            axis_negative = other.axis_negative;
            __label = other.__label;
            __gamepad_index = other.__gamepad_index;
            __gamepad_description = other.__gamepad_description;
            __android_lowercase = other.__android_lowercase;
            __threshold_min = other.__threshold_min;
            __threshold_max = other.__threshold_max;
            return self;
        }
    };
    
    static __set_empty = function()
    {
        type = undefined;
        value = undefined;
        axis_negative = undefined;
        __label = "empty binding";
        __gamepad_index = undefined;
        __gamepad_description = undefined;
        __android_lowercase = undefined;
        __threshold_min = undefined;
        __threshold_max = undefined;
        return self;
    };
    
    static __set_key = function(arg0, arg1)
    {
        if (is_string(arg0))
        {
            arg0 = ord(string_upper(arg0));
        }
        if (arg1)
        {
        }
        else
        {
        }
        type = "key";
        value = arg0;
        __set_android_lowercase();
        __set_label();
        return self;
    };
    
    static __set_gamepad_axis = function(arg0, arg1)
    {
        type = "gamepad axis";
        value = arg0;
        axis_negative = arg1;
        __set_label();
        return self;
    };
    
    static __set_gamepad_button = function(arg0)
    {
        type = "gamepad button";
        value = arg0;
        __set_label();
        return self;
    };
    
    static __set_mouse_button = function(arg0)
    {
        if (arg0 == 0)
        {
            __input_error("Cannot use mb_none as a mouse button binding\nInstead please use mb_any and then invert the result");
        }
        type = "mouse button";
        value = arg0;
        __set_label();
        return self;
    };
    
    static __set_mouse_wheel_down = function()
    {
        type = "mouse wheel down";
        __set_label();
        return self;
    };
    
    static __set_mouse_wheel_up = function()
    {
        type = "mouse wheel up";
        __set_label();
        return self;
    };
    
    static __set_label = function(arg0)
    {
        if (arg0 == undefined)
        {
            __label = __input_binding_get_label(type, value, axis_negative);
        }
        else
        {
            __label = arg0;
        }
        return self;
    };
    
    static __get_source_type = function()
    {
        switch (type)
        {
            case "key":
                return UnknownEnum.Value_0;
                break;
            case "mouse button":
                return UnknownEnum.Value_1;
                break;
            case "mouse wheel up":
                return UnknownEnum.Value_1;
                break;
            case "mouse wheel down":
                return UnknownEnum.Value_1;
                break;
            case "gamepad button":
                return UnknownEnum.Value_2;
                break;
            case "gamepad axis":
                return UnknownEnum.Value_2;
                break;
            case undefined:
                return undefined;
                break;
        }
        __input_error("Binding type \"", type, "\" not recognised");
    };
    
    __set_empty();
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2
}
