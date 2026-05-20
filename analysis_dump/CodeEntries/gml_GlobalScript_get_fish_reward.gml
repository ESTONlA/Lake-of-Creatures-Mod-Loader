function get_fish_reward(arg0)
{
    switch (arg0)
    {
        case 2:
            if (floor(random(2)) == 0)
            {
                drop_item("HP_EXTRA", obj_player.x, obj_player.y);
            }
            break;
        case 3:
            if (floor(random(6)) == 0)
            {
                drop_item("KEY", obj_player.x, obj_player.y);
            }
            break;
        case 4:
            if (floor(random(11)) == 0)
            {
                drop_item("ITEM", obj_player.x, obj_player.y);
            }
            break;
        case 5:
            if (floor(random(2)) == 0)
            {
                drop_item("ITEM", obj_player.x, obj_player.y);
            }
            break;
        case 6:
            drop_item("HP_EXTRA", obj_player.x, obj_player.y);
            if (floor(random(2)) == 0)
            {
                drop_item("HP_EXTRA", obj_player.x, obj_player.y);
            }
            break;
        case 7:
            if (floor(random(2)) == 0)
            {
                drop_item("KEY", obj_player.x, obj_player.y);
            }
            break;
        case 9:
            drop_item("HP_EXTRA", obj_player.x, obj_player.y);
            break;
        case 12:
            drop_item("ITEM", obj_player.x, obj_player.y);
            break;
        case 15:
            global.player_hp = global.player_hp_max;
            break;
    }
}
