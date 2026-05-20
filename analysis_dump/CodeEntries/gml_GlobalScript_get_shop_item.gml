function get_shop_item(arg0, arg1)
{
    var check_radius = 8;
    var shop_item_id = -4;
    if (collision_circle(arg0, arg1, check_radius, obj_chest, 0, 0))
    {
        shop_item_id = instance_nearest(arg0, arg1, obj_chest);
    }
    if (collision_circle(arg0, arg1, check_radius, obj_pickup_item_pickup, 0, 0))
    {
        shop_item_id = instance_nearest(arg0, arg1, obj_pickup_item_pickup);
    }
    if (collision_circle(arg0, arg1, check_radius, obj_item_pickup, 0, 0))
    {
        shop_item_id = instance_nearest(arg0, arg1, obj_item_pickup);
    }
    return shop_item_id;
}
