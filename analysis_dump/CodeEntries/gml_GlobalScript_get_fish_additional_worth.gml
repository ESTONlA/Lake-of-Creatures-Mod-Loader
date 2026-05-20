function get_fish_additional_worth(arg0)
{
    var value_increase = 0;
    var result = 0;
    if (global.fish_value_multiplier != 1)
    {
        value_increase = arg0 * (global.fish_value_multiplier - 1);
        if (value_increase < 1)
        {
            value_increase = 1;
        }
    }
    result = floor(arg0 + value_increase);
    return result;
}
