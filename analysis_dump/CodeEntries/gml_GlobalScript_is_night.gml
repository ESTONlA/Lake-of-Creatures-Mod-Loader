function is_night()
{
    if (global.boss_beaten == true && global.in_boss_room == false && global.night_cancelled == false)
    {
        return true;
    }
    else
    {
        return false;
    }
}
