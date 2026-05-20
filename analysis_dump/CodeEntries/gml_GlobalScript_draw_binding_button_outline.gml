function draw_binding_button_outline(arg0, arg1, arg2, arg3, arg4)
{
    draw_set_color(global.color_outline);
    var binding_sprite_short = string_copy(string(arg3), 1, 3);
    if (string(binding_sprite_short) != "ref" || arg4 == false)
    {
        draw_text_outline_b2x(arg0, arg1, binding_current_name);
    }
    draw_set_color(c_white);
}
