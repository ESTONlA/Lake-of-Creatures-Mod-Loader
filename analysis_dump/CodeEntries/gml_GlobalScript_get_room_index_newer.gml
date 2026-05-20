function get_room_index_newer()
{
    var special_common_room_chance = my_lake_gen_object.special_common_room_chance;
    var room_array = array_create(0);
    if (sausage_room == true)
    {
        array_push(room_array, rm_sausage);
    }
    var treasure_rooms_contain_treasure = true;
    var shop_rooms_contain_treasure = true;
    if (global.magic_run_active == true)
    {
        treasure_rooms_contain_treasure = false;
        shop_rooms_contain_treasure = false;
    }
    if (global.challenge_run_selected == 2)
    {
        treasure_rooms_contain_treasure = false;
        shop_rooms_contain_treasure = false;
    }
    switch (layout_index)
    {
        case 1:
            if (room_special_icon == 0)
            {
                if (starting_room == false)
                {
                    if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                    {
                        return get_common_room_newer(1, my_lake_gen_object.lake_type);
                    }
                    else
                    {
                        my_lake_gen_object.special_common_room_amount_current += 1;
                        array_push(room_array, rm_L1_s_01);
                        array_push(room_array, rm_L1_s_02);
                        array_push(room_array, rm_L1_s_03);
                        array_push(room_array, rm_s_39);
                        array_push(room_array, rm_s_41);
                    }
                }
                else
                {
                    return get_starting_room();
                }
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        if (lake_has_boss(my_lake_id))
                        {
                            array_push(room_array, rm_L1_BOSS_ENTRANCE);
                        }
                        else
                        {
                            array_push(room_array, rm_L1_FINAL);
                        }
                        break;
                    case 3:
                        if (treasure_rooms_contain_treasure == true)
                        {
                            if (my_lake_id == 1)
                            {
                                array_push(room_array, rm_L1_ITEM_01);
                            }
                            else if (evil_clam_room == true)
                            {
                                array_push(room_array, rm_L1_ITEM_06);
                            }
                            else
                            {
                                array_push(room_array, rm_L1_ITEM_02);
                                array_push(room_array, rm_L1_ITEM_03);
                                array_push(room_array, rm_L1_ITEM_04);
                                array_push(room_array, rm_L1_ITEM_05);
                                array_push(room_array, rm_L1_ITEM_07);
                                array_push(room_array, rm_L1_ITEM_08);
                            }
                        }
                        else
                        {
                            array_push(room_array, rm_L1_ITEM_M_A);
                        }
                        break;
                    case 4:
                        if (shop_rooms_contain_treasure == true)
                        {
                            array_push(room_array, rm_L1_SHOP_05);
                        }
                        else
                        {
                            array_push(room_array, rm_L1_SHOP_06);
                        }
                        break;
                }
            }
            break;
        case 2:
            if (room_special_icon == 0)
            {
                if (starting_room == false)
                {
                    if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                    {
                        return get_common_room_newer(2, my_lake_gen_object.lake_type);
                    }
                    else
                    {
                        my_lake_gen_object.special_common_room_amount_current += 1;
                        array_push(room_array, rm_20);
                        array_push(room_array, rm_L2_s_01);
                        array_push(room_array, rm_L2_s_02);
                        array_push(room_array, rm_L2_s_03);
                        array_push(room_array, rm_s_42);
                    }
                }
                else
                {
                    return get_starting_room();
                }
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        if (lake_has_boss(my_lake_id))
                        {
                            array_push(room_array, rm_L2_BOSS_ENTRANCE);
                        }
                        else
                        {
                            array_push(room_array, rm_L2_FINAL);
                        }
                        break;
                    case 3:
                        if (treasure_rooms_contain_treasure == true)
                        {
                            if (my_lake_id == 1)
                            {
                                array_push(room_array, rm_L2_ITEM_01);
                            }
                            else if (evil_clam_room == true)
                            {
                                array_push(room_array, rm_L2_ITEM_04);
                            }
                            else
                            {
                                array_push(room_array, rm_L2_ITEM_02);
                                array_push(room_array, rm_L2_ITEM_03);
                                array_push(room_array, rm_L2_ITEM_05);
                                array_push(room_array, rm_L2_ITEM_06);
                                array_push(room_array, rm_L2_ITEM_07);
                                array_push(room_array, rm_L2_ITEM_08);
                            }
                        }
                        else
                        {
                            array_push(room_array, rm_L2_ITEM_M_A);
                        }
                        break;
                    case 4:
                        if (shop_rooms_contain_treasure == true)
                        {
                            array_push(room_array, rm_L2_SHOP_05);
                        }
                        else
                        {
                            array_push(room_array, rm_L2_SHOP_06);
                        }
                        break;
                }
            }
            break;
        case 3:
            if (room_special_icon == 0)
            {
                if (starting_room == false)
                {
                    if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                    {
                        return get_common_room_newer(3, my_lake_gen_object.lake_type);
                    }
                    else
                    {
                        my_lake_gen_object.special_common_room_amount_current += 1;
                        array_push(room_array, rm_L3_s_01);
                        array_push(room_array, rm_L3_s_02);
                        array_push(room_array, rm_L3_s_03);
                        array_push(room_array, rm_s_11);
                        array_push(room_array, rm_s_12);
                        array_push(room_array, rm_s_13);
                        array_push(room_array, rm_s_14);
                        array_push(room_array, rm_s_15);
                        array_push(room_array, rm_s_16);
                        array_push(room_array, rm_s_32);
                        array_push(room_array, rm_s_38);
                        array_push(room_array, rm_s_42);
                    }
                }
                else
                {
                    return get_starting_room();
                }
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        if (lake_has_boss(my_lake_id))
                        {
                            array_push(room_array, rm_L3_BOSS_ENTRANCE);
                        }
                        else
                        {
                            array_push(room_array, rm_L3_FINAL);
                        }
                        break;
                    case 3:
                        if (treasure_rooms_contain_treasure == true)
                        {
                            if (my_lake_id == 1)
                            {
                                array_push(room_array, rm_L3_ITEM_01);
                            }
                            else if (evil_clam_room == true)
                            {
                                array_push(room_array, rm_L3_ITEM_04);
                            }
                            else
                            {
                                array_push(room_array, rm_L3_ITEM_02);
                                array_push(room_array, rm_L3_ITEM_03);
                                array_push(room_array, rm_L3_ITEM_05);
                                array_push(room_array, rm_L3_ITEM_06);
                                array_push(room_array, rm_L3_ITEM_07);
                                array_push(room_array, rm_L3_ITEM_08);
                            }
                        }
                        else
                        {
                            array_push(room_array, rm_L3_ITEM_M_A);
                        }
                        break;
                    case 4:
                        if (shop_rooms_contain_treasure == true)
                        {
                            array_push(room_array, rm_L3_SHOP_05);
                        }
                        else
                        {
                            array_push(room_array, rm_L3_SHOP_06);
                        }
                        break;
                }
            }
            break;
        case 4:
            if (room_special_icon == 0)
            {
                if (starting_room == false)
                {
                    if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                    {
                        return get_common_room_newer(4, my_lake_gen_object.lake_type);
                    }
                    else
                    {
                        my_lake_gen_object.special_common_room_amount_current += 1;
                        array_push(room_array, rm_L4_s_01);
                        array_push(room_array, rm_L4_s_02);
                        array_push(room_array, rm_L4_s_03);
                        array_push(room_array, rm_L4_s_04);
                        array_push(room_array, rm_L4_s_05);
                        array_push(room_array, rm_s_17);
                        array_push(room_array, rm_s_18);
                        array_push(room_array, rm_s_19);
                        array_push(room_array, rm_s_20);
                        array_push(room_array, rm_s_21);
                        array_push(room_array, rm_s_22);
                        array_push(room_array, rm_s_25);
                        array_push(room_array, rm_s_35);
                        array_push(room_array, rm_s_36);
                    }
                }
                else
                {
                    return get_starting_room();
                }
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        if (lake_has_boss(my_lake_id))
                        {
                            array_push(room_array, rm_L4_BOSS_ENTRANCE);
                        }
                        else
                        {
                            array_push(room_array, rm_L4_FINAL);
                        }
                        break;
                    case 3:
                        if (treasure_rooms_contain_treasure == true)
                        {
                            if (my_lake_id == 1)
                            {
                                array_push(room_array, rm_L4_ITEM_01);
                            }
                            else if (evil_clam_room == true)
                            {
                                array_push(room_array, rm_L4_ITEM_04);
                            }
                            else
                            {
                                array_push(room_array, rm_L4_ITEM_02);
                                array_push(room_array, rm_L4_ITEM_03);
                                array_push(room_array, rm_L4_ITEM_05);
                                array_push(room_array, rm_L4_ITEM_06);
                                array_push(room_array, rm_L4_ITEM_07);
                                array_push(room_array, rm_L4_ITEM_08);
                            }
                        }
                        else
                        {
                            array_push(room_array, rm_L4_ITEM_M_A);
                        }
                        break;
                    case 4:
                        if (shop_rooms_contain_treasure == true)
                        {
                            array_push(room_array, rm_L4_SHOP_05);
                        }
                        else
                        {
                            array_push(room_array, rm_L4_SHOP_06);
                        }
                        break;
                }
            }
            break;
        case 5:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(5, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    array_push(room_array, rm_s_11);
                    array_push(room_array, rm_s_12);
                    array_push(room_array, rm_s_13);
                    array_push(room_array, rm_s_32);
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 6:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(6, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    array_push(room_array, rm_s_14);
                    array_push(room_array, rm_s_15);
                    array_push(room_array, rm_s_16);
                    array_push(room_array, rm_s_32);
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 7:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(7, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    array_push(room_array, rm_L4_s_05);
                    array_push(room_array, rm_s_17);
                    array_push(room_array, rm_s_18);
                    array_push(room_array, rm_s_19);
                    array_push(room_array, rm_s_35);
                    array_push(room_array, rm_s_36);
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 8:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(8, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    array_push(room_array, rm_s_20);
                    array_push(room_array, rm_s_21);
                    array_push(room_array, rm_s_22);
                    array_push(room_array, rm_s_25);
                    array_push(room_array, rm_s_31);
                    array_push(room_array, rm_s_33);
                    array_push(room_array, rm_s_34);
                    array_push(room_array, rm_s_35);
                    array_push(room_array, rm_s_36);
                    array_push(room_array, rm_s_41);
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 9:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(9, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 10:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(10, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    array_push(room_array, rm_s_37);
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 11:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(11, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 12:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(12, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 13:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(13, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 14:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(14, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 15:
            if (starting_room == false)
            {
                if (floor(random(special_common_room_chance)) != 0 && my_lake_gen_object.special_common_room_amount_current != my_lake_gen_object.special_common_room_amount_max)
                {
                    return get_common_room_newer(15, my_lake_gen_object.lake_type);
                }
                else if (floor(random(2)) == 0)
                {
                    return get_room_index_special_common_newer();
                }
                else
                {
                    my_lake_gen_object.special_common_room_amount_current += 1;
                    return get_room_index_special_common_newer();
                }
            }
            else
            {
                return get_starting_room();
            }
            break;
        case 16:
            array_push(room_array, rm_L3_BOSS_01);
            break;
        case 17:
            array_push(room_array, rm_EXTRA_A_1);
            break;
        case 18:
            array_push(room_array, rm_EXTRA_A_2);
            break;
    }
    var result = room_array[irandom(array_length(room_array) - 1)];
    return result;
}
