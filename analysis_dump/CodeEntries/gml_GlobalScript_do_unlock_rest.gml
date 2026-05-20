function do_unlock_rest(arg0)
{
    if (global.unlocks_all[arg0] == 0)
    {
        global.unlocks_all[arg0] = 1;
    }
}
