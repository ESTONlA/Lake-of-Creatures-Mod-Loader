function get_progress_features_total()
{
    var total = 0;
    for (var i = 1; i < global.unlocks_all_total; i += 1)
    {
        if (i != 2 && i != 4 && i != 5)
        {
            if (i != 9 && i != 15 && i != 16)
            {
                total += 1;
            }
        }
    }
    return total;
}
