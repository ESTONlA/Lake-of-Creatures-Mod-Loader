function input_system_export(arg0 = true, arg1 = false)
{
    var _players_array = array_create(4, undefined);
    var _root_json = 
    {
        accessibility: 
        {
            momentary_state: global.__input_toggle_momentary_state,
            momentary_verbs: variable_struct_get_names(global.__input_toggle_momentary_dict),
            cooldown_state: global.__input_cooldown_state,
            cooldown_verbs: variable_struct_get_names(global.__input_cooldown_dict)
        },
        mouse: 
        {
            capture: global.__input_mouse_capture,
            sensitivity: global.__input_mouse_capture_sensitivity
        },
        players: _players_array
    };
    var _p = 0;
    repeat (4)
    {
        with (global.__input_players[_p])
        {
            array_set(_players_array, _p, __export());
        }
        _p++;
    }
    if (arg0)
    {
        if (arg1)
        {
            return __input_snap_to_json(_root_json, true, true);
        }
        else
        {
            return json_stringify(_root_json);
        }
    }
    else
    {
        return _root_json;
    }
}
