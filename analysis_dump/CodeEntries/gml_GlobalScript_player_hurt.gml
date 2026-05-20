function player_hurt(arg0)
{
    if (global.player_is_dead == false)
    {
        if (instance_exists(obj_player))
        {
            with (obj_player)
            {
                if (can_get_hurt == true)
                {
                    var deal_damage = true;
                    if (global.item_damage_block == true)
                    {
                        if (floor(random(10)) == 0)
                        {
                            deal_damage = false;
                            item_effect_animation(41);
                        }
                    }
                    if (global.item_single_hit_block == true && global.item_single_hit_block_timer == -100)
                    {
                        deal_damage = false;
                        global.item_single_hit_block_timer = 120;
                        item_effect_animation(152);
                    }
                    if (deal_damage == false)
                    {
                        xscale_ext = -0.4;
                        yscale_ext = 0.4;
                        freeze_frame(50);
                        screenshake(5);
                        can_get_hurt = false;
                        alarm[2] = 120;
                    }
                    else
                    {
                        player_hurt_2(arg0);
                    }
                }
            }
        }
    }
}
