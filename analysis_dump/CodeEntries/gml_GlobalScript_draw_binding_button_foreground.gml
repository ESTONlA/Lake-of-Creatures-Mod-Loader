function draw_binding_button_foreground(arg0, arg1, arg2, arg3, arg4, arg5)
{
    draw_set_color(arg4);
    var binding_sprite_short = string_copy(string(arg3), 1, 3);
    if (string(binding_sprite_short) != "ref" || arg5 == false)
    {
        draw_text(arg0, arg1, binding_current_name);
    }
    else
    {
        draw_sprite_ext(binding_current_sprite, 0, arg0, arg1, 1, 1, 0, arg4, 1);
        draw_sprite_ext(binding_current_sprite, 1, arg0, arg1, 1, 1, 0, c_white, 1);
    }
    draw_set_color(c_white);
}
