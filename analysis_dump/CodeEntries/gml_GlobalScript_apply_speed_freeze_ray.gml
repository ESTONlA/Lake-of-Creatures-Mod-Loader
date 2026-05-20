function apply_speed_freeze_ray()
{
    var obj = object_get_name(object_index);
    var spd_frozen = spd * 0.3;
    if (obj != "obj_enemy")
    {
        x += lengthdir_x(spd_frozen, direction);
        y += lengthdir_y(spd_frozen, direction);
    }
    else
    {
        var spd_final = spd_frozen * movement_speed_multiplier;
        x += lengthdir_x(spd_final, direction);
        y += lengthdir_y(spd_final, direction);
    }
}
