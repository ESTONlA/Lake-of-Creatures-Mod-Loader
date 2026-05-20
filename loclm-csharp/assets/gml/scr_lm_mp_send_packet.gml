function scr_lm_mp_send_packet(_packet_type, _payload)
{
    if (!variable_global_exists("lm_mp_socket") || global.lm_mp_socket < 0)
    {
        return false;
    }

    var _payload_size = 0;
    if (_payload != -1)
    {
        _payload_size = buffer_get_size(_payload);
    }

    if (_payload_size > 1199)
    {
        return false;
    }

    var _buffer = buffer_create(2 + 1 + _payload_size, buffer_fixed, 1);
    buffer_write(_buffer, buffer_u16, 1 + _payload_size);
    buffer_write(_buffer, buffer_u8, _packet_type);
    if (_payload != -1 && _payload_size > 0)
    {
        buffer_copy(_payload, 0, _payload_size, _buffer, buffer_tell(_buffer));
    }

    network_send_raw(global.lm_mp_socket, _buffer, buffer_get_size(_buffer));
    buffer_delete(_buffer);
    return true;
}
