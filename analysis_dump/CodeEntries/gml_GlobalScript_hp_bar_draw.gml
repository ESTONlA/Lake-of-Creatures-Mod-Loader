function hp_bar_draw(arg0, arg1, arg2)
{
    if (hp_max > 2 && hp != hp_max && is_boss == false && show_hp_bar == true && can_take_damage == true)
    {
        var offset_x = -11;
        var offset_y = -4;
        var draw_start_x = 0;
        var draw_start_y = 0;
        if (arg2 == true)
        {
            draw_start_x = x;
            draw_start_y = y;
        }
        var hp_spr_index = 2;
        if (is_champion == true)
        {
            hp_spr_index = 5;
        }
        var draw_y_offset = -20;
        var draw_x_final = draw_start_x + arg0;
        var draw_y_final = draw_start_y + arg1 + draw_y_offset + hp_bar_yy + hp_bar_yy_2 + hp_bar_yy_specific;
        if (is_enemy == false)
        {
            var cap_zone = 40;
            if (draw_x_final < cap_zone)
            {
                draw_x_final = cap_zone;
            }
            if (draw_y_final < cap_zone)
            {
                draw_y_final = cap_zone;
            }
            if (draw_x_final > (room_width - cap_zone))
            {
                draw_x_final = room_width - cap_zone;
            }
            if (draw_y_final > (room_height - cap_zone))
            {
                draw_y_final = room_height - cap_zone;
            }
        }
        draw_sprite_ext(spr_hp_bar, 3, draw_x_final, draw_y_final, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, 0, c_white, 1);
        draw_sprite_part_ext(spr_hp_bar, 4, 2, 0, hp_bar_white, 9, draw_x_final + 2 + offset_x, draw_y_final + offset_y + hp_bar_yy, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, c_white, hp_remaining_alpha);
        draw_sprite_ext(spr_hp_bar, 4, draw_x_final, draw_y_final, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, 0, c_white, flash_white_alpha);
        draw_sprite_part_ext(spr_hp_bar, hp_spr_index, 2, 0, hp_bar_green, 9, draw_x_final + 2 + offset_x, draw_y_final + offset_y + hp_bar_yy, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, c_white, hp_remaining_alpha);
        draw_sprite_ext(spr_hp_bar, 4, draw_x_final, draw_y_final, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, 0, c_white, melee_kill_effect_alpha);
        draw_sprite_ext(spr_hp_bar, 0, draw_x_final, draw_y_final, 1 + hp_bar_xscale_ext, 1 + hp_bar_yscale_ext, 0, c_white, 1);
    }
}
