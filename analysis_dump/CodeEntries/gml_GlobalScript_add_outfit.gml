function add_outfit(arg0)
{
    if (instance_exists(obj_player))
    {
        array_push(obj_player.outfit_array, arg0);
    }
}
