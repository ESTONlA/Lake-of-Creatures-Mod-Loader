function input_source_add(arg0, arg1 = 0)
{
    __input_initialize();
    if (arg1 < 0)
    {
        __input_error("Invalid player index provided (", arg1, ")");
        return undefined;
    }
    if (arg1 >= 4)
    {
        __input_error("Player index too large (", arg1, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
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
    global.__input_players[arg1].__source_add(arg0);
}

enum UnknownEnum
{
    Value_2 = 2
}
