function set_event_icon(arg0)
{
    var is_already = false;
    for (var i = 0; i < 5; i += 1)
    {
        if (global.event_icon[i] == arg0)
        {
            is_already = true;
        }
    }
    var set = false;
    if (is_already == false)
    {
        for (var i = 0; i < 5; i += 1)
        {
            if (set == false)
            {
                if (global.event_icon[i] == -4)
                {
                    global.event_icon[i] = arg0;
                    set = true;
                }
            }
        }
    }
}
