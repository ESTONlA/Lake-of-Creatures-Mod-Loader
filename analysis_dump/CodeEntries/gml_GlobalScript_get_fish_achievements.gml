function get_fish_achievements(arg0)
{
    if (arg0 >= 50)
    {
        achievement_get("50_DIFFERENT_FISH");
    }
    if (arg0 >= 100)
    {
        achievement_get("100_DIFFERENT_FISH");
    }
    if (arg0 >= 150)
    {
        achievement_get("150_DIFFERENT_FISH");
    }
    if (arg0 >= global.fish_species_total)
    {
        achievement_get("ALL_DIFFERENT_FISH");
    }
}
