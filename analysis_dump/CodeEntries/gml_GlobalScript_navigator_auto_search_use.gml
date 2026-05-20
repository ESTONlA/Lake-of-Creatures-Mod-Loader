function navigator_auto_search_use()
{
    if (instance_exists(obj_navigator))
    {
        if (global.navigator_auto_search == false)
        {
            global.navigator_auto_search = true;
            obj_navigator.alarm[0] = obj_navigator.auto_search_time;
        }
    }
}
