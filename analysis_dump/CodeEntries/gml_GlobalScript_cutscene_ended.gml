function cutscene_ended()
{
    if (!instance_exists(obj_cutscene_ender))
    {
        instance_create_depth(0, 0, 0, obj_cutscene_ender);
    }
}
