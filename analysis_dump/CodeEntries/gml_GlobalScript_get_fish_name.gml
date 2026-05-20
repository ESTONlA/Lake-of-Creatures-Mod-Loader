function get_fish_name(arg0)
{
    var name = "";
    switch (arg0)
    {
        case 0:
            name = txt("fish_1");
            break;
        case 1:
            name = txt("fish_2");
            break;
        case 2:
            name = txt("fish_3");
            break;
        case 3:
            name = txt("fish_4");
            break;
        case 4:
            name = txt("fish_5");
            break;
        case 5:
            name = txt("fish_6");
            break;
        case 6:
            name = txt("fish_7");
            break;
        case 7:
            name = txt("fish_8");
            break;
        case 8:
            name = txt("fish_9");
            break;
        case 9:
            name = txt("fish_10");
            break;
        case 10:
            name = txt("fish_11");
            break;
        case 11:
            name = txt("fish_12");
            break;
        case 12:
            name = txt("fish_13");
            break;
        case 13:
            name = txt("fish_14");
            break;
        case 14:
            name = txt("fish_15");
            break;
        case 15:
            name = txt("fish_16");
            break;
    }
    name = string_upper(name);
    return name;
}
