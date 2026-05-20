function scr_enemy_1_idle()
{
    if (timer_use(0))
    {
        if (counter_state[0] < 3)
        {
            drop_item("HP", x, y);
            counter_state[0] += 1;
        }
        else
        {
            drop_item("HP_EXTRA", x, y);
            counter_state[0] = 0;
        }
        timer_set(0, 60, false);
    }
}
