function input_window_has_focus()
{
    return global.__input_window_focus && !os_is_paused();
}
