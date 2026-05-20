function get_bullet_direction_offset_ext(arg0)
{
    switch (global.bullets_shot_at_once)
    {
        case 1:
            switch (arg0)
            {
                case 1:
                    return 0;
                    break;
            }
            break;
        case 2:
            switch (arg0)
            {
                case 1:
                    return -10;
                    break;
                case 2:
                    return 10;
                    break;
            }
            break;
        case 3:
            switch (arg0)
            {
                case 1:
                    return -15;
                    break;
                case 2:
                    return 0;
                    break;
                case 3:
                    return 15;
                    break;
            }
            break;
        case 4:
            switch (arg0)
            {
                case 1:
                    return -22;
                    break;
                case 2:
                    return -7;
                    break;
                case 3:
                    return 7;
                    break;
                case 4:
                    return 22;
                    break;
            }
            break;
        case 5:
            switch (arg0)
            {
                case 1:
                    return -30;
                    break;
                case 2:
                    return -15;
                    break;
                case 3:
                    return 0;
                    break;
                case 4:
                    return 15;
                    break;
                case 5:
                    return 30;
                    break;
            }
            break;
        case 6:
            switch (arg0)
            {
                case 1:
                    return -35;
                    break;
                case 2:
                    return -21;
                    break;
                case 3:
                    return -6;
                    break;
                case 4:
                    return 6;
                    break;
                case 5:
                    return 21;
                    break;
                case 6:
                    return 35;
                    break;
            }
            break;
        case 7:
            switch (arg0)
            {
                case 1:
                    return -40;
                    break;
                case 2:
                    return -24;
                    break;
                case 3:
                    return -8;
                    break;
                case 4:
                    return 0;
                    break;
                case 5:
                    return 8;
                    break;
                case 6:
                    return 24;
                    break;
                case 7:
                    return 40;
                    break;
            }
            break;
        case 8:
            switch (arg0)
            {
                case 1:
                    return -63;
                    break;
                case 2:
                    return -45;
                    break;
                case 3:
                    return -27;
                    break;
                case 4:
                    return -9;
                    break;
                case 5:
                    return 9;
                    break;
                case 6:
                    return 27;
                    break;
                case 7:
                    return 45;
                    break;
                case 8:
                    return 63;
                    break;
            }
    }
    return random_range(-65, 65);
}
