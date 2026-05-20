function draw_fish(arg0, arg1)
{
    var i = body_parts - 1;
    while (i >= 0)
    {
        if (i == 0)
        {
            draw_sprite_ext(spr_fish_mouth, mouth_index, body_part_x[i] + random_range(-shake_intensivity, shake_intensivity), body_part_y[i] + arg1 + random_range(-shake_intensivity, shake_intensivity), 1, 1, body_part_angle[i] - 180, c_white, arg0);
        }
        img_index = 0;
        var sprite_to_draw = spr_fish_body;
        switch (body_part_sprite[i])
        {
            case spr_fish_body:
                img_index = body_index_1;
                if (double_colored == true)
                {
                    if ((i % 2) == 1)
                    {
                        img_index = body_index_2;
                    }
                }
                sprite_to_draw = body_sprite;
                break;
            case spr_fish_eye:
                img_index = fish_type;
                sprite_to_draw = spr_fish_eye;
                break;
            case spr_fish_tail:
                img_index = tail_index;
                sprite_to_draw = tail_sprite;
                break;
        }
        draw_sprite_ext(sprite_to_draw, img_index, body_part_x[i] + random_range(-shake_intensivity, shake_intensivity), body_part_y[i] + arg1 + random_range(-shake_intensivity, shake_intensivity), 1, 1, body_part_angle[i] - 180, c_white, arg0);
        i -= 1;
    }
}
