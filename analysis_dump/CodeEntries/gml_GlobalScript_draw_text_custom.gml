function draw_text_custom(arg0, arg1, arg2)
{
    var str_len = string_length(arg2);
    var length_between_characters = 8;
    for (var i = 1; i <= str_len; i += 1)
    {
        cc = string_char_at(arg2, i);
        draw_set_color(global.color_outline);
        draw_text_outline_b2x(arg0 + (i * length_between_characters), arg1, cc);
        draw_set_color(c_white);
        draw_text(arg0 + (i * length_between_characters), arg1, cc);
    }
}
