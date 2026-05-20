function do_unlock(arg0, arg1)
{
    if (global.unlocks[arg0][arg1] == 0)
    {
        global.unlocks[arg0][arg1] = 1;
    }
    if (arg0 == 0)
    {
    }
}
