function __input_gamepad_find_in_sdl2_database()
{
    if (0 || blacklisted || xinput)
    {
        exit;
    }
    var _guid_dict = global.__input_sdl2_database.by_guid;
    if (variable_struct_exists(_guid_dict, guid))
    {
        _definition = variable_struct_get(_guid_dict, guid);
        sdl2_definition = _definition;
        description = _definition[1];
        exit;
    }
    var _definition = undefined;
    var _vp_array = variable_struct_get(global.__input_sdl2_database.by_vendor_product, vendor + product);
    if (is_array(_vp_array))
    {
        if (array_length(_vp_array) > 0)
        {
            _definition = _vp_array[0];
        }
    }
    if (is_array(_definition))
    {
        sdl2_definition = _definition;
        description = _definition[1];
    }
    else
    {
        __input_trace("Warning! No SDL definition found for ", guid, " (vendor=", vendor, ", product=", product, ")");
        sdl2_definition = undefined;
        description = "Unknown";
    }
}
