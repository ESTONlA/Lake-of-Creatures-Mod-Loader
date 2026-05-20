function newspaper_choose()
{
    newspaper_unlock();
    if (global.newspaper_state[0] == 0)
    {
        global.newspaper_state[0] = 1;
    }
    if (global.newspaper_state[1] == 0)
    {
        global.newspaper_state[1] = 1;
    }
    for (var i = 0; i < 60; i += 1)
    {
        if (global.newspaper_state[i] == 1)
        {
            return i;
        }
    }
    for (var i = 7; i > 0; i -= 1)
    {
        if (global.newspaper_state[i] == 2)
        {
            return i;
        }
    }
}
