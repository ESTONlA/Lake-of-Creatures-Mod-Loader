function newspaper_view()
{
    global.newspaper_state[global.newspaper_current] = 2;
    if (global.newspaper_current == 3)
    {
        if (instance_exists(inst_135366))
        {
            instance_destroy(inst_135366);
        }
    }
    if (global.newspaper_current == 4)
    {
        if (instance_exists(inst_135366))
        {
            instance_destroy(inst_135366);
        }
        global.story_event_current = 0;
        global.story_event_block_run = false;
    }
}
