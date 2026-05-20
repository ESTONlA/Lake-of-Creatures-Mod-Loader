function get_run_clear_amount_all_char(arg0)
{
    var runs_won = 0;
    if (arg0 == 0)
    {
        for (var i = 0; i < global.playable_characters_total; i += 1)
        {
            runs_won += global.lake_finished_amount_char_easy[2][i];
        }
    }
    if (arg0 == 1)
    {
        for (var i = 0; i < global.playable_characters_total; i += 1)
        {
            runs_won += global.lake_finished_amount_char_hard[2][i];
        }
    }
    return runs_won;
}
