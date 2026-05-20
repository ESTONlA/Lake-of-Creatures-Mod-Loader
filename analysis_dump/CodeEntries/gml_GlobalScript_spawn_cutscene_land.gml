function spawn_cutscene_land()
{
    instance_create_depth(0, 0, -1501, obj_overworld_land_bg);
    var spawn_x = 256;
    var spawn_y = 151;
    var land_piece_amount = 40;
    var area_1_color = global.color_yellow_area2;
    var area_2_color = global.color_green;
    var area_3_color = global.color_green;
    var my_area = 1;
    for (var i = 0; i < land_piece_amount; i += 1)
    {
        my_area = 1;
        if (i > 10)
        {
            my_area = 2;
        }
        if (i > 20)
        {
            my_area = 3;
        }
        land = instance_create_depth(spawn_x + (i * 16), spawn_y + random_range(-4, 4), 0, obj_overworld_land);
        land.my_area = my_area;
    }
    var land = instance_create_depth(spawn_x, spawn_y, -25, obj_overworld_land);
    land.my_land_sprite = spr_player_select_head;
    land.land_sprite = global.playable_characters_selected;
    land.land_sprite_yy = -14;
    land.alarm[1] = 1;
    instance_create_depth(spawn_x - 39, spawn_y, 0, obj_overworld_land);
    land.scale_multiplier = 1.2;
    land.land_color_target = area_1_color;
    land.my_area = my_area;
    instance_create_depth(spawn_x - 26, spawn_y, 0, obj_overworld_land);
    land.scale_multiplier = 1.1;
    land.land_color_target = area_1_color;
    land.my_area = my_area;
    instance_create_depth(spawn_x - 13, spawn_y, 0, obj_overworld_land);
    land.scale_multiplier = 1.05;
    land.land_color_target = area_1_color;
    land.my_area = my_area;
    land = instance_create_depth(spawn_x - 33, spawn_y, 0, obj_overworld_land);
    land.land_sprite = 1;
    for (var i = 0; i < (land_piece_amount * 2); i += 1)
    {
        var land_ind = 2;
        if ((i % 4) == 0)
        {
            land_ind = 3;
        }
        if (i == 4)
        {
            land_ind = 4;
        }
        if (i == 8)
        {
            land_ind = 5;
        }
        if (i == 12)
        {
            land_ind = 6;
        }
        if (i == 16)
        {
            land_ind = 7;
        }
        if (i == 20)
        {
            land_ind = 8;
        }
        if (i == 24)
        {
            land_ind = 9;
        }
        land = instance_create_depth(spawn_x + (i * 16), spawn_y + choose(-1, 0, 1), 0, obj_overworld_land);
        land.land_sprite = land_ind;
        land.land_sprite_yy = -2;
    }
}
