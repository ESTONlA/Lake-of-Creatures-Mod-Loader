function spawn_items_duplicate()
{
    if (global.item_crocodile_skin == true)
    {
        instance_create_depth(x, y, 100, obj_item_crocodile_skin);
    }
    if (global.item_rubber_duck == true)
    {
        instance_create_depth(x, y, 100, obj_item_rubber_duck);
    }
    if (instance_exists(obj_item_water_bucket))
    {
        instance_create_depth(x, y, 100, obj_item_water_bucket);
    }
    if (instance_exists(obj_item_pinecone))
    {
        instance_create_depth(x, y, 100, obj_item_pinecone);
    }
    if (instance_exists(obj_item_staff))
    {
        var staff = instance_create_depth(x, y, 100, obj_item_staff);
        staff.offset_in_hand_dir = 90;
    }
    if (global.item_split_shot == true && global.item_nearby_burn == true)
    {
        instance_create_depth(x, y, 0, obj_fire_aura_player_orbiter);
    }
}
