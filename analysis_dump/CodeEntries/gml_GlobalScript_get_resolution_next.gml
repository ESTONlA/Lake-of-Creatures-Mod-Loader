function get_resolution_next()
{
    switch (global.resolution_option)
    {
        case 0:
            global.resolution_option_width = 640;
            global.resolution_option_height = 360;
            global.resolution_option = 1;
            break;
        case 1:
            global.resolution_option_width = 1920;
            global.resolution_option_height = 1080;
            global.resolution_option = 2;
            break;
        case 2:
            global.resolution_option_width = 1280;
            global.resolution_option_height = 720;
            global.resolution_option = 0;
            break;
    }
}
