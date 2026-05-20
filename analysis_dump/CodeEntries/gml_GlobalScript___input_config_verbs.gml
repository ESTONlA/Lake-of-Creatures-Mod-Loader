__input_initialize();
for (var _i = 0; _i < 2; _i++)
{
    if (_i == 1)
    {
        __input_finalize_verb_groups();
    }
    else
    {
        global.__input_group_to_verbs_dict = 
        {
            group_gameplay: ["menu_select", "leave"],
            group_menu: ["up", "down", "left", "right", "reload", "scroll_back", "scroll_next", "interact", "shoot", "melee", "pause", "map_expand", "speedboost"]
        };
    }
}
