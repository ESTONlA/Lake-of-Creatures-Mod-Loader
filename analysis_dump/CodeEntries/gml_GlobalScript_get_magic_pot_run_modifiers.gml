function get_magic_pot_run_modifiers()
{
    var random_item_count = 6;
    for (var i = 0; i < random_item_count; i += 1)
    {
        var item_ind = floor(random_range(0, global.total_items_in_game + 1));
        var item_available = true;
        if (global.my_item[item_ind] == 1)
        {
            item_available = false;
        }
        if (global.unlocks[0][item_ind] < 2)
        {
            item_available = false;
        }
        global.difficulty_selection = 1;
        if (item_available == true)
        {
            get_item_effects(item_ind);
            global.my_item[item_ind] = 1;
            global.items_this_run[global.items_this_run_amount] = item_ind;
            global.items_this_run_amount += 1;
        }
        else
        {
            i -= 1;
        }
    }
}
