function does_shop_item_exist(arg0, arg1)
{
    var check_radius = 8;
    var exists = true;
    if (!collision_circle(arg0, arg1, check_radius, obj_chest, 0, 0) && !collision_circle(arg0, arg1, check_radius, obj_pickup_item_pickup, 0, 0) && !collision_circle(arg0, arg1, check_radius, obj_item_pickup, 0, 0))
    {
        exists = false;
    }
    return exists;
}
