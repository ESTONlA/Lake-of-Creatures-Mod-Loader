function input_binding_gamepad_axis(arg0, arg1)
{
    __input_initialize();
    return new __input_class_binding().__set_gamepad_axis(arg0, arg1);
}
