function input_gamepad_is_axis(arg0, arg1)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return false;
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return false;
    }
    return _gamepad.is_axis(arg1);
}
