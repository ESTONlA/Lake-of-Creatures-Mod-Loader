function input_ignore_key_remove(arg0)
{
    if (is_string(arg0))
    {
        arg0 = ord(string_upper(arg0));
    }
    if (variable_struct_exists(global.__input_ignore_key_dict, arg0))
    {
        variable_struct_remove(global.__input_ignore_key_dict, arg0);
    }
    else
    {
        __input_trace("Could not un-ignore keycode ", arg0, ", it is already permitted");
    }
}
