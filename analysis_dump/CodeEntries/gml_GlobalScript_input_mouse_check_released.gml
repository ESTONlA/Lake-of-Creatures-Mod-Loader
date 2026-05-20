function input_mouse_check_released(arg0)
{
    if (!global.__input_mouse_allowed_on_platform || global.__input_cleared)
    {
        return false;
    }
    return device_mouse_check_button_released(0, arg0);
}
