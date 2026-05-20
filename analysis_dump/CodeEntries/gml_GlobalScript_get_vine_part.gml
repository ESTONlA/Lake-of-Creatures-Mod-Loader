function get_vine_part()
{
    if (place_meeting(x - 16, y, obj_solid_half) || place_meeting(x + 16, y, obj_solid_half))
    {
        sprite_index = spr_vine_hor;
        if (place_meeting(x - 16, y, obj_solid_half) && place_meeting(x + 16, y, obj_solid_half))
        {
            image_index = 1;
        }
        else if (place_meeting(x - 16, y, obj_solid_half) && !place_meeting(x + 16, y, obj_solid_half))
        {
            image_index = 2;
        }
        else if (!place_meeting(x - 16, y, obj_solid_half) && place_meeting(x + 16, y, obj_solid_half))
        {
            image_index = 0;
        }
        draw_y_offset += choose(-1, 0, 1);
    }
    if (place_meeting(x, y - 16, obj_solid_half) || place_meeting(x, y + 16, obj_solid_half))
    {
        sprite_index = spr_vine_ver;
        if (place_meeting(x, y - 16, obj_solid_half) && place_meeting(x, y + 16, obj_solid_half))
        {
            image_index = 1;
        }
        else if (place_meeting(x, y - 16, obj_solid_half) && !place_meeting(x, y + 16, obj_solid_half))
        {
            image_index = 2;
        }
        else if (!place_meeting(x, y - 16, obj_solid_half) && place_meeting(x, y + 16, obj_solid_half))
        {
            image_index = 0;
        }
        draw_x_offset += choose(-1, 0, 1);
    }
}
