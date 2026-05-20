function draw_text_outline_b2x_scale(arg0, arg1, arg2, arg3, arg4)
{
    draw_text_transformed(arg0, arg1, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0, arg1 - (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0, arg1 - (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0, arg1 + (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0, arg1 + (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0, arg1 + 3, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1 + (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1 + (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1 - (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1 - (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1 + (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1 + (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1 - (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1 - (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1 + (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1 + (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1 - (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1 - (arg3 * 1), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1 + (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1 + (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1 - (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1 - (arg3 * 2), string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 1), arg1 + 3, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 1), arg1 + 3, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 + (arg3 * 2), arg1 + 3, string(arg2), arg3, arg4, 0);
    draw_text_transformed(arg0 - (arg3 * 2), arg1 + 3, string(arg2), arg3, arg4, 0);
}
