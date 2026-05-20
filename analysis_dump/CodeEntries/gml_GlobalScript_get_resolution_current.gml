function get_resolution_current()
{
    switch (global.resolution_option_current)
    {
        case 0:
            global.resolution_option_width = 1280;
            global.resolution_option_height = 720;
            break;
        case 1:
            global.resolution_option_width = 640;
            global.resolution_option_height = 360;
            break;
        case 2:
            global.resolution_option_width = 1920;
            global.resolution_option_height = 1080;
            break;
    }
}
