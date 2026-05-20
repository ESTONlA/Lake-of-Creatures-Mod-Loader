function alert_text_set(arg0)
{
    global.alert_text_active = true;
    global.alert_text_alpha = 0;
    global.alert_text_yy = 0;
    global.alert_text_string = string(arg0);
    obj_ctrl.alarm[5] = 300;
}
