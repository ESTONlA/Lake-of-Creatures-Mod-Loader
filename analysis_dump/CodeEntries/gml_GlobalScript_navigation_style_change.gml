function navigation_style_change(arg0)
{
    global.navigation_style = arg0;
    if (arg0 == 2 && !instance_exists(obj_navigator))
    {
        instance_create_depth(room_width / 2, room_height / 2, -1001, obj_navigator);
    }
    if (arg0 == 1 && instance_exists(obj_navigator))
    {
        instance_destroy(obj_navigator);
    }
}
