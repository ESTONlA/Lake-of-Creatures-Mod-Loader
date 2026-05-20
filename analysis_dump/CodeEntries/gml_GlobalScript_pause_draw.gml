function pause_draw(arg0)
{
    if (sprite_exists(pause_sprite))
    {
    }
    draw_sprite_ext(spr_pause_screen, pause_screen_index, view_x_current + 240, view_y_current + 135, pause_scale, pause_scale, 0, c_white, 1);
    draw_set_color(arg0);
    draw_set_alpha(wave_effect(0.4, 0.55, 7, 0) * pause_screen_bg_alpha);
    draw_rectangle(-1000, -1000, 1000, 1000, false);
    draw_set_color(c_white);
    draw_set_alpha(1);
    draw_sprite_ext(spr_overlay_darkness, 0, view_x_current + 240, view_y_current + 135, 1, 1, 0, c_white, pause_alpha - 0.2);
}
