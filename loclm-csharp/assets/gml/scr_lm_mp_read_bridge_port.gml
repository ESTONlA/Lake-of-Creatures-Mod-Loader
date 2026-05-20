function scr_lm_mp_read_bridge_port()
{
    var _port = 38470;
    if (file_exists("loclm/runtime/steam_bridge_port.txt"))
    {
        var _file = file_text_open_read("loclm/runtime/steam_bridge_port.txt");
        if (_file >= 0)
        {
            var _line = file_text_read_string(_file);
            file_text_close(_file);
            var _parsed = real(_line);
            if (_parsed >= 38470 && _parsed <= 38490)
            {
                _port = _parsed;
            }
        }
    }

    return _port;
}
