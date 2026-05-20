function set_resolution()
{
    switch (global.resolution_option_current)
    {
        case 0:
            global.resolution_option_current = 0;
            global.resolution_current_width = 1280;
            global.resolution_current_height = 720;
            global.pause_menu_bg_xscale = 0.25;
            global.pause_menu_bg_yscale = 0.25;
            window_set_size(1280, 720);
            break;
        case 1:
            global.resolution_option_current = 1;
            global.resolution_current_width = 640;
            global.resolution_current_height = 360;
            global.pause_menu_bg_xscale = 0.25;
            global.pause_menu_bg_yscale = 0.25;
            window_set_size(640, 360);
            break;
        case 2:
            global.resolution_current_width = 1920;
            global.resolution_current_height = 1080;
            global.pause_menu_bg_xscale = 0.25;
            global.pause_menu_bg_yscale = 0.25;
            window_set_size(1920, 1080);
            break;
    }
    global.pause_menu_bg_xscale = 1 / (global.resolution_current_width / 480);
    global.pause_menu_bg_yscale = 1 / (global.resolution_current_height / 270);
}
