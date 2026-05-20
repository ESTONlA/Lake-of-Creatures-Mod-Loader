function force_fullscreen()
{
    var lost_focus = false;
    if (!window_has_focus())
    {
        lost_focus = true;
    }
    else if (lost_focus == true)
    {
        lost_focus = false;
        if (global.fullscreen == true)
        {
            window_set_fullscreen(false);
            window_set_fullscreen(true);
            if (instance_exists(obj_ctrl_options_menu))
            {
                obj_ctrl_options_menu.alarm[2] = 10;
            }
            else
            {
                instance_create_depth(0, 0, 0, obj_screen_center);
            }
        }
    }
}
