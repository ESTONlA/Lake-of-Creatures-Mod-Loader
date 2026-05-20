function badge_progress_add(arg0)
{
    var allow_progress = true;
    if (global.magic_run_active == true)
    {
        allow_progress = false;
    }
    if (allow_progress == true)
    {
        return arg0;
    }
    else
    {
        return 0;
    }
}
