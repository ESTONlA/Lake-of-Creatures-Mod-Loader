function get_tile(arg0)
{
    if (arg0 == false)
    {
        if (get_lake_type(global.current_lake) == 1)
        {
            sprite_index = choose(spr_tiles_world_1, spr_tiles_world_1, spr_tiles_world_1B);
            secret_room_sprite = spr_tiles_world_1_secret;
            foliage_sprite = spr_tiles_world_1_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
        if (get_lake_type(global.current_lake) == 2)
        {
            sprite_index = choose(spr_tiles_world_2, spr_tiles_world_2, spr_tiles_world_2);
            secret_room_sprite = spr_tiles_world_2_secret;
            foliage_sprite = spr_tiles_world_2_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
        if (get_lake_type(global.current_lake) == 3)
        {
            sprite_index = choose(spr_tiles_world_3, spr_tiles_world_3, spr_tiles_world_3);
            secret_room_sprite = spr_tiles_world_3_secret;
            foliage_sprite = spr_tiles_world_3_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
        if (get_lake_type(global.current_lake) == 4)
        {
            sprite_index = choose(spr_tiles_world_4, spr_tiles_world_4, spr_tiles_world_4);
            secret_room_sprite = spr_tiles_world_4_secret;
            foliage_sprite = spr_tiles_world_4_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
    }
    else
    {
        if (get_lake_type(global.current_lake) == 1)
        {
            sprite_index = choose(spr_tiles_world_1_alt, spr_tiles_world_1_alt, spr_tiles_world_1B_alt);
            secret_room_sprite = spr_tiles_world_1_secret;
            foliage_sprite = spr_tiles_world_1_alt_foliage;
        }
        if (get_lake_type(global.current_lake) == 2)
        {
            sprite_index = choose(spr_tiles_world_2_alt, spr_tiles_world_2_alt, spr_tiles_world_2_alt);
            secret_room_sprite = spr_tiles_world_2B_secret;
            foliage_sprite = spr_empty_sprite;
            bloody_sprite = spr_tiles_world_1_blood;
        }
        if (get_lake_type(global.current_lake) == 3)
        {
            sprite_index = choose(spr_tiles_world_3_alt, spr_tiles_world_3_alt, spr_tiles_world_3_alt);
            secret_room_sprite = spr_tiles_world_3B_secret;
            foliage_sprite = spr_tiles_world_3_alt_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
        if (get_lake_type(global.current_lake) == 4)
        {
            sprite_index = choose(spr_tiles_world_4_alt, spr_tiles_world_4_alt, spr_tiles_world_4_alt);
            secret_room_sprite = spr_tiles_world_4B_secret;
            foliage_sprite = spr_tiles_world_4_alt_foliage;
            bloody_sprite = spr_tiles_world_1_blood;
        }
    }
}
