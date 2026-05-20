function spawn_room_layout(arg0)
{
    var room_spawn_enabled = true;
    if (room == rm_overworld_2 || room == rm_overworld_3 || room == rm_overworld_secret_1)
    {
        room_spawn_enabled = false;
    }
    if (room_spawn_enabled == true)
    {
        switch (arg0)
        {
            case 1:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 13; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 2:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 13; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 3:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 4:
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 5:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 6:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 48 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 7:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 8:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 17; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 9:
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 10:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 11:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 12:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 35; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 13:
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 14:
                for (i = 0; i <= 21; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
            case 15:
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 4; ii += 1)
                    {
                        instance_create_depth(464 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), -16 + (i * 16), 0, obj_tile_single);
                    }
                }
                for (i = 0; i <= 4; i += 1)
                {
                    for (ii = 0; ii <= 5; ii += 1)
                    {
                        instance_create_depth(-32 + (ii * 16), 256 + (i * 16), 0, obj_tile_single);
                    }
                }
                break;
        }
    }
    if (instance_exists(obj_tile_single))
    {
        obj_tile_single.alarm[0] = 1;
    }
    if (instance_exists(obj_water_new_spawner))
    {
        obj_water_new_spawner.alarm[1] = 1;
    }
    if (instance_exists(obj_tile_single_B))
    {
        with (obj_tile_single_B)
        {
            if (place_meeting(x, y, obj_tile_single))
            {
                oth = instance_place(x, y, obj_tile_single);
                instance_destroy(oth);
            }
        }
    }
}
