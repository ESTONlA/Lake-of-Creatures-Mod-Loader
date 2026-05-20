function input_icons(arg0)
{
    __input_initialize();
    var _icon_holder = variable_struct_get(global.__input_icons, arg0);
    if (!is_struct(_icon_holder))
    {
        _icon_holder = new __input_class_icon_category(arg0);
        variable_struct_set(global.__input_icons, string(arg0), _icon_holder);
    }
    return _icon_holder;
}
