function draw_character_equipment(arg0, arg1, arg2, arg3)
{
    switch (arg0)
    {
        case 0:
            var gun_sprite = spr_weapon_pistol_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            break;
        case 1:
            var gun_sprite = spr_weapon_ap_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            draw_sprite_ext(spr_item_black, 66, arg1 + arg3 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(spr_item_black, 66, (arg1 + arg3) - 1, arg2 - 1);
            break;
        case 2:
            var gun_sprite = spr_weapon_sawed_off_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            draw_sprite_ext(spr_item_black, 64, arg1 + arg3 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(spr_item_black, 64, (arg1 + arg3) - 1, arg2 - 1);
            break;
        case 3:
            var gun_sprite = spr_weapon_flamethrower_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            draw_sprite_ext(spr_item_black, 104, arg1 + arg3 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(spr_item_black, 104, (arg1 + arg3) - 1, arg2 - 1);
            break;
        case 4:
            var gun_sprite = spr_weapon_pinkuzi_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            draw_sprite_ext(spr_item_black, 59, arg1 + arg3 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(spr_item_black, 59, (arg1 + arg3) - 1, arg2 - 1);
            break;
        case 5:
            var gun_sprite = spr_weapon_lasergun_hud;
            draw_sprite_ext(gun_sprite, 0, arg1 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(gun_sprite, 0, arg1 - 1, arg2 - 1);
            draw_sprite_ext(spr_item_black, 34, arg1 + arg3 + 1, arg2 + 1, 1, 1, 0, c_black, 0.4);
            draw_sprite(spr_item_black, 34, (arg1 + arg3) - 1, arg2 - 1);
            break;
    }
}
