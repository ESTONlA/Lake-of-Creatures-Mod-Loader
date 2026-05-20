function input_source_is_available(arg0)
{
    __input_initialize();
    var _p = 0;
    repeat (4)
    {
        if (global.__input_players[_p].__source_contains(arg0))
        {
            return false;
        }
        _p++;
    }
    return true;
}
