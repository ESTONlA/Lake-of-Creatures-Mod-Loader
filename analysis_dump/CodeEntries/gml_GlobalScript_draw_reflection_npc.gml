function draw_reflection_npc(arg0)
{
    for (i = 0; i < sprite_height; i += 1)
    {
        if ((timer % 5) == 0)
        {
            x_offset[i] = choose(-1, 0, 0, 1);
        }
        draw_sprite_part_ext(sprite_index, image_index, 0, 50 - i, 50, 1, (x - (sprite_width / 2)) + (image_xscale * 3) + x_offset[i], (y - (sprite_height / 2)) + 10 + -abs(img_angle_ext * 0.2) + i, image_xscale, image_yscale, c_white, 0.4);
    }
}
