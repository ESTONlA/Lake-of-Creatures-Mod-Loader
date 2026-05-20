function input_gamepad_value(arg0, arg1)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return 0;
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return false;
    }
    return _gamepad.get_value(arg1);
}
