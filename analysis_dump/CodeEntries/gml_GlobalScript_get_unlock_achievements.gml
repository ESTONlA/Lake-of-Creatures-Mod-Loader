function get_unlock_achievements(arg0, arg1)
{
    if (arg0 >= 5)
    {
        achievement_get("5_UNLOCKED_TREASURES");
    }
    if (arg0 >= 15)
    {
        achievement_get("15_UNLOCKED_TREASURES");
    }
    if (arg0 >= global.unlocks_total[0])
    {
        achievement_get("ALL_UNLOCKED_TREASURES");
    }
    if (arg1 >= 25)
    {
        achievement_get("FIND_25_TREASURES");
    }
    if (arg1 >= 50)
    {
        achievement_get("FIND_50_TREASURES");
    }
    if (arg1 >= 100)
    {
        achievement_get("FIND_100_TREASURES");
    }
}
