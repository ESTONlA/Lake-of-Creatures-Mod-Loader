function __input_axis_is_directional(arg0)
{
    return arg0 == 32781 || arg0 == 32782 || arg0 == 32783 || arg0 == 32784 || arg0 == 32785 || arg0 == 32786 || arg0 == 32787 || arg0 == 32788;
}

function __input_gamepad_guid_parse(arg0, arg1, arg2)
{
    var _vendor = "";
    var _product = "";
    if (arg0 == "00000000000000000000000000000000")
    {
        if (!arg2)
        {
            __input_trace("Warning! GUID was empty");
        }
        return 
        {
            vendor: "",
            product: ""
        };
    }
    if (arg1)
    {
        _vendor = string_copy(arg0, 1, 4);
        _product = string_copy(arg0, 5, 4);
    }
    else
    {
        if (string_copy(arg0, 5, 4) != "0000" || string_copy(arg0, 13, 4) != "0000" || string_copy(arg0, 21, 4) != "0000")
        {
            if (!arg2)
            {
                __input_trace("Warning! GUID \"", arg0, "\" does not fit expected pattern. VID+PID cannot be extracted");
            }
            return 
            {
                vendor: "",
                product: ""
            };
        }
        if (string_copy(arg0, 1, 4) != "0300" && string_copy(arg0, 1, 4) != "0500")
        {
            if (!arg2)
            {
                __input_trace("Warning! GUID \"", arg0, "\" driver ID does not match expected (Found ", string_copy(arg0, 1, 4), ", expect either 0300 or 0500)");
            }
        }
        _vendor = string_copy(arg0, 9, 4);
        _product = string_copy(arg0, 17, 4);
    }
    return 
    {
        vendor: _vendor,
        product: _product
    };
}

function __input_trace()
{
    var _string = "";
    var _i = 0;
    repeat (argument_count)
    {
        _string += string(argument[_i]);
        _i++;
    }
    show_debug_message("Input: " + _string);
}

function __input_trace_loud()
{
    var _string = "";
    var _i = 0;
    repeat (argument_count)
    {
        _string += string(argument[_i]);
        _i++;
    }
    show_debug_message("Input: LOUD " + _string);
    show_message(_string);
}

function __input_error()
{
    var _string = "";
    var _i = 0;
    repeat (argument_count)
    {
        _string += string(argument[_i]);
        _i++;
    }
    show_error("Input 5.2.0 beta 3:\n" + _string + "\n ", false);
}

function __input_ensure_unique_verb_name(arg0)
{
    if (variable_struct_exists(global.__input_basic_verb_dict, arg0))
    {
        __input_error("A basic verb named \"", arg0, "\" already exists");
        exit;
    }
    if (variable_struct_exists(global.__input_chord_verb_dict, arg0))
    {
        __input_error("A chord named \"", arg0, "\" already exists");
        exit;
    }
    if (variable_struct_exists(global.__input_combo_verb_dict, arg0))
    {
        __input_error("A combo named \"", arg0, "\" already exists");
        exit;
    }
}

function __input_get_previous_time()
{
    return global.__input_frame - 1;
}

function __input_get_time()
{
    return global.__input_frame;
}
