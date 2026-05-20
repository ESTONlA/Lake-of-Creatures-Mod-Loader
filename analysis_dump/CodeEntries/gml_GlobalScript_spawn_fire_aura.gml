function spawn_fire_aura()
{
    if (global.item_nearby_burn == true)
    {
        var fire_aura = instance_create_depth(x, y, 0, obj_fire_aura);
        fire_aura.pin = id;
    }
}
