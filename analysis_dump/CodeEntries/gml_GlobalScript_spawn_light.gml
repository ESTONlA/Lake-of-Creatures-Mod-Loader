function spawn_light(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
{
    light_cutout = instance_create_depth(arg0, arg1, 0, obj_lighting_cutout);
    light_cutout.color = arg3;
    light_cutout.pin = arg2;
    if (arg4 != -1)
    {
        light_cutout.intensity = arg4;
    }
    if (arg5 != -1)
    {
        light_cutout.target_intensity = arg5;
    }
    if (arg6 != -1)
    {
        light_cutout.target_intensity_spd = arg6;
    }
    if (arg7 != -1)
    {
        light_cutout.scale = arg7;
    }
    if (arg8 != -1)
    {
        light_cutout.target_scale = arg8;
    }
    if (arg9 != -1)
    {
        light_cutout.target_scale_spd = arg9;
    }
    if (arg10 != -1)
    {
        light_cutout.alarm[0] = arg10;
    }
    if (arg11 != -1)
    {
        light_cutout.light_layers = arg11;
    }
    return light_cutout;
}
