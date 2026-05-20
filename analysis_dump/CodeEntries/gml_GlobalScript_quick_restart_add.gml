function quick_restart_add()
{
    var file = file_text_open_write("quickrestart.txt");
    if (file != -1)
    {
        file_text_write_string(file, string(global.playable_characters_selected));
        file_text_writeln(file);
        file_text_write_string(file, string(global.challenge_run_selected));
        file_text_writeln(file);
        file_text_write_string(file, string(global.difficulty_selection));
        file_text_writeln(file);
        file_text_write_string(file, string(global.magic_run_active));
        file_text_writeln(file);
        file_text_close(file);
    }
}
