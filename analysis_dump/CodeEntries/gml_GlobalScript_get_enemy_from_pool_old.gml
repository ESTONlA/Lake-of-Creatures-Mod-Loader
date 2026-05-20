function get_enemy_from_pool_old()
{
    if (global.current_lake == 1)
    {
        switch (pool_type)
        {
            case 0:
                var random_enemy_index_from_pool = 17;
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 1:
                var random_enemy_index_from_pool = choose(6, 6, 6);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 2:
                var random_enemy_index_from_pool = choose(6, 6, 8, 8, 8);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 3:
                instance_destroy();
                break;
        }
    }
    if (global.current_lake == 2)
    {
        switch (pool_type)
        {
            case 0:
                var random_enemy_index_from_pool = choose(1, 3, 3, 3, 4, 7);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 1:
                var random_enemy_index_from_pool = choose(6, 6, 6);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 2:
                var random_enemy_index_from_pool = choose(6, 6, 8, 8, 8);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 3:
                var random_enemy_index_from_pool = choose(9);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
        }
    }
    if (global.current_lake == 3)
    {
        switch (pool_type)
        {
            case 0:
                var random_enemy_index_from_pool = choose(3, 3, 4, 4, 5, 11, 11, 15, 15, 15);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 1:
                var random_enemy_index_from_pool = choose(6);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 2:
                var random_enemy_index_from_pool = choose(6, 8);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 3:
                var random_enemy_index_from_pool = choose(9);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
        }
    }
    if (global.current_lake == 4)
    {
        switch (pool_type)
        {
            case 0:
                var random_enemy_index_from_pool = choose(1, 3, 3, 4, 4, 5, 11, 11, 14, 15, 15, 15);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 1:
                var random_enemy_index_from_pool = choose(6, 13);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 2:
                var random_enemy_index_from_pool = choose(6, 8, 13);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
            case 3:
                var random_enemy_index_from_pool = choose(9);
                obj = instance_create_layer(x, y, "Instances", obj_enemy);
                obj.natural_spawn = 0;
                obj.enemy_index = random_enemy_index_from_pool;
                obj.image_angle = image_angle;
                break;
        }
    }
}
