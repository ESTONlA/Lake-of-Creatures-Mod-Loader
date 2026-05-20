function scr_lm_mp_update_remote_player(_buffer)
{
    if (!variable_global_exists("lm_mp_match_started") || !global.lm_mp_match_started)
    {
        return;
    }

    var _steam_id = buffer_read(_buffer, buffer_u64);
    if (_steam_id == 0 || _steam_id < 10000000000000000 || _steam_id > 99999999999999999)
    {
        return;
    }

    var _x = buffer_read(_buffer, buffer_f32);
    var _y = buffer_read(_buffer, buffer_f32);
    var _hspeed = buffer_read(_buffer, buffer_f32);
    var _vspeed = buffer_read(_buffer, buffer_f32);
    var _image_xscale = buffer_read(_buffer, buffer_f32);
    var _room_id = buffer_read(_buffer, buffer_u32);
    var _sprite_id = buffer_read(_buffer, buffer_u16);
    var _image_index = buffer_read(_buffer, buffer_f32);

    if (_x < -100000 || _x > 100000 || _y < -100000 || _y > 100000)
    {
        return;
    }

    var _ghost = scr_lm_mp_spawn_remote_player(_steam_id);
    if (_ghost != noone)
    {
        _ghost.x = _x;
        _ghost.y = _y;
        _ghost.hspeed = _hspeed;
        _ghost.vspeed = _vspeed;
        _ghost.image_xscale = _image_xscale;
        _ghost.lm_mp_room = _room_id;
        _ghost.lm_mp_sprite = _sprite_id;
        _ghost.image_index = _image_index;
        if (_sprite_id > 0 && sprite_exists(_sprite_id))
        {
            _ghost.sprite_index = _sprite_id;
            _ghost.visible = true;
        }
        else
        {
            _ghost.visible = false;
        }
        global.lm_mp_peer_connected = true;
        global.lm_mp_connected_peer_count = max(1, global.lm_mp_connected_peer_count);
    }
}
