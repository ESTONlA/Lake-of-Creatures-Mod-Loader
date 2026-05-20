function data_load_bindings()
{
    if (file_exists("loc_bindings_new.sav"))
    {
        var file_buffer = buffer_load("loc_bindings_new.sav");
        var s = buffer_read(file_buffer, buffer_string);
        input_system_import(s);
        buffer_delete(file_buffer);
    }
}
