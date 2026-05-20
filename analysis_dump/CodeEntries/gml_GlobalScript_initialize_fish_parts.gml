function initialize_fish_parts()
{
    for (var i = 0; i < body_parts; i += 1)
    {
        body_part_angle[i] = direction - 180;
        body_part_sprite[i] = spr_fish_body;
        body_part_offset[i] = 6;
        if (i == 0)
        {
            body_part_x[i] = x;
            body_part_y[i] = y;
            body_part_sprite[i] = spr_fish_eye;
            body_part_offset[i] = body_part_offset[i] - 1;
        }
        else
        {
            body_part_x[i] = body_part_x[i - 1] + lengthdir_x(body_part_offset[i], body_part_angle[i]);
            body_part_y[i] = body_part_y[i - 1] + lengthdir_y(body_part_offset[i], body_part_angle[i]);
        }
        if (i == (body_parts - 1))
        {
            body_part_sprite[i] = spr_fish_tail;
            body_part_offset[i] = body_part_offset[i] + 2;
        }
    }
}
