function __input_multiplayer_assignment_tick()
{
    if ("cancel" != undefined && !variable_struct_exists(global.__input_basic_verb_dict, "cancel"))
    {
        __input_error("INPUT_MULTIPLAYER_LEAVE_VERB \"", "cancel", "\" doesn't exist");
    }
    if (1 && !(is_numeric(undefined) && script_exists(undefined)))
    {
        __input_error("INPUT_MULTIPLAYER_ABORT_CALLBACK has not been defined to a function or script");
    }
    var _abort = false;
    if (global.__input_multiplayer_drop_down)
    {
        var _fail;
        do
        {
            _fail = false;
            _p = 3;
            repeat (3)
            {
                if (input_player_connected(_p) && !input_player_connected(_p - 1))
                {
                    __input_trace("Assignment: Moving player ", _p, " (connected) to ", _p - 1, " (disconnected)");
                    input_player_swap(_p, _p - 1);
                    _fail = true;
                }
                _p--;
            }
        }
        until (!_fail);
    }
    var _p = global.__input_multiplayer_max;
    repeat (4 - global.__input_multiplayer_max)
    {
        input_source_clear(_p);
        _p++;
    }
    _p = 0;
    repeat (global.__input_multiplayer_max)
    {
        if (!input_player_connected(_p))
        {
            var _new_source = input_source_detect_new();
            if (_new_source != undefined)
            {
                with (global.__input_players[_p])
                {
                    __source_add(_new_source);
                    __profile_set_auto();
                    tick();
                }
                if ("cancel" != undefined && input_check_pressed("cancel") && input_player_connected_count() < global.__input_multiplayer_min && global.__input_multiplayer_min > 1 && global.__input_multiplayer_allow_abort)
                {
                    __input_trace("Assignment: Player ", _p, " aborted source assignment");
                    _abort = true;
                }
                else
                {
                    __input_trace("Assignment: Player ", _p, " joined");
                }
                input_consume(-3, _p);
            }
        }
        _p++;
    }
    _p = 0;
    repeat (global.__input_multiplayer_max)
    {
        if ("cancel" != undefined && input_check_pressed("cancel", _p))
        {
            __input_trace("Assignment: Player ", _p, " left");
            input_source_clear(_p);
        }
        _p++;
    }
    if (_abort && global.__input_multiplayer_allow_abort)
    {
        __input_trace("Assignment: Restoring source mode ", global.__input_previous_source_mode);
        input_source_mode_set(global.__input_previous_source_mode);
        global.__input_previous_source_mode = global.__input_source_mode;
        if (is_numeric(undefined) && script_exists(undefined))
        {
            script_execute(undefined);
        }
        else
        {
            __input_error("INPUT_MULTIPLAYER_ABORT_CALLBACK set to an illegal value (typeof=", typeof(undefined), ")");
        }
    }
    return _abort;
}
