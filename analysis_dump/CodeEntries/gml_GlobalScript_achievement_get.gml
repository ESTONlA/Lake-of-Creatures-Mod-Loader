function achievement_get(arg0)
{
    var getter = instance_create_depth(0, 0, 0, obj_achievement_getter);
    getter.achievement_to_get = arg0;
}
