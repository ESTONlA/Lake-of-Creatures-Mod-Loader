function __input_gamepad_set_blacklist()
{
    if (axis_count == 0 && button_count == 0 && hat_count == 0)
    {
        __input_trace("Warning! Controller ", index, " (VID+PID \"", vendor + product, "\") blacklisted: no button or axis");
        blacklisted = true;
        exit;
    }
    if (vendor == "7e05" && product == "0920" && button_count == 23)
    {
        __input_trace("Warning! Controller is blacklisted (Switch Pro Controller over USB)");
        blacklisted = true;
        exit;
    }
    if ((vendor == "4c05" && product == "6802") && ((axis_count == 4 && button_count == 19) || (axis_count == 8 && button_count == 0)))
    {
        __input_trace("Warning! Controller is blacklisted (Incorrectly configured PS3 controller)");
        blacklisted = true;
        exit;
    }
    if (vendor != "de28" && variable_struct_exists(global.__input_ignore_gamepad_types, simple_type))
    {
        __input_trace("Warning! Controller type is blacklisted by Steam Input (\"", simple_type, "\")");
        blacklisted = true;
        exit;
    }
    var _os = undefined;
    switch (0)
    {
        case 0:
            _os = "windows";
            break;
        case 6:
            _os = "linux";
            break;
        case 1:
            _os = "macos";
            break;
        case 4:
            _os = "android";
            break;
        default:
            __input_error("OS not supported");
            break;
    }
    var _os_filter_dict = variable_struct_get(global.__input_blacklist_dictionary, _os);
    var _os_guid_dict = is_struct(_os_filter_dict) ? struct_get_from_hash(_os_filter_dict, variable_get_hash("guid")) : undefined;
    var _os_desc_array = is_struct(_os_filter_dict) ? variable_struct_get(_os_filter_dict, "description contains") : undefined;
    if (is_struct(_os_guid_dict) && variable_struct_exists(_os_guid_dict, guid))
    {
        __input_trace("Warning! Controller is blacklisted (found by GUID \"", guid, "\")");
        blacklisted = true;
        exit;
    }
    else if (is_array(_os_desc_array))
    {
        var _description_lower = string_replace_all(string_lower(gamepad_get_description(index)), " ", "");
        var _i = 0;
        repeat (array_length(_os_desc_array))
        {
            if (string_pos(_os_desc_array[_i], _description_lower) > 0)
            {
                __input_trace("Warning! Controller is blacklisted (banned substring \"", _os_desc_array[_i], "\" found in description)");
                blacklisted = true;
                exit;
            }
            _i++;
        }
    }
}
