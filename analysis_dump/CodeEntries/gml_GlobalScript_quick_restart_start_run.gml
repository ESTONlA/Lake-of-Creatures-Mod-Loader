function quick_restart_start_run()
{
    play_music(1);
    if (global.magic_run_active == true)
    {
        restart_delay = 50;
        start_new_run("magic_pot");
    }
    else if (global.challenge_run_selected <= 0)
    {
        start_new_run("normal");
    }
    else
    {
        restart_delay = 50;
        start_new_run("challenge");
    }
}
