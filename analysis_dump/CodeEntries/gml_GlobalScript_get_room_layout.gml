function get_room_layout()
{
    if (place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 1;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 2;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 3;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 4;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 5;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 6;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 7;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 8;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 9;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 10;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && !place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 11;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && !place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 12;
    }
    if (!place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 13;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && !place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 14;
    }
    if (place_meeting(x - 16, y, obj_world_gen_block) && place_meeting(x + 16, y, obj_world_gen_block) && place_meeting(x, y - 16, obj_world_gen_block) && place_meeting(x, y + 16, obj_world_gen_block))
    {
        return 15;
    }
}
