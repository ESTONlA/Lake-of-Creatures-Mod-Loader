function dynamic_tile(arg0, arg1)
{
    if (!tile_meeting("top", arg0, arg1) && !tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 0;
        image_index_dynamically_chosen = true;
    }
    if (!tile_meeting("top", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 1;
        image_index_dynamically_chosen = true;
    }
    if (!tile_meeting("top", arg0, arg1) && tile_meeting("left", arg0, arg1) && !tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1))
    {
        image_index = 2;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && !tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 3;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 4;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("left", arg0, arg1) && !tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1))
    {
        image_index = 5;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && !tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && !tile_meeting("bottom", arg0, arg1))
    {
        image_index = 6;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && !tile_meeting("bottom", arg0, arg1))
    {
        image_index = 7;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("left", arg0, arg1) && !tile_meeting("right", arg0, arg1) && !tile_meeting("bottom", arg0, arg1))
    {
        image_index = 8;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && !tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 9;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && !tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 10;
        image_index_dynamically_chosen = true;
    }
    if (tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && !tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 11;
        image_index_dynamically_chosen = true;
    }
    if (!tile_meeting("top_left", arg0, arg1) && tile_meeting("top", arg0, arg1) && tile_meeting("top_right", arg0, arg1) && tile_meeting("left", arg0, arg1) && tile_meeting("right", arg0, arg1) && tile_meeting("bottom_left", arg0, arg1) && tile_meeting("bottom", arg0, arg1) && tile_meeting("bottom_right", arg0, arg1))
    {
        image_index = 12;
        image_index_dynamically_chosen = true;
    }
}
