function input_player_swap(arg0, arg1)
{
    if (arg0 < 0)
    {
        __input_error("Invalid player index A provided (", arg0, ")");
        return undefined;
    }
    if (arg0 >= 4)
    {
        __input_error("Player index A too large (", arg0, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    if (arg1 < 0)
    {
        __input_error("Invalid player index B provided (", arg1, ")");
        return undefined;
    }
    if (arg1 >= 4)
    {
        __input_error("Player index B too large (", arg1, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    var _temp = global.__input_players[arg0];
    array_set(global.__input_players, arg0, global.__input_players[arg1]);
    array_set(global.__input_players, arg1, _temp);
}
