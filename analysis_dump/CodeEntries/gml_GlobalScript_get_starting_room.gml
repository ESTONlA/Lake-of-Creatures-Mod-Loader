function get_starting_room()
{
    switch (get_lake_type(my_lake_id))
    {
        case 1:
            return rm_L1_start;
            break;
        case 2:
            return rm_L2_start;
            break;
        case 3:
            return rm_L3_start;
            break;
        case 4:
            return rm_L4_start;
            break;
    }
}
