function get_weapon_variables_from_items()
{
    if (global.item_bomb_shot == true)
    {
        if (global.weapon_bullet_sprite == spr_bullet_arrow)
        {
            global.weapon_bullet_sprite = spr_bullet_bomb;
        }
    }
}
