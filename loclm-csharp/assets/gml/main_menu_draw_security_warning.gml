if (variable_global_exists("loclm_security_block_count") && global.loclm_security_block_count > 0)
{
    var loclm_about_open = false;
    if (variable_global_exists("loclm_menu_open"))
    {
        loclm_about_open = global.loclm_menu_open;
    }
    if (global.current_menu == 3 && loclm_about_open == false)
    {
        var warning_x = 18;
        var warning_y = room_height - 110;
        var warning_w = room_width - 36;
        var warning_h = 70;
        draw_set_alpha(0.86);
        draw_set_color(c_black);
        draw_rectangle(warning_x, warning_y, warning_x + warning_w, warning_y + warning_h, false);
        draw_set_alpha(1);
        draw_set_color(global.color_yellow);
        draw_rectangle(warning_x, warning_y, warning_x + warning_w, warning_y + warning_h, true);
        draw_set_font(global.font_current);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(global.color_yellow);
        draw_text(warning_x + 14, warning_y + 10, string(global.loclm_security_warning_title));
        draw_set_color(c_white);
        draw_text_ext(warning_x + 14, warning_y + 30, string(global.loclm_security_warning_body), 16, warning_w - 28);
        draw_set_alpha(1);
    }
}
