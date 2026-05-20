function screenshake(arg0)
{
    if (global.screenshake_enabled == true)
    {
        if (instance_exists(obj_ctrl))
        {
            global.screenshake = true;
            obj_ctrl.alarm[0] = arg0;
        }
    }
}
