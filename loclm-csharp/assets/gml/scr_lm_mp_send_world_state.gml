function scr_lm_mp_send_world_state()
{
    if (!global.lm_mp_match_started || !global.lm_mp_is_host || !global.lm_mp_connected)
    {
        return false;
    }

    if (!variable_global_exists("lm_mp_next_entity_id"))
    {
        global.lm_mp_next_entity_id = 1;
    }

    var _max_entities = 32;
    var _entity_bytes = 37;
    var _snapshot_tick = global.lm_mp_world_tick + 1;
    global.lm_mp_world_tick = _snapshot_tick;

    var _buffer = -1;
    var _count = 0;
    var _chunk = 0;
    var _sent_any = false;

    function _begin_chunk()
    {
        _buffer = buffer_create(7 + (_max_entities * _entity_bytes), buffer_fixed, 1);
        buffer_write(_buffer, buffer_u16, room);
        buffer_write(_buffer, buffer_u16, _snapshot_tick);
        buffer_write(_buffer, buffer_u8, _chunk);
        buffer_write(_buffer, buffer_u8, 0);
        buffer_write(_buffer, buffer_u8, 0);
        _count = 0;
    }

    function _flush_chunk(_is_final)
    {
        if (_buffer == -1)
        {
            return;
        }

        buffer_seek(_buffer, buffer_seek_start, 5);
        var _final_flag = 0;
        if (_is_final)
        {
            _final_flag = 1;
        }

        buffer_write(_buffer, buffer_u8, _final_flag);
        buffer_write(_buffer, buffer_u8, _count);

        if (_count > 0 || _is_final)
        {
            _sent_any = scr_lm_mp_send_packet(16, _buffer) || _sent_any;
        }

        buffer_delete(_buffer);
        _buffer = -1;
        _chunk += 1;
    }

    function _entity_id_for(_inst)
    {
        if (!variable_instance_exists(_inst, "lm_mp_entity_id") || _inst.lm_mp_entity_id <= 0)
        {
            _inst.lm_mp_entity_id = global.lm_mp_next_entity_id;
            global.lm_mp_next_entity_id += 1;
            if (global.lm_mp_next_entity_id > 2000000000)
            {
                global.lm_mp_next_entity_id = 1;
            }
        }

        return _inst.lm_mp_entity_id;
    }

    function _write_entity(_inst, _kind)
    {
        if (!instance_exists(_inst) || !_inst.visible || _inst.sprite_index < 0 || _inst.sprite_index > 65535)
        {
            return;
        }

        var _obj = _inst.object_index;
        if (_obj < 0 || _obj > 65535)
        {
            return;
        }

        if (_buffer == -1)
        {
            _begin_chunk();
        }
        if (_count >= _max_entities)
        {
            _flush_chunk(false);
            _begin_chunk();
        }

        buffer_write(_buffer, buffer_u32, _entity_id_for(_inst));
        buffer_write(_buffer, buffer_u8, _kind);
        buffer_write(_buffer, buffer_u16, _obj);
        buffer_write(_buffer, buffer_u16, _inst.sprite_index);
        buffer_write(_buffer, buffer_f32, _inst.x);
        buffer_write(_buffer, buffer_f32, _inst.y);
        buffer_write(_buffer, buffer_f32, _inst.image_index);
        buffer_write(_buffer, buffer_f32, _inst.image_xscale);
        buffer_write(_buffer, buffer_f32, _inst.image_yscale);
        buffer_write(_buffer, buffer_f32, _inst.image_angle);
        buffer_write(_buffer, buffer_f32, _inst.image_alpha);
        _count += 1;
    }

    function _write_entities_for_object(_object, _kind)
    {
        var _total = instance_number(_object);
        for (var _i = 0; _i < _total; _i += 1)
        {
            _write_entity(instance_find(_object, _i), _kind);
        }
    }

    if (asset_get_index("obj_enemy") >= 0) _write_entities_for_object(obj_enemy, 1);
    if (asset_get_index("obj_bullet") >= 0) _write_entities_for_object(obj_bullet, 2);
    if (asset_get_index("obj_fish") >= 0) _write_entities_for_object(obj_fish, 3);
    if (asset_get_index("obj_fish_caught") >= 0) _write_entities_for_object(obj_fish_caught, 3);
    if (asset_get_index("obj_fish_underwater") >= 0) _write_entities_for_object(obj_fish_underwater, 3);
    if (asset_get_index("obj_weapon_pickup") >= 0) _write_entities_for_object(obj_weapon_pickup, 4);
    if (asset_get_index("obj_cricket") >= 0) _write_entities_for_object(obj_cricket, 4);
    if (asset_get_index("obj_pickup_item_pickup") >= 0) _write_entities_for_object(obj_pickup_item_pickup, 4);
    if (asset_get_index("obj_item_pickup") >= 0) _write_entities_for_object(obj_item_pickup, 4);
    if (asset_get_index("obj_hotspot") >= 0) _write_entities_for_object(obj_hotspot, 5);
    if (asset_get_index("obj_cast_blocker") >= 0) _write_entities_for_object(obj_cast_blocker, 6);
    if (asset_get_index("obj_water_plant") >= 0) _write_entities_for_object(obj_water_plant, 6);
    if (asset_get_index("obj_chest") >= 0) _write_entities_for_object(obj_chest, 7);
    if (asset_get_index("obj_machine") >= 0) _write_entities_for_object(obj_machine, 7);
    if (asset_get_index("obj_clam") >= 0) _write_entities_for_object(obj_clam, 7);
    if (asset_get_index("obj_mud") >= 0) _write_entities_for_object(obj_mud, 6);
    if (asset_get_index("obj_pink_button") >= 0) _write_entities_for_object(obj_pink_button, 7);
    if (asset_get_index("obj_secret_room_setter") >= 0) _write_entities_for_object(obj_secret_room_setter, 7);

    _flush_chunk(true);
    return _sent_any;
}
