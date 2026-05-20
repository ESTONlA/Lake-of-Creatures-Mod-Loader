function minigame_good_attempt(arg0)
{
    success_effect = true;
    success_scale = 1.2;
    success_alpha = 1;
    xscale_ext = 0.2;
    yscale_ext = -0.2;
    yy = 10;
    arrow_index = 2;
    screenshake(2);
    if (instance_exists(obj_rope_holder_end))
    {
        with (obj_rope_holder_end)
        {
            attempt_to_lift_fish(arg0, x, y);
        }
    }
    else
    {
        instance_destroy();
    }
}
