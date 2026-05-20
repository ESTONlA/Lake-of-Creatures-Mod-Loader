function get_item_desc(arg0)
{
    var item_desc = "DESC NOT FOUND!";
    var item_desc_localisation = "item_desc_" + string(arg0);
    item_desc = txt(item_desc_localisation);
    return item_desc;
}
