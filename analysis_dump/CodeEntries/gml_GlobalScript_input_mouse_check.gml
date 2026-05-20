function input_mouse_check(arg0)
{
    if (!global.__input_mouse_allowed_on_platform || global.__input_window_focus_block_mouse)
    {
        return arg0 == 0;
    }
    var _button = device_mouse_check_button(0, arg0);
    switch (arg0)
    {
        case -1:
        case 1:
            return _button || global.__input_tap_click;
            break;
        case 0:
            return _button && !global.__input_tap_click;
            break;
        default:
            return _button;
            break;
    }
    __input_error("Mouse button out of range (", arg0, ")");
    return false;
}
