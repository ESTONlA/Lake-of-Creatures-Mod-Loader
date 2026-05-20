function get_room_index()
{
    switch (layout_index)
    {
        case 1:
            if (room_special_icon == 0)
            {
                return choose(rm_W1_L1_02, rm_W1_L1_03, rm_W1_L1_04);
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        return choose(rm_W1_L1_BOSS_01);
                        break;
                    case 3:
                        return choose(rm_W1_L1_ITEM_01);
                        break;
                    case 4:
                        return choose(rm_W1_L1_SPEC_01, rm_W1_L1_SPEC_02);
                        break;
                }
            }
            break;
        case 2:
            if (room_special_icon == 0)
            {
                return choose(rm_W1_L2_02, rm_W1_L2_03, rm_W1_L2_04);
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        return choose(rm_W1_L2_BOSS_01);
                        break;
                    case 3:
                        return choose(rm_W1_L2_ITEM_01);
                        break;
                    case 4:
                        return choose(rm_W1_L2_SPEC_01, rm_W1_L2_SPEC_02);
                        break;
                }
            }
            break;
        case 3:
            if (room_special_icon == 0)
            {
                return choose(rm_W1_L3_02, rm_W1_L3_03, rm_W1_L3_04, rm_W1_L3_05, rm_W1_L3_06);
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        return choose(rm_W1_L3_BOSS_01);
                        break;
                    case 3:
                        return choose(rm_W1_L3_ITEM_01);
                        break;
                    case 4:
                        return choose(rm_W1_L3_SPEC_01, rm_W1_L3_SPEC_02);
                        break;
                }
            }
            break;
        case 4:
            if (room_special_icon == 0)
            {
                return choose(rm_W1_L4_02, rm_W1_L4_03, rm_W1_L4_04);
            }
            else
            {
                switch (room_special_icon)
                {
                    case 2:
                        return choose(rm_W1_L4_BOSS_01);
                        break;
                    case 3:
                        return choose(rm_W1_L4_ITEM_01);
                        break;
                    case 4:
                        return choose(rm_W1_L4_SPEC_01, rm_W1_L4_SPEC_02);
                        break;
                }
            }
            break;
        case 5:
            return choose(rm_W1_L5_02, rm_W1_L5_03);
            break;
        case 6:
            return choose(rm_W1_L6_02, rm_W1_L6_03);
            break;
        case 7:
            return choose(rm_W1_L7_02, rm_W1_L7_03);
            break;
        case 8:
            return choose(rm_W1_L8_02, rm_W1_L8_03, rm_W1_L8_04, rm_W1_L8_05, rm_W1_L8_06);
            break;
        case 9:
            return choose(rm_W1_L9_02, rm_W1_L9_03);
            break;
        case 10:
            return choose(rm_W1_L10_02, rm_W1_L10_03, rm_W1_L10_04, rm_W1_L10_05, rm_W1_L10_06, rm_W1_L10_07);
            break;
        case 11:
            return choose(rm_W1_L11_02, rm_W1_L11_03, rm_W1_L11_04, rm_W1_L11_05);
            break;
        case 12:
            return choose(rm_W1_L12_02, rm_W1_L12_03);
            break;
        case 13:
            return choose(rm_W1_L13_02, rm_W1_L13_03);
            break;
        case 14:
            return choose(rm_W1_L14_02, rm_W1_L14_03);
            break;
        case 15:
            return choose(rm_W1_L15_02, rm_W1_L15_03);
            break;
    }
}
