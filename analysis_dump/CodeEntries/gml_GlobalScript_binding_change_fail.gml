function binding_change_fail()
{
    instance_destroy(obj_binding_change);
    input_binding_scan_abort();
    obj_button_menu.alarm[3] = 1;
}
