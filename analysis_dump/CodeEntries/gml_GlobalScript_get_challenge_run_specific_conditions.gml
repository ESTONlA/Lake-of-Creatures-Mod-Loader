function get_challenge_run_specific_conditions()
{
    if (global.challenge_run_selected == 1)
    {
        global.difficulty_selection = 1;
        get_difficulty_modifiers();
    }
    if (global.challenge_run_selected == 2)
    {
        global.difficulty_selection = 1;
        get_difficulty_modifiers();
    }
    if (global.challenge_run_selected == 3)
    {
        global.difficulty_mod_enemy_speed = 1.5;
        global.player_speed_increase = 0.5;
        global.difficulty_selection = 0;
    }
    if (global.challenge_run_selected == 4)
    {
        global.difficulty_selection = 1;
        get_difficulty_modifiers();
    }
    if (global.challenge_run_selected == 5)
    {
        global.player_hp = 10;
        global.player_hp_max = 10;
    }
    if (global.challenge_run_selected == 6)
    {
        global.difficulty_selection = 1;
        get_difficulty_modifiers();
        var item_ind = 31;
        global.item_bounce_shot = true;
        global.my_item[item_ind] = 1;
        global.items_this_run[global.items_this_run_amount] = item_ind;
        global.items_this_run_amount += 1;
    }
    if (global.challenge_run_selected == 7)
    {
        global.player_hp = 1;
        global.player_hp_max = 1;
        global.player_money = 100;
    }
}
