function get_unstuck(arg0)
{
    for (i = 0; i < 100; i += 1)
    {
        if (!place_meeting(x - i, y, arg0))
        {
            x -= i;
            break;
        }
        if (!place_meeting(x + i, y, arg0))
        {
            x += i;
            break;
        }
        if (!place_meeting(x, y - i, arg0))
        {
            y -= i;
            break;
        }
        if (!place_meeting(x, y + i, arg0))
        {
            y += i;
            break;
        }
        if (!place_meeting(x - i, y - i, arg0))
        {
            x -= i;
            y -= i;
            break;
        }
        if (!place_meeting(x + i, y - i, arg0))
        {
            x += i;
            y -= i;
            break;
        }
        if (!place_meeting(x - i, y + i, arg0))
        {
            x -= i;
            y += i;
            break;
        }
        if (!place_meeting(x + i, y + i, arg0))
        {
            x += i;
            y += i;
            break;
        }
    }
}
