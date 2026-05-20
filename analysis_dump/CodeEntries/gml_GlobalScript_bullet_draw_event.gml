function bullet_draw_event()
{
    if (melee_attack == false)
    {
        if (lob_shot == true)
        {
            draw_sprite_ext(sprite_index, image_index, x, y, img_xscale + xscale_ext, -img_yscale + -yscale_ext, image_angle, c_black, 0.35);
        }
        else
        {
            draw_sprite_ext(sprite_index, image_index, x, y + 18, img_xscale + xscale_ext, -img_yscale + -yscale_ext, image_angle, c_white, 0.1);
        }
    }
    if (global.new_bullet_style == false)
    {
        if (sprite_index != spr_melee_attack && sprite_index != spr_bullet_arrow && sprite_index != spr_harpoon && sprite_index != spr_flame)
        {
            draw_sprite_ext(sprite_index, image_index + 2, x, y + yy, (img_xscale + xscale_ext) * 1.4, (img_yscale + yscale_ext) * 1.4, image_angle, my_color, image_alpha - 0.7);
        }
        else if (sprite_index == spr_flame)
        {
            var floored_image_index = floor(image_index);
            if (floored_image_index < 10)
            {
                draw_sprite_ext(sprite_index, image_index + 2, x, y + yy, (img_xscale + xscale_ext) * 1.4, (img_yscale + yscale_ext) * 1.4, image_angle, my_color, image_alpha - 0.7);
            }
        }
    }
    if (global.new_bullet_style == false)
    {
        draw_sprite_ext(sprite_index, image_index, x, y + yy, img_xscale + xscale_ext, img_yscale + yscale_ext, image_angle, my_color, image_alpha);
    }
    else if (sprite_index == spr_melee_attack || sprite_index == spr_flame)
    {
        if (sprite_index == spr_flame)
        {
            draw_sprite_ext(sprite_index, image_index + 2, x, y + yy, (img_xscale + xscale_ext) * 1.4, (img_yscale + yscale_ext) * 1.4, image_angle, my_color, image_alpha - 0.7);
        }
        draw_sprite_ext(sprite_index, image_index, x, y + yy, img_xscale + xscale_ext, img_yscale + yscale_ext, image_angle, my_color, image_alpha);
    }
    else
    {
        draw_bullet();
    }
}
