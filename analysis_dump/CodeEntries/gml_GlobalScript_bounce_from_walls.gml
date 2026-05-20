function bounce_from_walls(arg0)
{
    if (bounce_cooldown <= 0)
    {
        var sound_played = true;
        var bounced = false;
        if (place_meeting(x + lengthdir_x(spd, direction), y, arg0))
        {
            if (sound_played == false)
            {
                play_sound(87, arg0);
                sound_played = true;
            }
            x += lengthdir_x(spd * 1, direction);
            direction = -direction + 180;
            x += lengthdir_x(spd * 1, direction);
            y += lengthdir_y(spd * 1, direction);
            bounced = true;
        }
        if (place_meeting(x, y + lengthdir_y(spd, direction), arg0))
        {
            if (sound_played == false)
            {
                play_sound(87, arg0);
                sound_played = true;
            }
            y += lengthdir_y(spd * 1, direction);
            direction = -direction;
            x += lengthdir_x(spd * 1, direction);
            y += lengthdir_y(spd * 1, direction);
            bounced = true;
        }
        if (bounced == true)
        {
            bounce_cooldown = 5;
        }
    }
}
