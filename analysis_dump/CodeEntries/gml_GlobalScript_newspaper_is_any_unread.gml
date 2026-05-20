function newspaper_is_any_unread()
{
    for (var i = 0; i < 60; i += 1)
    {
        if (global.newspaper_state[i] == 1)
        {
            return true;
        }
    }
    return false;
}
