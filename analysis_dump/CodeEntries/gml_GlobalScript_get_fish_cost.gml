function get_fish_cost(arg0)
{
    var result = 0;
    switch (arg0)
    {
        case 0:
            result = floor(random_range(15, 21));
            break;
        case 1:
            result = floor(random_range(20, 31));
            break;
        case 2:
            result = floor(random_range(50, 81));
            break;
        case 3:
            result = floor(random_range(200, 251));
            break;
    }
    var multiplier = 1;
    if (global.difficulty_selection == 1)
    {
        multiplier = 1.1;
    }
    result = floor(result * multiplier);
    return floor(result);
}
