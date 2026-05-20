function __input_source_relinquish(arg0)
{
    var _i = 0;
    repeat (4)
    {
        global.__input_players[_i].__source_remove(arg0);
        _i++;
    }
}
