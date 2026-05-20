function scr_lm_mp_update_world_state(_buffer)
{
    if (!variable_global_exists("lm_mp_match_started") || !global.lm_mp_match_started)
    {
        return;
    }

    if (variable_global_exists("lm_mp_is_host") && global.lm_mp_is_host)
    {
        return;
    }

    if (!variable_global_exists("lm_mp_remote_entities") || !is_array(global.lm_mp_remote_entities))
    {
        global.lm_mp_remote_entities = [];
    }
    if (!variable_global_exists("lm_mp_remote_entity_ids") || !is_array(global.lm_mp_remote_entity_ids))
    {
        global.lm_mp_remote_entity_ids = [];
    }
    if (!variable_global_exists("lm_mp_remote_entity_seen") || !is_array(global.lm_mp_remote_entity_seen))
    {
        global.lm_mp_remote_entity_seen = [];
    }

    var _host_room = buffer_read(_buffer, buffer_u16);
    var _snapshot_tick = buffer_read(_buffer, buffer_u16);
    var _chunk = buffer_read(_buffer, buffer_u8);
    var _is_final = buffer_read(_buffer, buffer_u8);
    var _count = buffer_read(_buffer, buffer_u8);

    global.lm_mp_world_tick = _snapshot_tick;
    global.lm_mp_host_room = _host_room;

    if (_host_room != room)
    {
        global.lm_mp_status = "Host is in another room. Waiting for room sync.";
        for (var _hide_i = 0; _hide_i < array_length(global.lm_mp_remote_entities); _hide_i += 1)
        {
            var _hide_entity = global.lm_mp_remote_entities[_hide_i];
            if (instance_exists(_hide_entity))
            {
                _hide_entity.visible = false;
            }
        }
        return;
    }

    if (_count > 32)
    {
        _count = 32;
    }

    function _find_entity_slot(_entity_id)
    {
        for (var _slot_i = 0; _slot_i < array_length(global.lm_mp_remote_entity_ids); _slot_i += 1)
        {
            if (global.lm_mp_remote_entity_ids[_slot_i] == _entity_id)
            {
                return _slot_i;
            }
        }

        var _new_slot = array_length(global.lm_mp_remote_entity_ids);
        global.lm_mp_remote_entity_ids[_new_slot] = _entity_id;
        global.lm_mp_remote_entities[_new_slot] = noone;
        global.lm_mp_remote_entity_seen[_new_slot] = -1;
        return _new_slot;
    }

    for (var _i = 0; _i < _count; _i += 1)
    {
        var _entity_id = buffer_read(_buffer, buffer_u32);
        var _kind = buffer_read(_buffer, buffer_u8);
        var _object_index = buffer_read(_buffer, buffer_u16);
        var _sprite_index = buffer_read(_buffer, buffer_u16);
        var _x = buffer_read(_buffer, buffer_f32);
        var _y = buffer_read(_buffer, buffer_f32);
        var _image_index = buffer_read(_buffer, buffer_f32);
        var _image_xscale = buffer_read(_buffer, buffer_f32);
        var _image_yscale = buffer_read(_buffer, buffer_f32);
        var _image_angle = buffer_read(_buffer, buffer_f32);
        var _image_alpha = buffer_read(_buffer, buffer_f32);

        if (_entity_id <= 0 || _sprite_index < 0 || !sprite_exists(_sprite_index))
        {
            continue;
        }

        if (_x < -2000 || _x > room_width + 2000 || _y < -2000 || _y > room_height + 2000)
        {
            continue;
        }

        var _slot = _find_entity_slot(_entity_id);
        var _entity = global.lm_mp_remote_entities[_slot];

        if (!instance_exists(_entity))
        {
            _entity = instance_create_depth(_x, _y, -85000, obj_lm_remote_entity);
            global.lm_mp_remote_entities[_slot] = _entity;
        }

        _entity.lm_mp_entity_id = _entity_id;
        _entity.lm_mp_kind = _kind;
        _entity.lm_mp_room = _host_room;
        _entity.lm_mp_object_index = _object_index;
        _entity.lm_mp_seen_tick = _snapshot_tick;
        _entity.x = _x;
        _entity.y = _y;
        _entity.sprite_index = _sprite_index;
        _entity.image_index = _image_index;
        _entity.image_xscale = _image_xscale;
        _entity.image_yscale = _image_yscale;
        _entity.image_angle = _image_angle;
        _entity.image_alpha = clamp(_image_alpha, 0.2, 1);
        _entity.visible = true;
        global.lm_mp_remote_entity_seen[_slot] = _snapshot_tick;
    }

    if (_is_final)
    {
        for (var _stale = 0; _stale < array_length(global.lm_mp_remote_entities); _stale += 1)
        {
            var _stale_entity = global.lm_mp_remote_entities[_stale];
            var _seen = -1;
            if (_stale < array_length(global.lm_mp_remote_entity_seen))
            {
                _seen = global.lm_mp_remote_entity_seen[_stale];
            }

            if (instance_exists(_stale_entity) && _seen != _snapshot_tick)
            {
                _stale_entity.visible = false;
            }
        }
    }
}
