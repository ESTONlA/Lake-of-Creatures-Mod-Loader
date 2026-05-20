function get_boss_index()
{
    var lake = get_lake_type(global.current_lake);
    switch (lake)
    {
        case 1:
            my_boss_index = 10;
            if (room == rm_BOSS_04_A || room == rm_BOSS_04_B || room == rm_BOSS_04_C)
            {
                my_boss_index = 35;
            }
            if (room == rm_BOSS_05_A || room == rm_BOSS_05_B || room == rm_BOSS_05_C)
            {
                my_boss_index = 47;
            }
            if (room == rm_BOSS_08_A || room == rm_BOSS_08_B)
            {
                my_boss_index = 54;
            }
            if (room == rm_BOSS_09_A || room == rm_BOSS_09_B)
            {
                my_boss_index = 49;
            }
            boss_spawn_x = room_width / 2;
            boss_spawn_y = (room_height / 2) - 48;
            break;
        case 2:
            my_boss_index = 16;
            if (room == rm_BOSS_06_A || room == rm_BOSS_06_B || room == rm_BOSS_06_C)
            {
                my_boss_index = 48;
            }
            if (room == rm_BOSS_09_A || room == rm_BOSS_09_B)
            {
                my_boss_index = 49;
            }
            if (room == rm_BOSS_10_A || room == rm_BOSS_10_B)
            {
                my_boss_index = 55;
            }
            boss_spawn_x = room_width / 2;
            boss_spawn_y = (room_height / 2) - 48;
            break;
        case 3:
            my_boss_index = 29;
            boss_spawn_x = room_width / 2;
            boss_spawn_y = (room_height / 2) - 48;
            break;
            break;
        case 4:
            my_boss_index = 52;
            boss_spawn_x = room_width / 2;
            boss_spawn_y = (room_height / 2) - 48;
            break;
    }
}
