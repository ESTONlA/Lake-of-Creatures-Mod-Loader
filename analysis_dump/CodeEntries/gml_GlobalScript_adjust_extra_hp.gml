function adjust_extra_hp()
{
    var extra_hp_amount = 0;
    for (var i = 0; i < 10; i += 1)
    {
        extra_hp_temp[i] = 0;
    }
    for (var i = 0; i < 10; i += 1)
    {
        if (global.player_hp_extra[i] != 0)
        {
            extra_hp_temp[extra_hp_amount] = global.player_hp_extra[i];
            extra_hp_amount += 1;
        }
    }
    if (extra_hp_amount != 0)
    {
        for (var i = 0; i < 10; i += 1)
        {
            global.player_hp_extra[i] = 0;
        }
        var refilled_hp_amount = 0;
        for (var i = global.player_hp_max; i < 10; i += 1)
        {
            global.player_hp_extra[i] = extra_hp_temp[refilled_hp_amount];
            refilled_hp_amount += 1;
        }
    }
}
