function get_tile_dark(arg0)
{
    if (arg0 == false)
    {
        if (get_lake_type(global.current_lake) == 1)
        {
            sprite_index = spr_tiles_world_1_dark;
            foliage_sprite = spr_tiles_world_1_foliage_dark;
        }
        if (get_lake_type(global.current_lake) == 2)
        {
            sprite_index = spr_tiles_world_2_dark;
            foliage_sprite = spr_tiles_world_2_foliage_dark;
        }
        if (get_lake_type(global.current_lake) == 3)
        {
            sprite_index = spr_tiles_world_3_dark;
            foliage_sprite = spr_tiles_world_3_foliage_dark;
        }
        if (get_lake_type(global.current_lake) == 4)
        {
            sprite_index = spr_tiles_world_4_dark;
            foliage_sprite = spr_tiles_world_4_foliage_dark;
        }
    }
    else
    {
        if (get_lake_type(global.current_lake) == 1)
        {
            sprite_index = spr_tiles_world_1_dark_alt;
            foliage_sprite = spr_tiles_world_1_foliage_dark_alt;
        }
        if (get_lake_type(global.current_lake) == 2)
        {
            sprite_index = spr_tiles_world_2_dark_alt;
            foliage_sprite = spr_tiles_world_2_foliage_dark_alt;
        }
        if (get_lake_type(global.current_lake) == 3)
        {
            sprite_index = spr_tiles_world_3_dark_alt;
            foliage_sprite = spr_tiles_world_3_foliage_dark_alt;
        }
        if (get_lake_type(global.current_lake) == 4)
        {
            sprite_index = spr_tiles_world_4_dark_alt;
            foliage_sprite = spr_tiles_world_4_foliage_dark_alt;
        }
    }
}
