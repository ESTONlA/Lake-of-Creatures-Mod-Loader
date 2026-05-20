function draw_text_outline(arg0, arg1, arg2)
{
    draw_text(arg0, arg1, string(arg2));
    draw_text(arg0 - 1, arg1, string(arg2));
    draw_text(arg0 + 1, arg1, string(arg2));
    draw_text(arg0, arg1 - 1, string(arg2));
    draw_text(arg0, arg1 + 1, string(arg2));
    draw_text(arg0, arg1 + 2, string(arg2));
    draw_text(arg0 + 1, arg1 + 1, string(arg2));
    draw_text(arg0 - 1, arg1 + 1, string(arg2));
    draw_text(arg0 + 1, arg1 - 1, string(arg2));
    draw_text(arg0 - 1, arg1 - 1, string(arg2));
}
