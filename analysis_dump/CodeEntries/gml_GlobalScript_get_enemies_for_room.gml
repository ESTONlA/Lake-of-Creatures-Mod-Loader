function get_enemies_for_room()
{
    if (global.world_generation_version == 1)
    {
        lake_to_use = global.current_lake;
    }
    else
    {
        lake_to_use = get_lake_type(my_lake_id);
    }
    if (lake_to_use == 1)
    {
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select;
            if (global.current_lake == 1)
            {
                random_enemy_to_select = choose(3, 3, 3, 12, 15, 18, 22);
            }
            else
            {
                random_enemy_to_select = choose(3, 3, 3, 4, 12, 15, 18, 22);
            }
            enemy_pool_0[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(6);
            enemy_pool_1[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(6);
            enemy_pool_2[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(9);
            enemy_pool_3[i] = random_enemy_to_select;
        }
    }
    if (lake_to_use == 2)
    {
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(1, 7, 5, 11, 14, 19, 27, 27, 34);
            enemy_pool_0[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(13, 27);
            enemy_pool_1[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(13, 27);
            enemy_pool_2[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(9);
            enemy_pool_3[i] = random_enemy_to_select;
        }
    }
    if (lake_to_use == 3)
    {
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(3, 24, 25, 39, 40, 41, 42, 43);
            enemy_pool_0[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(38);
            enemy_pool_1[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(38);
            enemy_pool_2[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(26);
            enemy_pool_3[i] = random_enemy_to_select;
        }
    }
    if (lake_to_use == 4)
    {
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(1, 3, 4, 5, 11, 12, 14, 15, 18, 19, 21, 24, 22, 25, 27, 28, 34, 37, 38, 39, 40, 41, 42, 43);
            enemy_pool_0[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(6, 13, 27, 38);
            enemy_pool_1[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(6, 13, 27, 38);
            enemy_pool_2[i] = random_enemy_to_select;
        }
        for (i = 0; i <= 2; i += 1)
        {
            var random_enemy_to_select = choose(9);
            enemy_pool_3[i] = random_enemy_to_select;
        }
    }
}
