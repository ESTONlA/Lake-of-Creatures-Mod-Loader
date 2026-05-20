function input_player_verify(arg0, arg1 = 0)
{
    __input_initialize();
    if (arg1 < 0)
    {
        __input_error("Invalid player index provided (", arg1, ")");
        return undefined;
    }
    if (arg1 >= 4)
    {
        __input_error("Player index too large (", arg1, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    var _backup = input_player_export(arg1, false);
    var _error = undefined;
    try
    {
        global.__input_players[arg1].__import(arg0);
    }
    catch (_error)
    {
        __input_trace("input_player_verify() failed with the following error: ", _error);
    }
    input_player_import(_backup, arg1);
    return _error == undefined;
}
