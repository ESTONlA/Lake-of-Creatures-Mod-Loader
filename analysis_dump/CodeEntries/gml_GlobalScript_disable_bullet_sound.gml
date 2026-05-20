function disable_bullet_sound(arg0)
{
    var sound_disabled = false;
    if (arg0 != -4)
    {
        if (instance_exists(arg0))
        {
            if (arg0.object_index == obj_bullet)
            {
                if (is_bullet_sound_disabled(arg0) == true)
                {
                    sound_disabled = true;
                }
            }
        }
    }
    return sound_disabled;
}
