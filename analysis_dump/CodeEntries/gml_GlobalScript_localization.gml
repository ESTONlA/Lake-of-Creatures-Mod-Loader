global.locale = UnknownEnum.Value_0;
InitTranslations();

function InitTranslations()
{
    global.loc_data = load_csv("loc_locale.csv");
    var hh = ds_grid_height(global.loc_data);
    var translations = ds_map_create();
    for (var i = 0; i < hh; i += 1)
    {
        ds_map_add(translations, ds_grid_get(global.loc_data, 0, i), i);
    }
    global.translations = translations;
}

function txt(arg0)
{
    var text = "";
    if (ds_map_find_value(global.translations, arg0) != undefined)
    {
        text = ds_grid_get(global.loc_data, 1 + global.locale, ds_map_find_value(global.translations, arg0));
        var a = (argument_count > 1) ? argument[1] : "";
        text = string_replace_all(text, "{a}", a);
    }
    else
    {
        text = arg0;
    }
    return text;
}

enum UnknownEnum
{
    Value_0
}
