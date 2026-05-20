function minigame_failed_attempt(arg0)
{
    fail_effect = true;
    fail_scale = 1.2;
    fail_alpha = 0.7;
    arrow_index = 3;
    xscale_ext = 0.2;
    yscale_ext = -0.2;
    screenshake(2);
    freeze_frame(30);
    shake = 15;
    if (instance_exists(arg0))
    {
        if (instance_exists(obj_rope_holder_end))
        {
            with (obj_rope_holder_end)
            {
                var yank_spd_temp = abs(((arg0.fish_energy_left * arg0.fish_weight) / 100) - 6) * 2;
                yank_spd = yank_spd_temp;
                global.line_stress += (yank_spd_temp * 16);
            }
        }
    }
}
