function draw_task_bar_all(arg0, arg1)
{
    if (arg1 == true)
    {
        draw_set_alpha(0.5 * task_alpha);
        draw_set_color(global.color_outline);
        draw_rectangle(-1000, -1000, 1000, 1000, false);
        draw_set_color(c_white);
        draw_set_alpha(1);
    }
    for (var i = 0; i < 4; i += 1)
    {
        draw_task_bar(x_middle, (y_middle - 50) + (i * 40) + draw_offset_y, i, arg0);
    }
    var unlock_text_x = x_middle + 104 + 32;
    var unlock_text_y = (y_middle - 50) + 160;
    draw_set_alpha(0.3 * task_alpha);
    draw_set_color(global.color_outline);
    draw_rectangle(unlock_text_x - 72, (unlock_text_y - 16) + draw_offset_y, unlock_text_x + 72, unlock_text_y + 16 + draw_offset_y, false);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(1 * task_alpha);
    draw_set_color(global.color_outline);
    draw_set_font(global.font_current);
    var tasks_to_unlock_localized = txt("tasks_to_unlock_A");
    if (global.tasks_left <= 1)
    {
        tasks_to_unlock_localized = txt("tasks_to_unlock_B");
    }
    var tasks_to_unlock_with_value = string(tasks_to_unlock_localized, global.tasks_left);
    draw_text_outline_2x(unlock_text_x, (unlock_text_y + draw_offset_y) - 6, tasks_to_unlock_with_value);
    draw_text_outline_2x(unlock_text_x, unlock_text_y + draw_offset_y + 5, txt("tasks_to_unlock_C"));
    draw_set_color(c_white);
    draw_text(unlock_text_x, (unlock_text_y + draw_offset_y) - 6, tasks_to_unlock_with_value);
    draw_text(unlock_text_x, unlock_text_y + draw_offset_y + 5, txt("tasks_to_unlock_C"));
    draw_set_alpha(1);
    draw_set_color(c_white);
}
