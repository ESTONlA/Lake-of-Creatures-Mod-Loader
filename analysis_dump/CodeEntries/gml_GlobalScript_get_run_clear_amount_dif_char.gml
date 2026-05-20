function get_run_clear_amount_dif_char(arg0)
{
    var result = 0;
    var lake_to_finish = 2;
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        if (arg0 == 0)
        {
            if (global.lake_finished_amount_char_easy[lake_to_finish][i] > 0)
            {
                result += 1;
            }
        }
        if (arg0 == 1)
        {
            if (global.lake_finished_amount_char_hard[lake_to_finish][i] > 0)
            {
                result += 1;
            }
        }
    }
    return result;
}
