function create_effect_waiter(arg0)
{
    var waiter = instance_create_depth(0, 0, 0, obj_item_effect_wait);
    waiter.item_effect_index = arg0;
    waiter.spawn_timer = 25 + (instance_number(obj_item_effect_wait) * 140);
}
