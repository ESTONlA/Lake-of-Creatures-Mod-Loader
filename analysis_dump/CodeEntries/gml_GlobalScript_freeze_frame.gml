function freeze_frame(arg0)
{
    if (global.freezeframe_enabled == true)
    {
        var freeze_dur = arg0;
        var time = current_time + freeze_dur;
        while (current_time < time)
        {
        }
    }
}
