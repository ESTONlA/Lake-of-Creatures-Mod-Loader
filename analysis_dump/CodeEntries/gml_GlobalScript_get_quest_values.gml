function get_quest_values()
{
    switch (global.dialogue_give_quest_id)
    {
        case 0:
            global.quest_progress = 0;
            global.quest_target = 5;
            global.quest_current_index = 0;
            global.quest_active = true;
            break;
    }
}
