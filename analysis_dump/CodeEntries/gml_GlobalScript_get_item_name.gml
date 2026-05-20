function get_item_name(arg0)
{
    var item_name = "NAME NOT FOUND!";
    var item_name_localisation = "item_" + string(arg0);
    item_name = txt(item_name_localisation);
    return item_name;
}
