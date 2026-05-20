function draw_map(arg0, arg1, arg2)
{
    if (room_special_icon == 4)
    {
        draw_sprite_ext(spr_world_gen_tile_icons, 4, arg0, arg1, 1, 1, 0, c_white, arg2);
    }
    else if (room_special_icon == 2)
    {
        if (visited == true)
        {
            draw_sprite_ext(spr_world_gen_tile_icons, 2, arg0, arg1, 1, 1, 0, c_white, arg2);
        }
    }
    else
    {
        var gold_crickets = false;
        if (cricket_pickups > 0)
        {
            for (var i = 0; i < cricket_pickups; i += 1)
            {
                var cricket_spr = cricket_pickup_array[i][2];
                if (cricket_spr == spr_cricket_gold)
                {
                    gold_crickets = true;
                }
            }
        }
        if (gold_crickets == true)
        {
            draw_sprite_ext(spr_world_gen_tile_icons, 22, arg0, arg1, 1, 1, 0, c_white, arg2);
            draw_sprite_ext(spr_world_gen_tile_icons, 23, arg0, arg1, 1, 1, 0, c_white, arg2 * wave_effect(0, 0.8, 1.4, 0));
        }
        else
        {
            var is_leaf = false;
            if (nonsolid_objects > 0)
            {
                for (var i = 0; i < nonsolid_objects; i += 1)
                {
                    if (nonsolid_array[i][2] == spr_leaf)
                    {
                        is_leaf = true;
                    }
                }
            }
            if (is_leaf == true)
            {
                draw_sprite_ext(spr_world_gen_tile_icons, 24, arg0, arg1, 1, 1, 0, c_white, arg2);
            }
            else if (items > 0)
            {
                if (evil_clam_room == false)
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 8, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
                else
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 28, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
            }
            else
            {
                var treasures_in_clam = false;
                if (clams > 0)
                {
                    for (var i = 0; i < clams; i += 1)
                    {
                        if (clams_array[i][2] == 0)
                        {
                            treasures_in_clam = true;
                        }
                    }
                }
                if (treasures_in_clam == true)
                {
                    if (evil_clam_room == false)
                    {
                        draw_sprite_ext(spr_world_gen_tile_icons, 8, arg0, arg1, 1, 1, 0, c_white, arg2);
                    }
                    else
                    {
                        draw_sprite_ext(spr_world_gen_tile_icons, 28, arg0, arg1, 1, 1, 0, c_white, arg2);
                    }
                }
                else if (sausage_room == true && sausage_room_cleared == false && visited == true)
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 30, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
                else if (chests > 0)
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 19, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
                else if (weapon_pickups > 0)
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 5, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
                else if (pickup_items > 0)
                {
                    var pickup_icon_to_draw = 6;
                    for (var i = 0; i < pickup_items; i += 1)
                    {
                        var pickup = pickup_items_array[i][2];
                        switch (pickup)
                        {
                            case spr_coin_pickup:
                                pickup_icon_to_draw = 20;
                                break;
                            case spr_coin_pickup_silver:
                                pickup_icon_to_draw = 20;
                                break;
                            case spr_coin_pickup_bloody:
                                pickup_icon_to_draw = 20;
                                break;
                            case spr_pickup_key:
                                pickup_icon_to_draw = 7;
                                break;
                            case spr_pickup_key_bloody:
                                pickup_icon_to_draw = 7;
                                break;
                            case spr_hp_pickup:
                                pickup_icon_to_draw = 6;
                                break;
                            case spr_hp_extra_pickup:
                                pickup_icon_to_draw = 6;
                                break;
                        }
                    }
                    draw_sprite_ext(spr_world_gen_tile_icons, pickup_icon_to_draw, arg0, arg1, 1, 1, 0, c_white, arg2);
                }
                else if (room_special_icon == 3)
                {
                    if (visited == true)
                    {
                        if (evil_clam_room == false)
                        {
                            draw_sprite_ext(spr_world_gen_tile_icons, 18, arg0, arg1, 1, 1, 0, c_white, arg2);
                        }
                        else
                        {
                            draw_sprite_ext(spr_world_gen_tile_icons, 29, arg0, arg1, 1, 1, 0, c_white, arg2);
                        }
                    }
                }
                else if (fish_left > 0)
                {
                    draw_sprite_ext(spr_world_gen_tile_icons, 10, arg0, arg1, 1, 1, 0, c_white, arg2);
                    if (instance_exists(obj_fish_consumer))
                    {
                        with (obj_fish_consumer)
                        {
                            if (room_id == other.id)
                            {
                                if (time_until_despawn <= 0)
                                {
                                    with (other)
                                    {
                                        draw_sprite_ext(spr_world_gen_tile_icons, 21, arg0, arg1, 1, 1, 0, c_white, arg2);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
