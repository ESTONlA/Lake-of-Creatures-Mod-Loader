function shopkeeper_chance_update(arg0)
{
    switch (arg0)
    {
        case "APPEAR_CHANCE":
            switch (global.shopkeeper_appear_chance)
            {
                case 100:
                    global.shopkeeper_appear_chance = 75;
                    break;
                case 75:
                    global.shopkeeper_appear_chance = 25;
                    break;
                case 25:
                    global.shopkeeper_appear_chance = 0;
                    break;
            }
            global.shopkeeper_sold_this_lake = true;
            break;
        case "LEAVE_CHANCE":
            switch (global.shopkeeper_leave_chance)
            {
                case 0:
                    global.shopkeeper_leave_chance = 50;
                    break;
                case 50:
                    global.shopkeeper_leave_chance = 100;
                    break;
                case 100:
                    global.shopkeeper_leave_chance = 100;
                    break;
            }
            break;
        case "LEAVE":
            var chance = floor(random_range(0, 101));
            if (global.shopkeeper_leave_chance <= chance)
            {
            }
            else
            {
                global.shopkeeper_appear_this_lake = false;
            }
            break;
    }
}
