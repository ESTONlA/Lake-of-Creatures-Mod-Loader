function input_keyboard_check_released(arg0)
{
    if (!global.__input_keyboard_allowed || global.__input_cleared)
    {
        return false;
    }
    return keyboard_check_released(arg0);
}
