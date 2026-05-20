function draw_sprite_outline()
{
    draw_sprite_ext(outline_sprite_index, image_index, x + 1, y, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x + 2, y, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x - 1, y, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x - 2, y, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x, y - 1, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x, y - 2, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x + 1, y - 1, image_xscale, image_yscale, image_angle, c_white, 1);
    draw_sprite_ext(outline_sprite_index, image_index, x - 1, y - 1, image_xscale, image_yscale, image_angle, c_white, 1);
}
