var _async_type = ds_map_find_value(async_load, "type");
if (_async_type == network_type_data)
{
    var _buffer = ds_map_find_value(async_load, "buffer");
    var _size = buffer_get_size(_buffer);
    var _offset = 0;

    while (_offset + 3 <= _size)
    {
        buffer_seek(_buffer, buffer_seek_start, _offset);
        var _length = buffer_read(_buffer, buffer_u16);

        if (_length <= 0 || _length > 1200)
        {
            break;
        }

        if (_offset + 2 + _length > _size)
        {
            break;
        }

        var _packet_type = buffer_read(_buffer, buffer_u8);
        var _payload_length = _length - 1;
        var _known_packet = (_packet_type >= 1 && _packet_type <= 16);
        var _valid_player_state = (_packet_type != 11 || _payload_length == 38);

        if (_known_packet && _valid_player_state)
        {
            scr_lm_mp_handle_local_packet(_packet_type, _buffer);
        }

        _offset += 2 + _length;
    }
}
