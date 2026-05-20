function get_common_room(arg0, arg1)
{
    var result = rm_01;
    var uncommon_room_spawn = 0;
    var only_common_room_spawn = false;
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
                result = choose(rm_01, rm_02, rm_07, rm_08, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_18, rm_19, rm_27);
                break;
            case 2:
                return choose(rm_01, rm_02, rm_07, rm_08, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_19, rm_27);
                break;
            case 3:
                return choose(rm_03, rm_04, rm_05, rm_06, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_25, rm_27, rm_29);
                break;
            case 4:
                return choose(rm_03, rm_04, rm_05, rm_06, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 5:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 6:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 7:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 8:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 9:
                return choose(rm_03, rm_04, rm_05, rm_06, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 10:
                return choose(rm_01, rm_02, rm_07, rm_08, rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_19, rm_22, rm_23, rm_24, rm_26, rm_27);
                break;
            case 11:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 12:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27, rm_28);
                break;
            case 13:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 14:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_27);
                break;
            case 15:
                return choose(rm_09, rm_10, rm_11, rm_12, rm_13, rm_14, rm_15, rm_16, rm_17, rm_21, rm_27);
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
                        result = choose(rm_30, rm_31, rm_32);
                        break;
                    case 2:
                        result = choose(rm_30, rm_31, rm_32);
                        break;
                    case 3:
                        result = choose(rm_30, rm_32);
                        break;
                    case 4:
                        result = choose(rm_30, rm_32);
                        break;
                    case 5:
                        result = choose(rm_32);
                        break;
                    case 6:
                        result = choose(rm_32);
                        break;
                    case 7:
                        result = choose(rm_32);
                        break;
                    case 8:
                        result = choose(rm_32);
                        break;
                    case 9:
                        result = choose(rm_32);
                        break;
                    case 10:
                        result = choose(rm_30, rm_31, rm_32);
                        break;
                    case 11:
                        result = choose(rm_32);
                        break;
                    case 12:
                        result = choose(rm_32);
                        break;
                    case 13:
                        result = choose(rm_32);
                        break;
                    case 14:
                        result = choose(rm_32);
                        break;
                    case 15:
                        result = choose(rm_32);
                        break;
                }
                break;
            case 3:
                switch (arg0)
                {
                    case 1:
                        result = choose(rm_34);
                        break;
                    case 2:
                        result = choose(rm_33, rm_34, rm_35);
                        break;
                    case 3:
                        result = choose(rm_34);
                        break;
                    case 4:
                        result = choose(rm_34);
                        break;
                    case 5:
                        result = choose(rm_33, rm_34);
                        break;
                    case 6:
                        result = choose(rm_34);
                        break;
                    case 7:
                        result = choose(rm_33, rm_34);
                        break;
                    case 8:
                        result = choose(rm_34);
                        break;
                    case 9:
                        result = choose(rm_34);
                        break;
                    case 10:
                        result = choose(rm_34);
                        break;
                    case 11:
                        result = choose(rm_34);
                        break;
                    case 12:
                        result = choose(rm_34);
                        break;
                    case 13:
                        result = choose(rm_34);
                        break;
                    case 14:
                        result = choose(rm_34);
                        break;
                    case 15:
                        result = choose(rm_34);
                        break;
                }
                break;
        }
    }
    return result;
}
