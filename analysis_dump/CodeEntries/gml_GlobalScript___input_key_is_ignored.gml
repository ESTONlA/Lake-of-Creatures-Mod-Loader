function __input_key_is_ignored(arg0)
{
    if (variable_struct_exists(global.__input_ignore_key_dict, arg0))
    {
        return true;
    }
    return false;
}
