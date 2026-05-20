function get_lake_name(arg0)
{
    var result = "";
    switch (arg0)
    {
        case 1:
            result = string(txt("lake_1") + " 1");
            break;
        case 2:
            result = string(txt("lake_1") + " 2");
            break;
        case 3:
            result = string(txt("lake_2") + " 1");
            break;
        case 4:
            result = string(txt("lake_2") + " 2");
            break;
        case 5:
            result = string(txt("lake_3") + " 1");
            break;
        case 6:
            result = string(txt("lake_3") + " 2");
            break;
        case 7:
            result = string(txt("lake_4") + " 1");
            break;
        case 8:
            result = string(txt("lake_4") + " 2");
            break;
    }
    return result;
}
