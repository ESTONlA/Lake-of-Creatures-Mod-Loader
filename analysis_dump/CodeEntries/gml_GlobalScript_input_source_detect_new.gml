function input_source_detect_new()
{
    var _gamepad_count = array_length(global.__input_source_gamepad);
    var _sort_order = 1;
    var _g = 0;
    _sort_order = -1;
    _g = _gamepad_count - 1;
    repeat (_gamepad_count)
    {
        if (input_source_detect_input(global.__input_source_gamepad[_g]))
        {
            return global.__input_source_gamepad[_g];
        }
        _g += _sort_order;
    }
    if (input_source_detect_input(global.__input_source_keyboard))
    {
        return global.__input_source_keyboard;
    }
    if (input_source_detect_input(global.__input_source_mouse))
    {
        return global.__input_source_mouse;
    }
    return undefined;
}
