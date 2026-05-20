function input_gamepad_is_connected(arg0)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return false;
    }
    if (!is_struct(global.__input_gamepads[arg0]))
    {
        return false;
    }
    return gamepad_is_connected(arg0);
}
