function skip_logo_screen_add()
{
    var file = file_text_open_write("restarted.txt");
    file_text_write_string(file, "hello");
    file_text_close(file);
}
