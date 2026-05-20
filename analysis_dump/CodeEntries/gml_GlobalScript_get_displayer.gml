function get_displayer(arg0, arg1)
{
    if (instance_exists(obj_any_displayer))
    {
        instance_destroy(obj_any_displayer);
    }
    switch (arg0)
    {
        case 0:
            if (global.player_weapon_secondary != -4)
            {
                var obj = instance_create_depth(0, 0, 0, obj_any_displayer);
                obj.my_text = string(get_weapon_name(global.player_weapon_secondary)) + " " + string(txt("game_degraded"));
                obj.my_text_2 = txt("game_ammo_decreased") + "!";
                obj.timer_length = 200;
            }
            break;
        case 1:
            var obj = instance_create_depth(0, 0, 0, obj_any_displayer);
            obj.my_text = string(arg1);
            obj.timer_length = 120;
            break;
        case 2:
            if (global.player_weapon_secondary != -4)
            {
                var obj = instance_create_depth(0, 0, 0, obj_any_displayer);
                obj.my_text = string(get_weapon_name(global.player_weapon_secondary));
                obj.my_text_2 = txt("game_weapon_upgraded") + "!";
                obj.timer_length = 200;
            }
            break;
    }
}
