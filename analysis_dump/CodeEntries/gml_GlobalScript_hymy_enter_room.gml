function hymy_enter_room()
{
    if (global.playable_characters_selected == 5)
    {
        global.hymy_smiley_can_spawn_timer = 0;
        global.hymy_smiley_can_spawn = true;
    }
}
