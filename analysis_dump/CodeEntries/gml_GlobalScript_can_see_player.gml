function can_see_player()
{
    if (!collision_line(x, y, obj_player.x, obj_player.y, obj_solid, 1, 0) && !collision_line(x, y, obj_player.x, obj_player.y, obj_solid_environment, 1, 0))
    {
        return true;
    }
    else
    {
        return false;
    }
}
