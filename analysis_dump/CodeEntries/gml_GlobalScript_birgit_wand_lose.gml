function birgit_wand_lose()
{
    if (global.playable_characters_selected == 1)
    {
        if (melee_attack == false)
        {
            if (global.birgit_wand_misses_left > 0)
            {
                if (global.player_weapon_current == 1)
                {
                    text_missed("MISS!", "");
                    global.birgit_wand_alpha = 0.8;
                    global.birgit_wand_misses_left -= 1;
                }
            }
        }
    }
}
