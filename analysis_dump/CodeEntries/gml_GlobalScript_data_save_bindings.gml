function data_save_bindings(arg0)
{
    if (file_exists("loc_bindings_new.sav"))
    {
        file_delete("loc_bindings_new.sav");
    }
    var file = file_text_open_write(working_directory + "loc_bindings_new.sav");
    file_text_write_string(file, arg0);
    file_text_close(file);
}
