function input_binding_scan_set_params(arg0, arg1, arg2 = 0)
{
    __input_initialize();
    if (arg2 < 0)
    {
        __input_error("Invalid player index provided (", arg2, ")");
        return undefined;
    }
    if (arg2 >= 4)
    {
        __input_error("Player index too large (", arg2, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    if (!is_array(arg1) && arg1 != undefined)
    {
        arg1 = [arg1];
    }
    if (!is_array(arg0) && arg0 != undefined)
    {
        arg0 = [arg0];
    }
    var _ignore_struct = undefined;
    var _allow_struct = undefined;
    if (is_array(arg0))
    {
        _ignore_struct = {};
        var _i = 0;
        repeat (array_length(arg0))
        {
            var _value = arg0[_i];
            if (is_string(_value) && _value != "mouse wheel up" && _value != "mouse wheel down")
            {
                _value = ord(_value);
            }
            variable_struct_set(_ignore_struct, string(_value), true);
            _i++;
        }
    }
    if (is_array(arg1))
    {
        _allow_struct = {};
        var _i = 0;
        repeat (array_length(arg1))
        {
            var _value = arg1[_i];
            if (is_string(_value) && _value != "mouse wheel up" && _value != "mouse wheel down")
            {
                _value = ord(_value);
            }
            variable_struct_set(_allow_struct, string(_value), true);
            _i++;
        }
    }
    with (global.__input_players[arg2])
    {
        __rebind_ignore_struct = _ignore_struct;
        __rebind_allow_struct = _allow_struct;
    }
}
