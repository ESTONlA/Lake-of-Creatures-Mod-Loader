function get_common_room_newer(arg0, arg1)
{
    var result = rm_01;
    var uncommon_room_spawn = 0;
    var only_common_room_spawn = false;
    var room_array = array_create(0);
    if (arg1 == 1)
    {
        only_common_room_spawn = true;
    }
    if (arg1 == 2)
    {
        uncommon_room_spawn = 3;
        only_common_room_spawn = true;
    }
    if (arg1 == 3)
    {
        uncommon_room_spawn = 5;
        only_common_room_spawn = true;
    }
    if (only_common_room_spawn == true || floor(random(uncommon_room_spawn)) == 0)
    {
        switch (arg0)
        {
            case 1:
                array_push(room_array, rm_01);
                array_push(room_array, rm_02);
                array_push(room_array, rm_07);
                array_push(room_array, rm_08);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_18);
                array_push(room_array, rm_19);
                array_push(room_array, rm_27);
                break;
            case 2:
                array_push(room_array, rm_01);
                array_push(room_array, rm_02);
                array_push(room_array, rm_07);
                array_push(room_array, rm_08);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_19);
                array_push(room_array, rm_27);
                break;
            case 3:
                array_push(room_array, rm_03);
                array_push(room_array, rm_04);
                array_push(room_array, rm_05);
                array_push(room_array, rm_06);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_25);
                array_push(room_array, rm_27);
                array_push(room_array, rm_29);
                array_push(room_array, rm_36);
                array_push(room_array, rm_37);
                break;
            case 4:
                array_push(room_array, rm_03);
                array_push(room_array, rm_04);
                array_push(room_array, rm_05);
                array_push(room_array, rm_06);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                array_push(room_array, rm_36);
                array_push(room_array, rm_37);
                break;
            case 5:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 6:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 7:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 8:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 9:
                array_push(room_array, rm_03);
                array_push(room_array, rm_04);
                array_push(room_array, rm_05);
                array_push(room_array, rm_06);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                array_push(room_array, rm_36);
                array_push(room_array, rm_37);
                break;
            case 10:
                array_push(room_array, rm_01);
                array_push(room_array, rm_02);
                array_push(room_array, rm_07);
                array_push(room_array, rm_08);
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_19);
                array_push(room_array, rm_22);
                array_push(room_array, rm_23);
                array_push(room_array, rm_24);
                array_push(room_array, rm_26);
                array_push(room_array, rm_27);
                array_push(room_array, rm_36);
                array_push(room_array, rm_37);
                break;
            case 11:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 12:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                array_push(room_array, rm_28);
                break;
            case 13:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 14:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_27);
                break;
            case 15:
                array_push(room_array, rm_09);
                array_push(room_array, rm_10);
                array_push(room_array, rm_11);
                array_push(room_array, rm_12);
                array_push(room_array, rm_13);
                array_push(room_array, rm_14);
                array_push(room_array, rm_15);
                array_push(room_array, rm_16);
                array_push(room_array, rm_17);
                array_push(room_array, rm_21);
                array_push(room_array, rm_27);
                break;
        }
    }
    else
    {
        switch (arg1)
        {
            case 2:
                switch (arg0)
                {
                    case 1:
                        array_push(room_array, rm_30);
                        array_push(room_array, rm_31);
                        array_push(room_array, rm_32);
                        break;
                    case 2:
                        array_push(room_array, rm_30);
                        array_push(room_array, rm_31);
                        array_push(room_array, rm_32);
                        break;
                    case 3:
                        array_push(room_array, rm_30);
                        array_push(room_array, rm_32);
                        break;
                    case 4:
                        array_push(room_array, rm_30);
                        array_push(room_array, rm_32);
                        break;
                    case 5:
                        array_push(room_array, rm_32);
                        break;
                    case 6:
                        array_push(room_array, rm_32);
                        break;
                    case 7:
                        array_push(room_array, rm_32);
                        break;
                    case 8:
                        array_push(room_array, rm_32);
                        break;
                    case 9:
                        array_push(room_array, rm_32);
                        break;
                    case 10:
                        array_push(room_array, rm_30);
                        array_push(room_array, rm_31);
                        array_push(room_array, rm_32);
                        break;
                    case 11:
                        array_push(room_array, rm_32);
                        break;
                    case 12:
                        array_push(room_array, rm_32);
                        break;
                    case 13:
                        array_push(room_array, rm_32);
                        break;
                    case 14:
                        array_push(room_array, rm_32);
                        break;
                    case 15:
                        array_push(room_array, rm_32);
                        break;
                }
                break;
            case 3:
                switch (arg0)
                {
                    case 1:
                        array_push(room_array, rm_34);
                        break;
                    case 2:
                        array_push(room_array, rm_33);
                        array_push(room_array, rm_34);
                        array_push(room_array, rm_35);
                        break;
                    case 3:
                        array_push(room_array, rm_34);
                        break;
                    case 4:
                        array_push(room_array, rm_34);
                        break;
                    case 5:
                        array_push(room_array, rm_33);
                        array_push(room_array, rm_34);
                        break;
                    case 6:
                        array_push(room_array, rm_34);
                        break;
                    case 7:
                        array_push(room_array, rm_33);
                        array_push(room_array, rm_34);
                        break;
                    case 8:
                        array_push(room_array, rm_34);
                        break;
                    case 9:
                        array_push(room_array, rm_34);
                        break;
                    case 10:
                        array_push(room_array, rm_34);
                        break;
                    case 11:
                        array_push(room_array, rm_34);
                        break;
                    case 12:
                        array_push(room_array, rm_34);
                        break;
                    case 13:
                        array_push(room_array, rm_34);
                        break;
                    case 14:
                        array_push(room_array, rm_34);
                        break;
                    case 15:
                        array_push(room_array, rm_34);
                        break;
                }
                break;
        }
    }
    result = room_array[irandom(array_length(room_array) - 1)];
    return result;
}
