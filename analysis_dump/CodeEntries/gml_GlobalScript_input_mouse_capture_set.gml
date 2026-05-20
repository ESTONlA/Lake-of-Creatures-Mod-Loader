function input_mouse_capture_set(arg0, arg1 = 1)
{
    __input_initialize();
    if (arg0 && !global.__input_mouse_capture)
    {
        global.__input_mouse_capture_frame = global.__input_frame;
    }
    global.__input_mouse_capture = arg0;
    global.__input_mouse_capture_sensitivity = arg1;
    __input_release_multimonitor_cursor();
}
