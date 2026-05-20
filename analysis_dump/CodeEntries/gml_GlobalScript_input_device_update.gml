function input_device_update()
{
    if (input_source_using(global.__input_source_keyboard) == 0)
    {
        if (global.gamepad_enabled == false || !instance_exists(obj_navigator))
        {
            navigation_style_change(2);
            global.gamepad_enabled = true;
        }
    }
    else if (global.gamepad_enabled == true || instance_exists(obj_navigator))
    {
        navigation_style_change(1);
        global.gamepad_enabled = false;
    }
}
