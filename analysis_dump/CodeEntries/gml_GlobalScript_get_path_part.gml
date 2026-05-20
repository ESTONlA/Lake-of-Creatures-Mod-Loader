function get_path_part()
{
    if (place_meeting(x - 16, y, obj_tile_single_path) || place_meeting(x + 16, y, obj_tile_single_path))
    {
        sprite_index = hor_sprite;
        if (place_meeting(x - 16, y, obj_tile_single_path) && place_meeting(x + 16, y, obj_tile_single_path))
        {
            image_index = 1;
        }
        else if (place_meeting(x - 16, y, obj_tile_single_path) && !place_meeting(x + 16, y, obj_tile_single_path))
        {
            image_index = 2;
        }
        else if (!place_meeting(x - 16, y, obj_tile_single_path) && place_meeting(x + 16, y, obj_tile_single_path))
        {
            image_index = 0;
        }
        y += choose(-1, 0, 1);
    }
    if (place_meeting(x, y - 16, obj_tile_single_path) || place_meeting(x, y + 16, obj_tile_single_path))
    {
        sprite_index = ver_sprite;
        if (place_meeting(x, y - 16, obj_tile_single_path) && place_meeting(x, y + 16, obj_tile_single_path))
        {
            image_index = 1;
        }
        else if (place_meeting(x, y - 16, obj_tile_single_path) && !place_meeting(x, y + 16, obj_tile_single_path))
        {
            image_index = 2;
        }
        else if (!place_meeting(x, y - 16, obj_tile_single_path) && place_meeting(x, y + 16, obj_tile_single_path))
        {
            image_index = 0;
        }
        x += choose(-1, 0, 1);
    }
}
