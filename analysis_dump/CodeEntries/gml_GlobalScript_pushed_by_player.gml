function pushed_by_player()
{
    if (place_meeting(x, y, obj_player))
    {
        spd = get_unstuck_speed(obj_player);
        direction = point_direction(x, y, obj_player.x, obj_player.y) - 180;
        play_sound(50);
    }
}
