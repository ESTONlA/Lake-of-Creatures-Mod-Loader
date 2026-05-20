function spawn_enemy_wave_battle(arg0, arg1, arg2)
{
    var spawn_angle = random_range(0, 360);
    var enemy_to_spawn1 = get_enemy_for_battle_room();
    var enemy_to_spawn2 = get_enemy_for_battle_room();
    var dis_to_enemies = 80;
    var additional_enemies_to_spawn = 0 + global.current_world_block_id.sausage_room_big;
    for (i = 0; i < (1 + additional_enemies_to_spawn); i += 1)
    {
        var my_x = arg0 + lengthdir_x(dis_to_enemies, spawn_angle + (i * (120 - (additional_enemies_to_spawn * 30))));
        var my_y = arg1 + lengthdir_y(dis_to_enemies, spawn_angle + (i * (120 - (additional_enemies_to_spawn * 30))));
        obj = instance_create_layer(my_x + random_range(-10, 10), my_y + random_range(-10, 10), "Instances", obj_enemy_spawn_square);
        obj.natural_spawn = 0;
        obj.enemy_index = enemy_to_spawn1;
        obj.spd = random_range(0, 1);
        var random_dir = random_range(0, 360);
        obj.direction = random_dir;
        obj.spawned_by_another_enemy = true;
    }
    var i = 1 + additional_enemies_to_spawn;
    while (i < (3 + additional_enemies_to_spawn))
    {
        var my_x = arg0 + lengthdir_x(dis_to_enemies, spawn_angle + (i * (120 - (additional_enemies_to_spawn * 30))));
        var my_y = arg1 + lengthdir_y(dis_to_enemies, spawn_angle + (i * (120 - (additional_enemies_to_spawn * 30))));
        obj = instance_create_layer(my_x + random_range(-10, 10), my_y + random_range(-10, 10), "Instances", obj_enemy_spawn_square);
        obj.natural_spawn = 0;
        obj.enemy_index = enemy_to_spawn2;
        obj.spd = random_range(0, 1);
        var random_dir = random_range(0, 360);
        obj.direction = random_dir;
        obj.spawned_by_another_enemy = true;
        i += 1;
    }
}
