function get_unstuck_fishing_line(arg0)
{
    for (i = 0; i < 100; i += 1)
    {
        if (!place_meeting(phy_position_x - i, phy_position_y, arg0))
        {
            phy_position_x -= i;
            break;
        }
        if (!place_meeting(phy_position_x + i, phy_position_y, arg0))
        {
            phy_position_x += i;
            break;
        }
        if (!place_meeting(phy_position_x, phy_position_y - i, arg0))
        {
            phy_position_y -= i;
            break;
        }
        if (!place_meeting(phy_position_x, phy_position_y + i, arg0))
        {
            phy_position_y += i;
            break;
        }
        if (!place_meeting(phy_position_x - i, phy_position_y - i, arg0))
        {
            phy_position_x -= i;
            phy_position_y -= i;
            break;
        }
        if (!place_meeting(phy_position_x + i, phy_position_y - i, arg0))
        {
            phy_position_x += i;
            phy_position_y -= i;
            break;
        }
        if (!place_meeting(phy_position_x - i, phy_position_y + i, arg0))
        {
            phy_position_x -= i;
            phy_position_y += i;
            break;
        }
        if (!place_meeting(phy_position_x + i, phy_position_y + i, arg0))
        {
            phy_position_x += i;
            phy_position_y += i;
            break;
        }
    }
}
