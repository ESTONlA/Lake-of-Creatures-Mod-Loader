function scr_lm_mp_read_string_payload(_buffer)
{
    var _remaining = buffer_get_size(_buffer) - buffer_tell(_buffer);
    if (_remaining < 2)
    {
        return "";
    }

    var _length = buffer_read(_buffer, buffer_u16);
    _remaining = buffer_get_size(_buffer) - buffer_tell(_buffer);
    if (_length <= 0 || _length > 1024 || _length > _remaining)
    {
        return "";
    }

    var _text = "";
    for (var _i = 0; _i < _length; _i += 1)
    {
        _text += chr(buffer_read(_buffer, buffer_u8));
    }

    return _text;
}
