function input_gamepad_get_type(arg0)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return "unknown";
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return "unknown";
    }
    return _gamepad.simple_type;
}
