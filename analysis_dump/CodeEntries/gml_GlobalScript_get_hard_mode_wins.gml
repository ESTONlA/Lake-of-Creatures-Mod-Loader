function get_hard_mode_wins()
{
    var hard_mode_wins = 0;
    for (var i = 0; i < global.playable_characters_total; i += 1)
    {
        if (global.lake_finished_amount_char_hard[2][i] > 0)
        {
            hard_mode_wins += 1;
        }
    }
    return hard_mode_wins;
}
