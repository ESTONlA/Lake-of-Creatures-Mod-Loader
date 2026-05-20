function scr_lm_mp_join_steam_lobby(_lobby_id)
{
    scr_lm_mp_init();
    if (global.lm_mp_join_requested == true)
    {
        return;
    }

    var _id_text = string(_lobby_id);
    _id_text = string_replace_all(_id_text, " ", "");
    if (string_length(_id_text) <= 0 || string_length(_id_text) > 32)
    {
        global.lm_mp_status = "Invalid lobby ID.";
        global.lm_mp_panel_message = "Paste a numeric Steam lobby ID.";
        return;
    }

    for (var _i = 1; _i <= string_length(_id_text); _i += 1)
    {
        var _char = string_char_at(_id_text, _i);
        if (_char < "0" || _char > "9")
        {
            global.lm_mp_status = "Invalid lobby ID.";
            global.lm_mp_panel_message = "Lobby ID must only contain numbers.";
            return;
        }
    }

    global.lm_mp_join_requested = true;
    global.lm_mp_lobby_ready = false;
    global.lm_mp_connected = false;
    var _length = string_length(_id_text);
    var _buffer = buffer_create(2 + _length, buffer_fixed, 1);
    buffer_write(_buffer, buffer_u16, _length);
    for (var _b = 1; _b <= _length; _b += 1)
    {
        buffer_write(_buffer, buffer_u8, ord(string_char_at(_id_text, _b)));
    }

    global.lm_mp_status = "Joining Steam lobby " + _id_text + "...";
    if (!scr_lm_mp_send_packet(4, _buffer))
    {
        global.lm_mp_join_requested = false;
        global.lm_mp_status = "Waiting for LOCLM Steam bridge...";
        global.lm_mp_panel_message = "Bridge is not ready yet. Try Join again in a moment.";
    }
    buffer_delete(_buffer);
}
