function shop_purchase(arg0)
{
    achievement_get("BUY_1");
    play_sound(70);
    global.total_money_spent_this_lake += arg0;
    global.total_money_spent_this_run += arg0;
    if (global.total_money_spent_this_lake > 1000)
    {
        achievement_get("BUY_2");
    }
    if (global.total_money_spent_this_run > 2000)
    {
        achievement_get("BUY_3");
    }
}
