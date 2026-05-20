function input_binding_get_icon(arg0, arg1 = 0)
{
    if (!input_value_is_binding(arg0))
    {
        _category_data = variable_struct_get(global.__input_icons, "not a binding");
        if (!is_struct(_category_data))
        {
            return "not a binding";
        }
        _icon = variable_struct_get(_category_data.__dictionary, "-3");
        return _icon ?? "not a binding";
    }
    var _fallback_category_data = variable_struct_get(global.__input_icons, "gamepad fallback");
    var _fallback_icon_struct;
    if (is_struct(_fallback_category_data))
    {
        _fallback_icon_struct = _fallback_category_data.__dictionary;
    }
    else
    {
        __input_trace("Warning! \"gamepad fallback\" icon data not found");
        _fallback_icon_struct = {};
    }
    var _type = arg0.type;
    var _label = arg0.__label;
    if (_type == undefined || _label == undefined)
    {
        _category_data = struct_get_from_hash(global.__input_icons, variable_get_hash("unknown"));
        if (!is_struct(_category_data))
        {
            return "unknown";
        }
        _icon = variable_struct_get(_category_data.__dictionary, "-3");
        return _icon ?? "unknown";
    }
    var _category;
    switch (_type)
    {
        case "key":
        case "mouse button":
        case "mouse wheel up":
        case "mouse wheel down":
            _category = "keyboard and mouse";
            break;
        case "gamepad button":
        case "gamepad axis":
            _category = input_player_get_gamepad_type(arg1, arg0);
            break;
        default:
            __input_error("\"", _type, "\" unsupported");
            break;
    }
    var _category_data = variable_struct_get(global.__input_icons, _category);
    var _icon_struct;
    if (is_struct(_category_data))
    {
        _icon_struct = _category_data.__dictionary;
    }
    else
    {
        __input_trace("Warning! \"", _category, "\" icon data not found");
        _icon_struct = _fallback_icon_struct;
    }
    var _icon = is_struct(_icon_struct) ? variable_struct_get(_icon_struct, _label) : undefined;
    if (_category == "keyboard and mouse")
    {
        return _icon ?? _label;
    }
    if (_icon == undefined)
    {
        __input_trace("Warning! Could not find valid icon for \"", _label, "\" using gamepad type \"", _category, "\"" + ((_category == "unknown") ? (" (player " + string(arg1) + " may not have a recognised gamepad assigned)") : ""));
        _icon = is_struct(_fallback_icon_struct) ? variable_struct_get(_fallback_icon_struct, _label) : undefined;
        if (_icon == undefined)
        {
            __input_trace("Warning! Could not find valid icon for \"", _label, "\" using \"gamepad fallback\"");
            _icon = _label;
        }
    }
    return _icon;
}
