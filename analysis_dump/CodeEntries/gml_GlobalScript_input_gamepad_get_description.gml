function input_gamepad_get_description(arg0)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return "Unknown";
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return "Unknown";
    }
    return _gamepad.description;
}
