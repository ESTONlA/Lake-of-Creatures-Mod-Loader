function spawn_plants(arg0, arg1)
{
    var total_amount_of_plant_patterns = 1;
    var hotspot_chance = random_range(0, 25);
    my_pattern = 0;
    switch (my_pattern)
    {
        case 0:
            instance_create_depth(arg0 - 16, arg1 - 16, 0, obj_water_plant_spawner);
            instance_create_depth(arg0 + 16, arg1 - 16, 0, obj_water_plant_spawner);
            instance_create_depth(arg0 - 16, arg1 + 16, 0, obj_water_plant_spawner);
            instance_create_depth(arg0 - 16, arg1 + 16, 0, obj_water_plant_spawner);
            var hotspot_xscale = 2;
            var hotspot_yscale = 2;
            break;
    }
}
