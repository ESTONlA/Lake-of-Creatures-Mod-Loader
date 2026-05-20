function get_enemy_for_battle_room()
{
    var result = 0;
    switch (get_lake_type(global.current_lake))
    {
        case 1:
            result = choose(3, 4, 6, 12, 15, 18, 22, 33);
            break;
        case 2:
            result = choose(1, 5, 11, 13, 19, 27, 34);
            break;
        case 3:
            result = choose(3, 24, 25, 39, 40, 41, 42, 43);
            break;
        case 4:
            result = choose(3, 4, 6, 12, 15, 18, 22, 33, 1, 5, 11, 13, 19, 27, 34, 3, 24, 25, 40, 41, 42, 43);
            break;
    }
    return result;
}
