function get_fish_worth(arg0)
{
    var result = 0;
    switch (arg0)
    {
        case 0:
            result = floor(random_range(5, 11));
            break;
        case 1:
            result = floor(random_range(15, 21));
            break;
        case 2:
            result = floor(random_range(8, 15));
            break;
        case 3:
            result = floor(random_range(6, 12));
            break;
        case 4:
            result = floor(random_range(30, 61));
            break;
        case 5:
            result = floor(random_range(65, 81));
            break;
        case 6:
            result = floor(random_range(30, 56));
            break;
        case 7:
            result = floor(random_range(18, 34));
            break;
        case 8:
            result = floor(random_range(80, 111));
            break;
        case 9:
            result = floor(random_range(25, 36));
            break;
        case 10:
            result = floor(random_range(30, 51));
            break;
        case 11:
            result = floor(random_range(10, 23));
            break;
        case 12:
            result = floor(random_range(110, 131));
            break;
        case 13:
            result = floor(random_range(30, 46));
            break;
        case 14:
            result = floor(random_range(15, 26));
            break;
        case 15:
            result = 1;
            break;
    }
    var multiplier = 1;
    if (global.difficulty_selection == 1)
    {
        multiplier = 1.2;
    }
    result = floor(result * multiplier);
    return floor(result);
}
