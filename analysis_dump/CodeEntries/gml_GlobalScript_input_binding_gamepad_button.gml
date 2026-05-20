function input_binding_gamepad_button(arg0)
{
    __input_initialize();
    if (0 && (arg0 >= 32889 && arg0 <= 32895))
    {
        __input_error("Extended gamepad binding not permitted\nSet INPUT_SDL2_ALLOW_EXTENDED to <true> to allow binding of extended buttons.");
    }
    else if (false && arg0 == 32891)
    {
        arg0 = 32777;
    }
    return new __input_class_binding().__set_gamepad_button(arg0);
}
