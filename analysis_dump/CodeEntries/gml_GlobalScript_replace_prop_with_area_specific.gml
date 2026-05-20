function replace_prop_with_area_specific(arg0)
{
    if (global.run_ongoing == false)
    {
        exit;
    }
    var replace = false;
    switch (get_lake_type(global.current_lake))
    {
        case 2:
            switch (arg0)
            {
                case 1:
                    instance_create_depth(x, y, depth, obj_mushroom_01);
                    replace = true;
                    break;
                case 2:
                    instance_create_depth(x, y, depth, obj_mushroom_02);
                    replace = true;
                    break;
                case 3:
                    instance_create_depth(x, y, depth, obj_mushroom_01);
                    replace = true;
                    break;
                case 4:
                    instance_create_depth(x, y, depth, obj_mushroom_01);
                    replace = true;
                    break;
            }
            break;
        case 3:
            switch (arg0)
            {
                case 1:
                    instance_create_depth(x, y, depth, obj_crystal_01);
                    replace = true;
                    break;
                case 2:
                    instance_create_depth(x, y, depth, obj_crystal_02);
                    replace = true;
                    break;
                case 3:
                    instance_create_depth(x, y, depth, obj_crystal_01);
                    replace = true;
                    break;
                case 4:
                    instance_create_depth(x, y, depth, obj_crystal_01);
                    replace = true;
                    break;
            }
            break;
        case 4:
            switch (arg0)
            {
                case 1:
                    instance_create_depth(x, y, depth, obj_bone);
                    replace = true;
                    break;
                case 2:
                    instance_create_depth(x, y, depth, obj_bone_2);
                    replace = true;
                    break;
                case 3:
                    instance_create_depth(x, y, depth, obj_skull_prop);
                    replace = true;
                    break;
                case 4:
                    instance_create_depth(x, y, depth, obj_skull_prop_2);
                    replace = true;
                    break;
            }
            break;
    }
    if (replace == true)
    {
        instance_destroy();
    }
}
