function hymy_smiley_step()
{
    if (global.playable_characters_selected == 5)
    {
        var smiley_how_long_can_it_spawn = 7;
        if (global.hymy_smiley_can_spawn == true)
        {
            global.hymy_smiley_can_spawn_timer += 1;
            if (global.hymy_smiley_can_spawn_timer > 60)
            {
                if (global.hymy_smiley_can_spawn_timer <= (smiley_how_long_can_it_spawn * 60) && instance_exists(obj_enemy))
                {
                    if (floor(random(200)) == 0)
                    {
                        hymy_spawn_smiley();
                    }
                }
                else
                {
                    global.hymy_smiley_can_spawn = false;
                }
            }
        }
    }
}
