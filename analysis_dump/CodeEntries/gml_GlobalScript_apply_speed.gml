function apply_speed()
{
    var obj = object_get_name(object_index);
    if (obj != "obj_enemy")
    {
        x += lengthdir_x(spd, direction);
        y += lengthdir_y(spd, direction);
    }
    else
    {
        var spd_final = spd * movement_speed_multiplier;
        x += lengthdir_x(spd_final, direction);
        y += lengthdir_y(spd_final, direction);
    }
}
