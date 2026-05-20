function spawn_items()
{
    if (global.item_crocodile_skin == true)
    {
        instance_create_depth(x, y, 100, obj_item_crocodile_skin);
    }
    if (global.item_rubber_duck == true)
    {
        instance_create_depth(x, y, 100, obj_item_rubber_duck);
    }
    if (global.item_water_bucket == true)
    {
        instance_create_depth(x, y, 100, obj_item_water_bucket);
    }
    if (global.item_sea_tumor == true)
    {
        instance_create_depth(x, y, 100, obj_item_sea_tumor);
    }
    if (global.item_staff == true)
    {
        instance_create_depth(x, y, 100, obj_item_staff);
    }
    if (global.item_daggers == true)
    {
        var random_dir = choose(0, 360);
        if (global.item_double_headed_frog == false)
        {
            for (var i = 0; i < 3; i += 1)
            {
                var dagger = instance_create_depth(obj_player.x, obj_player.y, 100, obj_dagger);
                dagger.offset = random_dir + (i * 120);
            }
        }
        else
        {
            for (var i = 0; i < 6; i += 1)
            {
                var dagger = instance_create_depth(obj_player.x, obj_player.y, 100, obj_dagger);
                dagger.offset = random_dir + (i * 60);
            }
        }
    }
    if (global.item_pinecone_hp > 0)
    {
        instance_create_depth(x, y, 100, obj_item_pinecone);
    }
    if (global.item_msg_bottle_hp > 0)
    {
        instance_create_depth(random_range(128, room_width - 128), random_range(128, room_height - 128), 0, obj_item_bottle);
    }
    if (global.item_freeze_ray == true)
    {
        instance_create_depth(x, y, 0, obj_ice_ball);
    }
    if (global.item_torpedo == true)
    {
        instance_create_depth(x, y, 0, obj_torpedo_shooter);
    }
    if (global.item_fire_breath == true)
    {
        instance_create_depth(x, y, 0, obj_fire_breath);
    }
    if (global.item_adrenaline == true)
    {
        global.weapon_temporary_damage_multiplier_room += 0.5;
        global.item_adrenaline_timer = 150;
    }
    if (global.item_gold_nugget == true && global.item_gold_nugget_active == true)
    {
        instance_create_depth(x, y, 100, obj_item_gold_nugget);
    }
    if (global.item_fermented_liquid == true)
    {
        global.weapon_temporary_damage_multiplier_room += 1;
        global.item_fermented_liquid_timer = 180;
    }
    if (global.item_split_shot == true && global.item_nearby_burn == true)
    {
        instance_create_depth(x, y, 0, obj_fire_aura_player_orbiter);
    }
}
