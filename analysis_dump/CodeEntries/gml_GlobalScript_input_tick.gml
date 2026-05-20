function input_tick(arg0 = false)
{
    static _seen = false;
    
    if (global.__input_time_source != undefined)
    {
        time_source_stop(global.__input_time_source);
        global.__input_time_source = undefined;
        if (!_seen)
        {
            _seen = true;
            if (!arg0)
            {
                __input_error("In GMS2022.5 and later you don't need to manually call input_tick() if you're not checking player input in the Begin Step event");
            }
            exit;
        }
    }
    return __input_system_tick();
}
