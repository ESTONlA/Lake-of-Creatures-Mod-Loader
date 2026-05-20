function __input_mouse_button()
{
    if (!global.__input_mouse_allowed_on_platform || global.__input_window_focus_block_mouse)
    {
        return 0;
    }
    return mouse_button ? mouse_button : global.__input_tap_click;
}
