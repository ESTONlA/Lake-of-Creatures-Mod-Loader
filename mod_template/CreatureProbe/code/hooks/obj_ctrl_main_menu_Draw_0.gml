if (global.current_menu == 7)
{
    var x_middle = room_width / 2;
    var y_middle = room_height / 2;
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_font(global.font_current);
    draw_set_color(global.color_outline);
    draw_rectangle(x_middle - 124, y_middle - 44, x_middle + 124, y_middle + 68, true);
    draw_set_color(c_black);
    draw_rectangle(x_middle - 122, y_middle - 42, x_middle + 122, y_middle + 66, false);
    draw_set_color(global.color_yellow);
    draw_text_outline_b2x(x_middle, y_middle - 12, __MENU_TAB_TITLE__);
    draw_set_color(c_white);
    draw_text(x_middle, y_middle + 14, __MENU_TAB_BODY__);
    draw_text(x_middle, y_middle + 32, "Press Back or leave to return.");
}
