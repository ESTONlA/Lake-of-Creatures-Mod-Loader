function get_boss_name(arg0)
{
    boss_name = "";
    boss_room_name = string_copy(string(room_get_name(room)), 1, 10);
    room_name = string_copy(string(room_get_name(room)), 1, 7);
    if (room_name == "rm_BOSS")
    {
        switch (boss_room_name)
        {
            case "rm_BOSS_01":
                boss_name = "Nastoad";
                break;
            case "rm_BOSS_02":
                boss_name = "Aggrogator";
                break;
            case "rm_BOSS_03":
                boss_name = "Terrorsnake";
                break;
            case "rm_BOSS_04":
                boss_name = "Eutrophic Eye";
                break;
            case "rm_BOSS_05":
                boss_name = "Gobolin";
                break;
            case "rm_BOSS_06":
                boss_name = "Meltmoth";
                break;
            case "rm_BOSS_07":
                boss_name = "Mayor";
                break;
            case "rm_BOSS_08":
                boss_name = "Droolface";
                break;
            case "rm_BOSS_09":
                boss_name = "Double Hole";
                break;
            case "rm_BOSS_10":
                boss_name = "Lady Fish";
                break;
        }
    }
    global.boss_name = boss_name;
}
