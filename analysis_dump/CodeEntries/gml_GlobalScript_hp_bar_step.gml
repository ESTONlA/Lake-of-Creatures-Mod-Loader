function hp_bar_step()
{
    hp_bar_green = floor((hp / hp_max) * 18);
    if (reach_zero_enabled == false)
    {
        if (hp_bar_green < 1)
        {
            hp_bar_green = 1;
        }
    }
    else if (hp_bar_green < 1)
    {
        if (hp > 0)
        {
            hp_bar_green = 1;
        }
        else
        {
            hp_bar_green = 0;
        }
    }
    if (instance_exists(obj_player))
    {
        if (hp <= obj_player.melee_attack_dmg && melee_kill_effect == false && is_enemy == true)
        {
            melee_kill_effect = true;
            melee_kill_effect_alpha = 1.2;
        }
    }
    if (melee_kill_effect == true)
    {
        hp_remaining_alpha += ((0.8 - hp_remaining_alpha) * 0.2);
    }
    hp_bar_white += ((hp_bar_green - hp_bar_white) * 0.1);
    melee_kill_effect_alpha += ((0 - melee_kill_effect_alpha) * 0.1);
    hp_bar_xscale_ext += ((0 - hp_bar_xscale_ext) * 0.2);
    hp_bar_yscale_ext += ((0 - hp_bar_yscale_ext) * 0.2);
    flash_white_alpha += ((0 - flash_white_alpha) * 0.2);
    hp_bar_yy += ((0 - hp_bar_yy) * 0.25);
    if (hp <= 0 && flash_white_when_killed == true && has_flashed_white == false)
    {
        flash_white_alpha = 1;
        has_flashed_white = true;
    }
    if (hp <= 0 && shake_when_killed == true && has_shaked == false)
    {
        hp_bar_yy = 8;
        has_shaked = true;
    }
}
