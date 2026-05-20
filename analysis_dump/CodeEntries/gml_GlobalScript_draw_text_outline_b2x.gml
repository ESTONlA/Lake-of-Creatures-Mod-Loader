function draw_text_outline_b2x(arg0, arg1, arg2)
{
    draw_text(arg0, arg1, string(arg2));
    draw_text(arg0 - 1, arg1, string(arg2));
    draw_text(arg0 - 2, arg1, string(arg2));
    draw_text(arg0 + 1, arg1, string(arg2));
    draw_text(arg0 + 2, arg1, string(arg2));
    draw_text(arg0, arg1 - 1, string(arg2));
    draw_text(arg0, arg1 - 2, string(arg2));
    draw_text(arg0, arg1 + 1, string(arg2));
    draw_text(arg0, arg1 + 2, string(arg2));
    draw_text(arg0, arg1 + 3, string(arg2));
    draw_text(arg0 + 1, arg1 + 1, string(arg2));
    draw_text(arg0 - 1, arg1 + 1, string(arg2));
    draw_text(arg0 + 1, arg1 - 1, string(arg2));
    draw_text(arg0 - 1, arg1 - 1, string(arg2));
    draw_text(arg0 + 1, arg1 + 2, string(arg2));
    draw_text(arg0 - 1, arg1 + 2, string(arg2));
    draw_text(arg0 + 1, arg1 - 2, string(arg2));
    draw_text(arg0 - 1, arg1 - 2, string(arg2));
    draw_text(arg0 + 2, arg1 + 1, string(arg2));
    draw_text(arg0 - 2, arg1 + 1, string(arg2));
    draw_text(arg0 + 2, arg1 - 1, string(arg2));
    draw_text(arg0 - 2, arg1 - 1, string(arg2));
    draw_text(arg0 + 2, arg1 + 2, string(arg2));
    draw_text(arg0 - 2, arg1 + 2, string(arg2));
    draw_text(arg0 + 2, arg1 - 2, string(arg2));
    draw_text(arg0 - 2, arg1 - 2, string(arg2));
    draw_text(arg0 + 1, arg1 + 3, string(arg2));
    draw_text(arg0 - 1, arg1 + 3, string(arg2));
    draw_text(arg0 + 2, arg1 + 3, string(arg2));
    draw_text(arg0 - 2, arg1 + 3, string(arg2));
}
