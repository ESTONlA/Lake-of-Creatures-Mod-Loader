function scr_lm_mp_send_player_state()
{
    if (!variable_global_exists("lm_mp_match_started") || !global.lm_mp_match_started)
    {
        return false;
    }

    var _player = noone;
    if (instance_exists(obj_player))
    {
        _player = instance_find(obj_player, 0);
    }
    else if (instance_exists(obj_overworld_player))
    {
        _player = instance_find(obj_overworld_player, 0);
    }

    if (_player == noone)
    {
        return false;
    }

    var _hspeed = 0;
    var _vspeed = 0;
    if (variable_instance_exists(_player, "hspeed"))
    {
        _hspeed = _player.hspeed;
    }
    if (variable_instance_exists(_player, "vspeed"))
    {
        _vspeed = _player.vspeed;
    }

    var _image_xscale = _player.image_xscale;
    if (_image_xscale == 0)
    {
        _image_xscale = 1;
    }

    var _sprite_id = 0;
    if (_player.sprite_index >= 0 && _player.sprite_index < 65535)
    {
        _sprite_id = _player.sprite_index;
    }

    var _buffer = buffer_create(38, buffer_fixed, 1);
    buffer_write(_buffer, buffer_u64, 0);
    buffer_write(_buffer, buffer_f32, _player.x);
    buffer_write(_buffer, buffer_f32, _player.y);
    buffer_write(_buffer, buffer_f32, _hspeed);
    buffer_write(_buffer, buffer_f32, _vspeed);
    buffer_write(_buffer, buffer_f32, _image_xscale);
    buffer_write(_buffer, buffer_u32, room);
    buffer_write(_buffer, buffer_u16, _sprite_id);
    buffer_write(_buffer, buffer_f32, _player.image_index);
    var _sent = scr_lm_mp_send_packet(10, _buffer);
    buffer_delete(_buffer);
    return _sent;
}
