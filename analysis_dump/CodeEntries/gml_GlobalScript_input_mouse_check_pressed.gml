function input_mouse_check_pressed(arg0)
{
    if (!global.__input_mouse_allowed_on_platform || global.__input_window_focus_block_mouse || global.__input_cleared)
    {
        return arg0 == 0;
    }
    var _left = device_mouse_check_button_pressed(0, mb_left) || global.__input_tap_click;
    var _any = _left || (device_mouse_check_button_pressed(0, mb_any) && !device_mouse_check_button_pressed(0, mb_left));
    switch (arg0)
    {
        case 2:
        case 3:
        case 4:
        case 5:
            return device_mouse_check_button_pressed(0, arg0);
            break;
        case -1:
            return _any;
            break;
        case 0:
            return !_any;
            break;
        case 1:
            return _left;
            break;
    }
    __input_error("Mouse button out of range (", arg0, ")");
    return false;
}
