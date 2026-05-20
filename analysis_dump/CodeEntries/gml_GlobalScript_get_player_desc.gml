function get_player_desc(arg0)
{
    result = "";
    switch (arg0)
    {
        case 0:
            result = txt("character_1_desc");
            break;
        case 1:
            result = txt("character_2_desc");
            break;
        case 2:
            result = txt("character_3_desc");
            break;
        case 3:
            result = txt("character_4_desc");
            break;
        case 4:
            result = txt("character_5_desc");
            break;
        case 5:
            result = txt("character_6_desc");
            break;
    }
    return result;
}
