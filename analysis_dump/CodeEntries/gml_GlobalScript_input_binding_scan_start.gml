function input_binding_scan_start(arg0, arg1 = undefined, arg2 = undefined, arg3 = 0)
{
    __input_initialize();
    if (arg3 < 0)
    {
        __input_error("Invalid player index provided (", arg3, ")");
        return undefined;
    }
    if (arg3 >= 4)
    {
        __input_error("Player index too large (", arg3, " must be less than ", 4, ")\nIncrease INPUT_MAX_PLAYERS to support more players");
        return undefined;
    }
    if (arg2 == undefined)
    {
        arg2 = global.__input_players[arg3].__source_array;
    }
    else if (!is_array(arg2))
    {
        arg2 = [arg2];
    }
    if (!(is_method(arg0) || (is_numeric(arg0) && script_exists(arg0))))
    {
        __input_error("Binding scan success callback set to an illegal value (typeof=", typeof(arg0), ")");
    }
    if (!(is_method(arg1) || (is_numeric(arg1) && script_exists(arg1)) || arg1 == undefined))
    {
        __input_error("Binding scan failure callback set to an illegal value (typeof=", typeof(arg1), ")");
    }
    with (global.__input_players[arg3])
    {
        __rebind_state = 1;
        __rebind_start_time = global.__input_current_time;
        __rebind_success_callback = arg0;
        __rebind_failure_callback = arg1;
        __rebind_source_filter = arg2;
        __input_trace("Binding scan started for player ", arg3);
    }
}
