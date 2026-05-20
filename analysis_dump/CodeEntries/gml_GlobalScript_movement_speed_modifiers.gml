function movement_speed_modifiers(arg0)
{
    result = 1;
    if (place_meeting(x, y, obj_mud))
    {
        result -= 0.4;
    }
    if (place_meeting(x, y, obj_grass_block))
    {
        var oth = instance_place(x, y, obj_grass_block);
        if (oth.sprite_index == spr_grass_block_world_2)
        {
            result -= 0.15;
        }
    }
    if (place_meeting(x, y, obj_oil))
    {
        var oth = instance_place(x, y, obj_oil);
        if (oth.landed == true)
        {
            result += 1;
        }
    }
    if (arg0)
    {
        if (global.playable_characters_selected == 4)
        {
            if (place_meeting(x, y, obj_water_deep_hitbox))
            {
                result -= 0.65;
                deep_water_slowdown = 30;
            }
            else if (deep_water_slowdown > 0)
            {
                deep_water_slowdown -= 1;
                result -= 0.65;
            }
        }
    }
    if (arg0 == false)
    {
        if (wall_collisions_enabled == false)
        {
            result = 1;
        }
    }
    if (arg0 == false)
    {
        if (place_meeting(x, y, obj_honey_drop))
        {
            result -= 0.6;
        }
    }
    if (arg0 == false)
    {
        result *= global.difficulty_mod_enemy_speed;
    }
    if (result < 0.3)
    {
        result = 0.3;
    }
    return result;
}
