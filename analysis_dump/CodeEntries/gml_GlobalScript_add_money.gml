function add_money(arg0)
{
    if (!instance_exists(obj_coin_displayer))
    {
        var c_display = instance_create_depth(obj_player.x, obj_player.y, 0, obj_coin_displayer);
        c_display.value = 1;
        c_display.value_target = arg0;
    }
    else
    {
        obj_coin_displayer.value += 1;
        obj_coin_displayer.value_target += arg0;
        obj_coin_displayer.timer_length = 120;
        obj_coin_displayer.alarm[0] = 120;
        obj_coin_displayer.visible = true;
    }
}
