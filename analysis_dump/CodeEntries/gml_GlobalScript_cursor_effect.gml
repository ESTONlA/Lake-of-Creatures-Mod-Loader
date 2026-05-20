function cursor_effect(arg0, arg1, arg2)
{
    if (room == rm_menu_main)
    {
        obj_ctrl_main_menu.cursor_xscale_ext = arg0;
        obj_ctrl_main_menu.cursor_xscale_ext = arg1;
        obj_ctrl_main_menu.cursor_angle_ext = arg2;
        obj_ctrl_main_menu.alarm[1] = 1;
    }
    else
    {
        if (instance_exists(obj_pause))
        {
            obj_pause.cursor_xscale_ext = arg0;
            obj_pause.cursor_xscale_ext = arg1;
            obj_pause.cursor_angle_ext = arg2;
            obj_pause.alarm[1] = 1;
        }
        if (instance_exists(obj_gameover))
        {
            obj_gameover.cursor_xscale_ext = arg0;
            obj_gameover.cursor_xscale_ext = arg1;
            obj_gameover.cursor_angle_ext = arg2;
            obj_gameover.alarm[1] = 1;
        }
        if (instance_exists(obj_victory))
        {
            obj_victory.cursor_xscale_ext = arg0;
            obj_victory.cursor_xscale_ext = arg1;
            obj_victory.cursor_angle_ext = arg2;
            obj_victory.alarm[1] = 1;
        }
    }
}
