function loclm_runtime_log(_message)
{
    var _line = "runtime | " + string(_message);
    show_debug_message("[LOCLM] " + _line);

    var _file = file_text_open_append("LOCLM_runtime.log");
    file_text_write_string(_file, _line);
    file_text_writeln(_file);
    file_text_close(_file);
}
