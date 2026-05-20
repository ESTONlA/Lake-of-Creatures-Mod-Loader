function binding_changes(arg0)
{
    input_binding_set_safe(global.binding_change_verb, arg0);
    instance_destroy(obj_binding_change);
    obj_button_menu.alarm[3] = 1;
}
