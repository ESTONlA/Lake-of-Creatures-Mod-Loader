function draw_outfit()
{
    var outfit_y = 0;
    if (image_index >= 3 && image_index <= 8)
    {
        outfit_y = 1;
    }
    variation_index = global.playable_characters_selected;
    if (image_alpha < 0.95)
    {
        outfit_alpha += approach(outfit_alpha, 0, 0.2);
    }
    else
    {
        outfit_alpha += approach(outfit_alpha, 1, 0.2);
    }
    if (global.player_is_dead == false)
    {
        for (var i = 1; i < array_length(outfit_array); i += 1)
        {
            draw_sprite_ext(outfit_array[i], variation_index, x, y + outfit_y, sprite_xscale + xscale_ext, image_yscale + yscale_ext, 0 + img_angle_ext, c_white, outfit_alpha);
        }
    }
}
