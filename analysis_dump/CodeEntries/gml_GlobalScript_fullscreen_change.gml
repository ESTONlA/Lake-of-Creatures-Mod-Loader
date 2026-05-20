function fullscreen_change()
{
    var fullscreen_state = window_get_fullscreen();
    if (fullscreen_state == 1)
    {
        window_set_fullscreen(0);
        global.fullscreen = false;
    }
    else
    {
        window_set_fullscreen(1);
        global.fullscreen = true;
    }
    if (instance_exists(obj_ctrl_options_menu))
    {
        obj_ctrl_options_menu.alarm[2] = 10;
    }
    else
    {
        instance_create_depth(0, 0, 0, obj_screen_center);
    }
}
