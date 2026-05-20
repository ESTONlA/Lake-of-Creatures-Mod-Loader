function input_system_import(arg0)
{
    var _json;
    if (is_string(arg0))
    {
        _json = json_parse(arg0);
    }
    else
    {
        _json = arg0;
    }
    if (!is_struct(_json))
    {
        __input_error("Input must be valid JSON (typeof=", typeof(arg0), ")");
        exit;
    }
    input_system_reset();
    if (!is_struct(struct_get_from_hash(_json, variable_get_hash("accessibility"))))
    {
        __input_error("Accessibility settings are missing from JSON");
        exit;
    }
    global.__input_toggle_momentary_state = _json.accessibility.momentary_state;
    global.__input_toggle_momentary_dict = {};
    var _momentary_verb_array = _json.accessibility.momentary_verbs;
    if (!is_array(_momentary_verb_array))
    {
        __input_error("Momentary toggle verbs are corrupted");
        exit;
    }
    var _i = 0;
    repeat (array_length(_momentary_verb_array))
    {
        variable_struct_set(global.__input_toggle_momentary_dict, @@array_get@@(_momentary_verb_array, _i), true);
        _i++;
    }
    global.__input_cooldown_state = _json.accessibility.cooldown_state;
    global.__input_cooldown_dict = {};
    var _cooldown_verb_array = _json.accessibility.cooldown_verbs;
    if (!is_array(_cooldown_verb_array))
    {
        __input_error("Cooldown verbs are corrupted");
        exit;
    }
    _i = 0;
    repeat (array_length(_cooldown_verb_array))
    {
        variable_struct_set(global.__input_cooldown_dict, @@array_get@@(_cooldown_verb_array, _i), true);
        _i++;
    }
    if (!is_struct(struct_get_from_hash(_json, variable_get_hash("mouse"))))
    {
        __input_error("Mouse settings are missing from JSON");
        exit;
    }
    input_mouse_capture_set(_json.mouse.capture, _json.mouse.sensitivity);
    if (!is_array(struct_get_from_hash(_json, variable_get_hash("players"))))
    {
        __input_error("Player settings are missing from JSON");
        exit;
    }
    var _players_array = _json.players;
    if (!is_array(_players_array))
    {
        __input_error("Player settings are corrupted");
        exit;
    }
    if (array_length(_players_array) != array_length(global.__input_players))
    {
        __input_error("Player settings length mismatch\nFound ", array_length(_players_array), " players in JSON but we are expecting ", array_length(global.__input_players), " players");
        exit;
    }
    var _p = 0;
    repeat (array_length(_players_array))
    {
        with (global.__input_players[_p])
        {
            __import(_players_array[_p]);
        }
        _p++;
    }
}
