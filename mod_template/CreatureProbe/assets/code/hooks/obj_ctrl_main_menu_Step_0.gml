if (global.current_menu == 7)
{
    overlay_darkness_alpha += ((0.8 - overlay_darkness_alpha) * 0.1);
    global.current_darkness += ((0.22 - global.current_darkness) * 0.1);
    logo_yy += ((-70 - logo_yy) * 0.1);
    logo_alpha += ((0 - logo_alpha) * 0.2);
    if (input_check_pressed("leave"))
    {
        alarm[2] = 1;
    }
}
