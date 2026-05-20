function get_run_time()
{
    var seconds = "";
    var minutes = global.run_length_minutes;
    if (global.run_length_seconds < 10)
    {
        seconds = "0" + string(global.run_length_seconds);
    }
    else
    {
        seconds = string(global.run_length_seconds);
    }
    return string(minutes) + ":" + string(seconds);
}
