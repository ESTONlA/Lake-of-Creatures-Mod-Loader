function pause_step()
{
    pause_screen_bg_alpha += ((1 - pause_screen_bg_alpha) * 0.2);
    pause_scale += ((1.2 - pause_scale) * 0.2);
}
