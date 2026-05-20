function shopkeeper_chance_increase()
{
    if (global.shopkeeper_sold_this_lake == false)
    {
        switch (global.shopkeeper_appear_chance)
        {
            case 75:
                global.shopkeeper_appear_chance = 100;
                break;
            case 25:
                global.shopkeeper_appear_chance = 75;
                break;
            case 0:
                global.shopkeeper_appear_chance = 25;
                break;
        }
        switch (global.shopkeeper_leave_chance)
        {
            case 100:
                global.shopkeeper_leave_chance = 50;
                break;
            case 50:
                global.shopkeeper_leave_chance = 0;
                break;
        }
    }
    global.shopkeeper_sold_this_lake = false;
    var chance = floor(random_range(0, 101));
    if (chance <= global.shopkeeper_appear_chance)
    {
        global.shopkeeper_appear_this_lake = true;
    }
    else
    {
        global.shopkeeper_appear_this_lake = false;
    }
}
