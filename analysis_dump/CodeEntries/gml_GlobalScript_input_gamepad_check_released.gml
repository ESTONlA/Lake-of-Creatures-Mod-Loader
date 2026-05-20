function input_gamepad_check_released(arg0, arg1)
{
    if (global.__input_cleared || arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return false;
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return false;
    }
    return _gamepad.get_released(arg1);
}
