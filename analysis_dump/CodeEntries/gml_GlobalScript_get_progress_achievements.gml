function get_progress_achievements(arg0)
{
    if (arg0 >= 10)
    {
        achievement_get("progress_10");
    }
    if (arg0 >= 25)
    {
        achievement_get("progress_25");
    }
    if (arg0 >= 50)
    {
        achievement_get("progress_50");
    }
    if (arg0 >= 75)
    {
        achievement_get("progress_75");
    }
    if (arg0 >= 100)
    {
        achievement_get("progress_100");
    }
}
