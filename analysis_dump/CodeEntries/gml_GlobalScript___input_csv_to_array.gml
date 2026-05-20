function __input_csv_to_array(arg0, arg1 = ",", arg2 = "\"")
{
    var _cell_delimiter_ord = ord(arg1);
    var _string_delimiter_double = arg2 + arg2;
    var _string_delimiter_ord = ord(arg2);
    var _size = string_byte_length(arg0) + 1;
    var _buffer = buffer_create(_size, buffer_fixed, 1);
    buffer_write(_buffer, buffer_text, arg0);
    buffer_seek(_buffer, buffer_seek_start, 0);
    var _root_array = [];
    var _row_array = undefined;
    var _newline = false;
    var _read = false;
    var _word_start = 0;
    var _in_string = false;
    var _string_cell = false;
    repeat (_size)
    {
        var _value = buffer_read(_buffer, buffer_u8);
        if (_value == _string_delimiter_ord)
        {
            _in_string = !_in_string;
            if (_in_string)
            {
                _string_cell = true;
            }
        }
        else
        {
            if (_value == 0)
            {
                if (_in_string)
                {
                    _string_cell = true;
                }
                _in_string = false;
                var _prev_value = buffer_peek(_buffer, buffer_tell(_buffer) - 2, buffer_u8);
                if (_prev_value != _cell_delimiter_ord && _prev_value != 10 && _prev_value != 13)
                {
                    _read = true;
                }
            }
            if (!_in_string)
            {
                if (_value == 10 || _value == 13)
                {
                    var _prev_value = buffer_peek(_buffer, buffer_tell(_buffer) - 2, buffer_u8);
                    if (_prev_value != 10 && _prev_value != 13)
                    {
                        _newline = true;
                        if (_prev_value != _cell_delimiter_ord)
                        {
                            _read = true;
                        }
                        else
                        {
                            _word_start++;
                        }
                    }
                    else
                    {
                        _word_start++;
                    }
                }
                if (_read || _value == _cell_delimiter_ord)
                {
                    _read = false;
                    var _tell = buffer_tell(_buffer);
                    var _old_value = buffer_peek(_buffer, _tell - 1, buffer_u8);
                    buffer_poke(_buffer, _tell - 1, buffer_u8, 0);
                    buffer_seek(_buffer, buffer_seek_start, _word_start);
                    var _string = buffer_read(_buffer, buffer_string);
                    buffer_poke(_buffer, _tell - 1, buffer_u8, _old_value);
                    if (_string_cell)
                    {
                        if (string_byte_at(_string, 1) == _string_delimiter_ord && string_byte_at(_string, string_byte_length(_string)) == _string_delimiter_ord)
                        {
                            _string = string_copy(_string, 2, string_length(_string) - 2);
                        }
                    }
                    _string = string_replace_all(_string, _string_delimiter_double, arg2);
                    if (_row_array == undefined)
                    {
                        _row_array = [];
                        array_set(_root_array, array_length(_root_array), _row_array);
                    }
                    array_set(_row_array, array_length(_row_array), _string);
                    _string_cell = false;
                    _word_start = _tell;
                }
                if (_newline)
                {
                    _newline = false;
                    _row_array = undefined;
                }
            }
        }
    }
    buffer_delete(_buffer);
    return _root_array;
}
