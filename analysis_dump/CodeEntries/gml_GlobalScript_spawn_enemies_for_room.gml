function spawn_enemies_for_room()
{
    switch (pool_type)
    {
        case 0:
            obj = instance_create_layer(x, y, "Instances", obj_enemy);
            obj.natural_spawn = 0;
            obj.enemy_index = global.current_world_block_id.enemy_pool_0[image_index];
            obj.image_angle = image_angle;
            break;
        case 1:
            obj = instance_create_layer(x, y, "Instances", obj_enemy);
            obj.natural_spawn = 0;
            obj.enemy_index = global.current_world_block_id.enemy_pool_1[image_index];
            obj.image_angle = image_angle;
            break;
        case 2:
            obj = instance_create_layer(x, y, "Instances", obj_enemy);
            obj.natural_spawn = 0;
            obj.enemy_index = global.current_world_block_id.enemy_pool_2[image_index];
            obj.image_angle = image_angle;
            break;
        case 3:
            obj = instance_create_layer(x, y, "Instances", obj_enemy);
            obj.natural_spawn = 0;
            obj.enemy_index = global.current_world_block_id.enemy_pool_3[image_index];
            obj.image_angle = image_angle;
            break;
    }
}
