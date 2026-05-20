function get_unstuck_speed(arg0)
{
    for (i = 0; i < 100; i += 1)
    {
        if (!place_meeting(x - i, y, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x + i, y, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x, y - i, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x, y + i, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x - i, y - i, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x + i, y - i, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x - i, y + i, arg0))
        {
            return i;
            break;
        }
        if (!place_meeting(x + i, y + i, arg0))
        {
            return i;
            break;
        }
    }
}
