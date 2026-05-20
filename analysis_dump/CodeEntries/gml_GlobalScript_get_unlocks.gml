function get_unlocks()
{
    for (var i = 0; i < global.unlocks_total[0]; i += 1)
    {
        if (global.unlocks[0][i] == 1)
        {
            var unlock_prompt = instance_create_depth(0, 0, -1001, obj_unlock_prompt_waiter);
            unlock_prompt.category = 0;
            unlock_prompt.index = i;
        }
    }
    for (var i = 0; i < global.unlocks_all_total; i += 1)
    {
        if (global.unlocks_all[i] == 1)
        {
            var unlock_prompt = instance_create_depth(0, 0, -1001, obj_unlock_prompt_waiter);
            unlock_prompt.category = 4;
            unlock_prompt.index = i;
        }
    }
}
