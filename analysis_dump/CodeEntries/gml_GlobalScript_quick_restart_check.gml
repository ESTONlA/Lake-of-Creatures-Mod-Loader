function quick_restart_check()
{
    var file = file_text_open_read("quickrestart.txt");
    if (file != -1)
    {
        global.playable_characters_selected = file_text_read_string(file);
        file_text_readln(file);
        global.challenge_run_selected = file_text_read_string(file);
        file_text_readln(file);
        global.difficulty_selection = file_text_read_string(file);
        file_text_readln(file);
        global.magic_run_active = file_text_read_string(file);
        file_text_readln(file);
        file_text_close(file);
        play_sound(UnknownEnum.Value_156);
        update_banner_sound_disabled = true;
        file_delete("quickrestart.txt");
        return true;
    }
    return false;
}

enum UnknownEnum
{
    Value_156 = 156
}
