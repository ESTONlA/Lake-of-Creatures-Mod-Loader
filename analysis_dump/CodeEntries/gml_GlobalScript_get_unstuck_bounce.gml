function get_unstuck_bounce(arg0)
{
    for (i = 0; i < 100; i += 1)
    {
        if (!place_meeting(x - i, y, arg0))
        {
            x -= i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x + i, y, arg0))
        {
            x += i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x, y - i, arg0))
        {
            y -= i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x, y + i, arg0))
        {
            y += i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x - i, y - i, arg0))
        {
            x -= i;
            y -= i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x + i, y - i, arg0))
        {
            x += i;
            y -= i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x - i, y + i, arg0))
        {
            x -= i;
            y += i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
        if (!place_meeting(x + i, y + i, arg0))
        {
            x += i;
            y += i;
            knockback_movement_dir = random_range(0, 360);
            knockback_movement_len = weight / 2;
            break;
        }
    }
}
