function input_source_share(arg0, arg1, arg2 = true)
{
    __input_initialize();
    if (instanceof(arg0) != "__input_class_source")
    {
        __input_error("Invalid source provided (", arg0, ")");
    }
    if (arg0 == global.__input_source_keyboard)
    {
        if (!global.__input_any_keyboard_binding_defined && !global.__input_any_mouse_binding_defined)
        {
            __input_error("Cannot claim ", arg0, ", no keyboard or mouse bindings have been created in a default profile");
        }
    }
    else if (arg0 == global.__input_source_mouse)
    {
        if (!global.__input_any_mouse_binding_defined)
        {
            __input_error("Cannot claim ", arg0, ", no mouse bindings have been created in a default profile");
        }
    }
    else if (arg0.__source == UnknownEnum.Value_2)
    {
        if (!global.__input_any_gamepad_binding_defined)
        {
            __input_error("Cannot claim ", arg0, ", no gamepad bindings have been created in a default profile");
        }
    }
    __input_source_relinquish(arg0);
    var _i = 0;
    repeat (array_length(arg1))
    {
        var _player_index = arg1[_i];
        if (_player_index < 0)
        {
            __input_error("Invalid player index provided (", _player_index, ")");
            return undefined;
        }
        if (_player_index >= 4)
        {
            __input_error("Player index too large (", _player_index, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
            return undefined;
        }
        with (global.__input_players[_player_index])
        {
            __sources_clear();
            __source_add(arg0);
            if (arg2)
            {
                __profile_set_auto();
            }
        }
        _i++;
    }
}

enum UnknownEnum
{
    Value_2 = 2
}
