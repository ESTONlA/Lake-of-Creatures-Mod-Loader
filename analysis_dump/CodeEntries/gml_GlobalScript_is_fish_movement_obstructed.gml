function is_fish_movement_obstructed()
{
    var result = false;
    var next_x = x + lengthdir_x(spd, direction);
    var next_y = y + lengthdir_y(spd, direction);
    if (next_x < 16)
    {
        result = true;
    }
    if (next_x > (room_width - 16))
    {
        result = true;
    }
    if (next_y < 16)
    {
        result = true;
    }
    if (next_y > (room_height - 16))
    {
        result = true;
    }
    if (place_meeting(next_x, next_y, obj_solid) || place_meeting(next_x, next_y, obj_solid_environment) || place_meeting(next_x, next_y, obj_solid_half))
    {
        result = true;
    }
    return result;
}
