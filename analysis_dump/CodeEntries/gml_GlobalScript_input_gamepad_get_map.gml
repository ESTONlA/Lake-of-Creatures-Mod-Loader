function input_gamepad_get_map(arg0)
{
    if (arg0 == undefined || arg0 < 0 || arg0 >= array_length(global.__input_gamepads))
    {
        return [];
    }
    var _gamepad = global.__input_gamepads[arg0];
    if (!is_struct(_gamepad))
    {
        return [];
    }
    with (_gamepad)
    {
        if (!custom_mapping)
        {
            return [32769, 32770, 32771, 32772, 32782, 32781, 32783, 32784, 32773, 32774, 32775, 32776, 32785, 32786, 32787, 32788, 32778, 32777, 32779, 32780];
        }
        var _output = array_create(array_length(mapping_array), undefined);
        var _i = 0;
        repeat (array_length(mapping_array))
        {
            array_set(_output, _i, mapping_array[_i].gm);
            _i++;
        }
        return _output;
    }
}
