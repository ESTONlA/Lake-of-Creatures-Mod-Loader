function draw_task_bar(arg0, arg1, arg2, arg3)
{
    var text_offset_y = -6;
    var progress_offset_x = 40;
    var progress_offset_y = 6;
    var current_task_value;
    if (arg3 == true)
    {
        current_task_value = global.task[arg2][2];
    }
    else
    {
        current_task_value = global.task[arg2][1];
    }
    var task_value = global.task[arg2][3];
    draw_set_alpha(0.3 * task_alpha);
    draw_set_color(global.color_outline);
    draw_rectangle(24, arg1 - 16, room_width - 24, arg1 + 16 + task_bar_yy[arg2], false);
    draw_set_alpha(1 * task_alpha);
    draw_set_color(global.color_outline);
    draw_rectangle((arg0 + progress_offset_x) - 40, (arg1 + progress_offset_y) - 4, arg0 + progress_offset_x + 40, arg1 + 2 + progress_offset_y + 4 + task_bar_yy[arg2], false);
    draw_set_alpha(1 * task_alpha);
    draw_set_color(c_gray);
    draw_rectangle((arg0 + progress_offset_x) - 38, (arg1 + progress_offset_y) - 2, arg0 + progress_offset_x + 38, arg1 + 2 + progress_offset_y + 2 + task_bar_yy[arg2], false);
    if (floor(current_task_value) != 0)
    {
        draw_set_color(c_white);
        var bar_length_temp = global.task[arg2][1] / global.task[arg2][3];
        if (bar_length_temp >= global.task[arg2][3])
        {
            bar_length_temp = global.task[arg2][3];
        }
        var bar_length = bar_length_temp * 76;
        if (bar_length >= 76)
        {
            bar_length = 76;
        }
        draw_rectangle((arg0 + progress_offset_x) - 38, (arg1 + progress_offset_y) - 2, ((arg0 + progress_offset_x) - 38) + bar_length, arg1 + 2 + progress_offset_y + 2 + task_bar_yy[arg2], false);
        draw_set_color(global.color_green);
        bar_length_temp = current_task_value / global.task[arg2][3];
        if (bar_length_temp >= global.task[arg2][3])
        {
            bar_length_temp = global.task[arg2][3];
        }
        bar_length = bar_length_temp * 76;
        if (bar_length >= 76)
        {
            bar_length = 76;
        }
        draw_rectangle((arg0 + progress_offset_x) - 38, (arg1 + progress_offset_y) - 2, ((arg0 + progress_offset_x) - 38) + bar_length, arg1 + 2 + progress_offset_y + 2 + task_bar_yy[arg2], false);
    }
    draw_set_alpha(task_bar_white_alpha[arg2] * task_alpha);
    draw_set_color(c_white);
    draw_rectangle((arg0 + progress_offset_x) - 38, (arg1 + progress_offset_y) - 2, arg0 + progress_offset_x + 38, arg1 + 2 + progress_offset_y + 2 + task_bar_yy[arg2], false);
    draw_set_font(global.font_current);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_alpha(1 * task_alpha);
    draw_set_color(global.color_outline);
    var task_name = "task_" + string(global.task[arg2][0]);
    var task_name_localized = txt(task_name);
    var task_name_with_value = string(task_name_localized, task_value);
    draw_text_outline_2x(arg0, arg1 + text_offset_y + task_bar_yy[arg2], task_name_with_value);
    draw_text_outline_2x(arg0 - progress_offset_x, arg1 + progress_offset_y + task_bar_yy[arg2] + task_bar_value_yy[arg2], string(floor(current_task_value)) + " / " + string(global.task[arg2][3]));
    if (global.task[arg2][2] != global.task[arg2][3])
    {
        draw_set_color(c_white);
    }
    else
    {
        draw_set_color(global.color_yellow);
    }
    draw_set_font(global.font_current);
    draw_text(arg0, arg1 + text_offset_y + task_bar_yy[arg2], task_name_with_value);
    draw_text(arg0 - progress_offset_x, arg1 + progress_offset_y + task_bar_yy[arg2] + task_bar_value_yy[arg2], string(floor(current_task_value)) + " / " + string(global.task[arg2][3]));
    draw_set_alpha(1);
    draw_set_color(c_white);
}
