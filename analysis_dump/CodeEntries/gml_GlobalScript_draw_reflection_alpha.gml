function draw_reflection_alpha(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
{
    for (i = 0; i < arg2; i += 1)
    {
        if ((timer % 5) == 0)
        {
            x_offset[i] = choose(-1, 0, 0, 1);
        }
        draw_sprite_part_ext(arg4, arg5, 0, arg2 - i, sprite_width, 1, ((x + (image_xscale * arg3) + arg0) - (sprite_width / 2)) + x_offset[i], (y - (sprite_height / 2)) + arg1 + i, image_xscale, image_yscale, arg6, arg7);
    }
}
