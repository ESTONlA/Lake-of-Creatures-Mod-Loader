function draw_reflection_player_character(arg0)
{
    for (i = 0; i < arg0.sprite_height; i += 1)
    {
        if ((arg0.timer % 5) == 0)
        {
            arg0.x_offset[i] = choose(-1, 0, 0, 1);
        }
        draw_sprite_part_ext(arg0.sprite_index, arg0.image_index, 0, 50 - i, 50, 1, (arg0.x - (arg0.sprite_width / 2)) + (arg0.image_xscale * 3) + arg0.x_offset[i], (arg0.y - (arg0.sprite_height / 2)) + 10 + -abs(arg0.img_angle_ext * 0.2) + i, arg0.image_xscale, arg0.image_yscale, c_white, 0.4);
    }
}
