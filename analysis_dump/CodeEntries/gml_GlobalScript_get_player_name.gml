function get_player_name(arg0)
{
    result = "";
    switch (arg0)
    {
        case 0:
            result = "Pat";
            break;
        case 1:
            result = "Birgit";
            break;
        case 2:
            result = "Raikku";
            break;
        case 3:
            result = "Tyhmyli";
            break;
        case 4:
            result = "Äijä";
            if (global.locale == UnknownEnum.Value_1)
            {
                result = "Aija";
            }
            break;
        case 5:
            result = "Hymy";
            break;
        case 6:
            result = "Torvi";
            break;
        case 7:
            result = "Olio";
            break;
        case 8:
            result = "Parkuja";
            break;
    }
    return result;
}

enum UnknownEnum
{
    Value_1 = 1
}
