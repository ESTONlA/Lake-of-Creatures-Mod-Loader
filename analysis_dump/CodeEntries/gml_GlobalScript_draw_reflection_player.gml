function draw_reflection_player()
{
    for (i = 0; i < obj_player.sprite_height; i += 1)
    {
        if ((obj_player.timer % 5) == 0)
        {
            obj_player.x_offset[i] = choose(-1, 0, 0, 1);
        }
        draw_sprite_part_ext(obj_player.sprite_index, obj_player.image_index, 0, 50 - i, 50, 1, (obj_player.x - (obj_player.sprite_width / 2)) + (obj_player.image_xscale * 3) + obj_player.x_offset[i], (obj_player.y - (obj_player.sprite_height / 2)) + 10 + -abs(obj_player.img_angle_ext * 0.2) + i, obj_player.image_xscale, obj_player.image_yscale, c_white, 0.4);
    }
}
