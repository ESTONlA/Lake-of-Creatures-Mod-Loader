function get_boss_room_index()
{
    var lake = get_lake_type(my_lake_id);
    switch (lake)
    {
        case 1:
            if (global.difficulty_selection == 0)
            {
                room_index_boss = choose(rm_BOSS_01_A, rm_BOSS_01_B, rm_BOSS_01_C, rm_BOSS_01_D, rm_BOSS_04_A, rm_BOSS_04_B, rm_BOSS_04_C, rm_BOSS_08_A, rm_BOSS_08_B);
            }
            else
            {
                room_index_boss = choose(rm_BOSS_01_A, rm_BOSS_01_B, rm_BOSS_01_C, rm_BOSS_01_D, rm_BOSS_04_A, rm_BOSS_04_B, rm_BOSS_04_C, rm_BOSS_05_A, rm_BOSS_05_B, rm_BOSS_05_C, rm_BOSS_08_A, rm_BOSS_08_B);
            }
            break;
        case 2:
            room_index_boss = choose(rm_BOSS_02_A, rm_BOSS_02_B, rm_BOSS_02_C, rm_BOSS_06_A, rm_BOSS_06_B, rm_BOSS_06_C, rm_BOSS_09_A, rm_BOSS_09_B, rm_BOSS_10_A, rm_BOSS_10_B);
            break;
        case 3:
            room_index_boss = rm_BOSS_03;
            break;
        case 4:
            room_index_boss = rm_BOSS_07;
            break;
    }
}
