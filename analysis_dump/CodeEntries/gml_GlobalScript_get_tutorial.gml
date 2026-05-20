function get_tutorial(arg0)
{
    switch (arg0)
    {
        case 0:
            var gold_cricket_amount = global.gold_crickets_given + global.gold_crickets_held + instance_number(obj_cricket_gold_use);
            if (gold_cricket_amount < 2 && global.visited_tentacle_without_g_crickets <= 3)
            {
                if (global.visited_tentacle_without_this_run == 0)
                {
                    global.visited_tentacle_without_g_crickets += 1;
                    global.visited_tentacle_without_this_run = 1;
                }
                if (!instance_exists(obj_tutorial_displayer))
                {
                    var tut = instance_create_depth(0, 0, -998, obj_tutorial_displayer);
                    tut.item_name = "Return here with at least 2 golden crickets";
                    tut.tutorial_index = arg0;
                }
                else if (!instance_exists(obj_transition) && !instance_exists(obj_transition_area_start) && !instance_exists(obj_enemy) && !instance_exists(obj_enemy_spawner) && !instance_exists(obj_enemy_respawner))
                {
                    obj_tutorial_displayer.fadeout = false;
                    obj_tutorial_displayer.alarm[0] += 1;
                }
            }
            else if (instance_exists(obj_tutorial_displayer))
            {
                obj_tutorial_displayer.fadeout = true;
            }
            break;
        case 1:
            if (instance_exists(obj_fish_underwater) && global.fish_caught_tutorial_all_time <= 3)
            {
                if (global.fish_caught_this_run == 0)
                {
                    if (!instance_exists(obj_tutorial_displayer))
                    {
                        var spawn_tutorial = true;
                        if (instance_exists(obj_rope_holder_end))
                        {
                            if (obj_rope_holder_end.fish_on == true)
                            {
                                spawn_tutorial = false;
                            }
                        }
                        if (spawn_tutorial == true && room != rm_overworld_tut_7)
                        {
                            var tut = instance_create_depth(0, 0, -998, obj_tutorial_displayer);
                            tut.item_name = txt("tutorial_fishing");
                            tut.tutorial_index = arg0;
                        }
                    }
                    else if (!instance_exists(obj_transition) && !instance_exists(obj_transition_area_start) && !instance_exists(obj_enemy) && !instance_exists(obj_enemy_spawner) && !instance_exists(obj_enemy_wave_battle_spawner) && !instance_exists(obj_enemy_spawn_square) && !instance_exists(obj_enemy_respawner))
                    {
                        var destroy_tutorial = false;
                        if (instance_exists(obj_rope_holder_end))
                        {
                            if (obj_rope_holder_end.fish_on == true)
                            {
                                destroy_tutorial = true;
                            }
                        }
                        if (destroy_tutorial == true)
                        {
                            instance_destroy(obj_tutorial_displayer);
                        }
                        obj_tutorial_displayer.fadeout = false;
                        obj_tutorial_displayer.alarm[0] += 1;
                    }
                }
            }
            break;
    }
}
