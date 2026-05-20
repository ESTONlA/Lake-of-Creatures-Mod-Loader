function spawn_gas_clouds(arg0, arg1, arg2)
{
    var old_gas = false;
    if (old_gas == false)
    {
        for (var i = 0; i < 3; i += 1)
        {
            spawn_toxic_puddle(arg0 + random_range(-7, 7), arg1 + random_range(-7, 7), 0, random_range(0, 360));
        }
    }
    else
    {
        var poison_amount = choose(5, 6, 7);
        play_sound(99);
        for (var i = 0; i < poison_amount; i += 1)
        {
            var len = random_range(120, 160);
            if (arg2 == 1)
            {
                len = random_range(40, 70);
            }
            var g_cloud = instance_create_depth(arg0 + random_range(-4, 4), arg1 + random_range(-4, 4), depth - 30, obj_gas_cloud);
            g_cloud.direction = random_range(0, 360);
            g_cloud.spd = random_range(0.3, 0.65);
            g_cloud.from_enemy = true;
            g_cloud.dmg_to_deal = 1;
            g_cloud.stopping = true;
            g_cloud.alarm[1] = len;
        }
        poison_amount = choose(2, 3);
        for (var i = 0; i < poison_amount; i += 1)
        {
            var len = random_range(120, 160);
            if (arg2 == 1)
            {
                len = random_range(40, 70);
            }
            var g_cloud = instance_create_depth(arg0 + random_range(-4, 4), arg1 + random_range(-4, 4), depth - 30, obj_gas_cloud);
            g_cloud.direction = random_range(0, 360);
            g_cloud.spd = random_range(0.7, 1.1);
            g_cloud.from_enemy = true;
            g_cloud.dmg_to_deal = 1;
            g_cloud.stopping = true;
            g_cloud.alarm[1] = len;
        }
    }
}
