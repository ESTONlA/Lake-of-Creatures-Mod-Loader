function __input_system_tick()
{
    global.__input_frame++;
    global.__input_previous_current_time = global.__input_current_time;
    global.__input_current_time = current_time;
    global.__input_cleared = false;
    if (os_is_paused())
    {
        global.__input_window_focus = false;
        io_clear();
    }
    else if (global.__input_window_focus)
    {
        if (global.__input_window_focus_block_mouse)
        {
            global.__input_window_focus_block_mouse = false;
            if (__input_mouse_button() != 0)
            {
                global.__input_window_focus_block_mouse = true;
            }
        }
    }
    else if (keyboard_key != vk_nokey || mouse_button != mb_none || (true && window_has_focus()) || (false && global.__input_pointer_moved))
    {
        global.__input_window_focus = true;
        global.__input_window_focus_block_mouse = true;
        if (global.__input_mouse_capture)
        {
            global.__input_mouse_capture_frame = global.__input_frame;
        }
    }
    var _moved = false;
    var _m = 0;
    repeat (UnknownEnum.Value_3)
    {
        array_set(global.__input_pointer_dx, _m, 0);
        array_set(global.__input_pointer_dy, _m, 0);
        _m++;
    }
    __input_release_multimonitor_cursor();
    if (global.__input_mouse_capture)
    {
        if (global.__input_window_focus)
        {
            if ((global.__input_frame - global.__input_mouse_capture_frame) > 10)
            {
                _m = 0;
                repeat (UnknownEnum.Value_3)
                {
                    var _pointer_x, _old_x, _pointer_y, _old_y;
                    switch (_m)
                    {
                        case UnknownEnum.Value_0:
                            if (view_enabled && view_visible[0])
                            {
                                var _camera = view_camera[0];
                                _old_x = camera_get_view_width(_camera) / 2;
                                _old_y = camera_get_view_height(_camera) / 2;
                            }
                            else
                            {
                                _old_x = room_width / 2;
                                _old_y = room_height / 2;
                            }
                            _pointer_x = device_mouse_x(global.__input_pointer_index);
                            _pointer_y = device_mouse_y(global.__input_pointer_index);
                            break;
                        case UnknownEnum.Value_1:
                            _old_x = display_get_gui_width() / 2;
                            _old_y = display_get_gui_height() / 2;
                            _pointer_x = device_mouse_x_to_gui(global.__input_pointer_index);
                            _pointer_y = device_mouse_y_to_gui(global.__input_pointer_index);
                            break;
                        case UnknownEnum.Value_2:
                            _old_x = window_get_width() / 2;
                            _old_y = window_get_height() / 2;
                            _pointer_x = display_mouse_get_x() - window_get_x();
                            _pointer_y = display_mouse_get_y() - window_get_y();
                            break;
                    }
                    var _dx = (_pointer_x - _old_x) * global.__input_mouse_capture_sensitivity;
                    var _dy = (_pointer_y - _old_y) * global.__input_mouse_capture_sensitivity;
                    if (_m == UnknownEnum.Value_2 && ((_dx * _dx) + (_dy * _dy)) > 4)
                    {
                        _moved = true;
                    }
                    array_set(global.__input_pointer_dx, _m, _dx);
                    array_set(global.__input_pointer_dy, _m, _dy);
                    array_set(global.__input_pointer_x, _m, @@array_get@@(global.__input_pointer_x, _m) + _dx);
                    array_set(global.__input_pointer_y, _m, @@array_get@@(global.__input_pointer_y, _m) + _dy);
                    _m++;
                }
            }
            window_mouse_set(window_get_width() / 2, window_get_height() / 2);
        }
    }
    else if (global.__input_window_focus || false || false)
    {
        _m = 0;
        repeat (UnknownEnum.Value_3)
        {
            var _old_x = global.__input_pointer_x[_m];
            var _old_y = global.__input_pointer_y[_m];
            var _pointer_x = _old_x;
            var _pointer_y = _old_y;
            switch (_m)
            {
                case UnknownEnum.Value_0:
                    _pointer_x = device_mouse_x(global.__input_pointer_index);
                    _pointer_y = device_mouse_y(global.__input_pointer_index);
                    break;
                case UnknownEnum.Value_1:
                    _pointer_x = device_mouse_x_to_gui(global.__input_pointer_index);
                    _pointer_y = device_mouse_y_to_gui(global.__input_pointer_index);
                    break;
                case UnknownEnum.Value_2:
                    _pointer_x = display_mouse_get_x() - window_get_x();
                    _pointer_y = display_mouse_get_y() - window_get_y();
                    break;
            }
            if (_m == UnknownEnum.Value_2 && point_distance(_old_x, _old_y, _pointer_x, _pointer_y) > 2)
            {
                _moved = true;
            }
            array_set(global.__input_pointer_dx, _m, _pointer_x - _old_x);
            array_set(global.__input_pointer_dy, _m, _pointer_y - _old_y);
            array_set(global.__input_pointer_x, _m, _pointer_x);
            array_set(global.__input_pointer_y, _m, _pointer_y);
            _m++;
        }
    }
    global.__input_pointer_moved = _moved;
    global.__input_tap_click = false;
    global.__input_tap_presses += device_mouse_check_button_pressed(0, mb_left);
    global.__input_tap_releases += device_mouse_check_button_released(0, mb_left);
    if (global.__input_tap_releases >= global.__input_tap_presses)
    {
        global.__input_tap_click = global.__input_tap_releases > global.__input_tap_presses;
        global.__input_tap_presses = 0;
        global.__input_tap_releases = 0;
    }
    if (global.__input_keyboard_allowed && keyboard_check(vk_anykey))
    {
        var _platform = 0;
        switch (_platform)
        {
            case 0:
                if (keyboard_check(vk_alt) && keyboard_check_pressed(vk_space))
                {
                    keyboard_key_release(vk_alt);
                    keyboard_key_release(vk_space);
                    keyboard_key_release(vk_lalt);
                    keyboard_key_release(vk_ralt);
                }
                break;
            case "apple_web":
                if (keyboard_check_released(92) || keyboard_check_released(93))
                {
                    var _i = 8;
                    var _len = 255 - _i;
                    repeat (_len)
                    {
                        keyboard_key_release(_i);
                        _i++;
                    }
                }
                break;
            case 1:
                if (keyboard_check_released(vk_control))
                {
                    keyboard_key_release(vk_lcontrol);
                    keyboard_key_release(vk_rcontrol);
                }
                if (keyboard_check_released(vk_shift))
                {
                    keyboard_key_release(vk_lshift);
                    keyboard_key_release(vk_rshift);
                }
                if (keyboard_check_released(vk_alt))
                {
                    keyboard_key_release(vk_lalt);
                    keyboard_key_release(vk_ralt);
                }
                if (keyboard_check_released(91))
                {
                    keyboard_key_release(92);
                }
                else if (keyboard_check_released(92) && keyboard_check(91))
                {
                    keyboard_key_release(91);
                }
                break;
        }
    }
    if (global.__input_frame > 10)
    {
        var _device_change = max(0, gamepad_get_device_count() - array_length(global.__input_gamepads));
        repeat (_device_change)
        {
            array_push(global.__input_gamepads, undefined);
        }
        _device_change = max(0, gamepad_get_device_count() - array_length(global.__input_source_gamepad));
        repeat (_device_change)
        {
            array_push(global.__input_source_gamepad, new __input_class_source(UnknownEnum.Value_2, array_length(global.__input_source_gamepad)));
        }
        var _clear_gamepads = 1 && !global.__input_window_focus;
        _g = 0;
        repeat (array_length(global.__input_gamepads))
        {
            var _gamepad = global.__input_gamepads[_g];
            if (is_struct(_gamepad))
            {
                if (gamepad_is_connected(_g))
                {
                    _gamepad.tick(_clear_gamepads);
                }
                else
                {
                    __input_trace("Gamepad ", _g, " disconnected");
                    gamepad_set_vibration(@@array_get@@(global.__input_gamepads, _g).index, 0, 0);
                    array_set(global.__input_gamepads, _g, undefined);
                    _p = 0;
                    repeat (4)
                    {
                        with (global.__input_players[_p])
                        {
                            if (__source_contains(global.__input_source_gamepad[_g]))
                            {
                                __input_trace("Player ", _p, " gamepad disconnected");
                                __source_remove(global.__input_source_gamepad[_g]);
                            }
                        }
                        _p++;
                    }
                }
            }
            else if (gamepad_is_connected(_g))
            {
                __input_trace("Gamepad ", _g, " connected");
                __input_trace("New gamepad = \"", gamepad_get_description(_g), "\", GUID=\"", gamepad_get_guid(_g), "\", buttons = ", gamepad_button_count(_g), ", axes = ", gamepad_axis_count(_g), ", hats = ", gamepad_hat_count(_g));
                array_set(global.__input_gamepads, _g, new __input_class_gamepad(_g));
            }
            _g++;
        }
    }
    var _p = 0;
    repeat (4)
    {
        global.__input_players[_p].tick();
        _p++;
    }
    var _any_players_changed = false;
    var _connection_array = global.__input_players_status.new_connections;
    var _disconnection_array = global.__input_players_status.new_disconnections;
    var _status_array = global.__input_players_status.players;
    array_resize(_connection_array, 0);
    array_resize(_disconnection_array, 0);
    _p = 0;
    repeat (4)
    {
        var _old_status = _status_array[_p];
        if (global.__input_players[_p].__connected)
        {
            if (_old_status == UnknownEnum.Value_m1 || _old_status == UnknownEnum.Value_0)
            {
                _any_players_changed = true;
                array_set(_status_array, _p, UnknownEnum.Value_1);
                array_push(global.__input_players_status.new_connections, _p);
            }
            else
            {
                array_set(_status_array, _p, UnknownEnum.Value_2);
            }
        }
        else if (_old_status == UnknownEnum.Value_1 || _old_status == UnknownEnum.Value_2)
        {
            _any_players_changed = true;
            array_set(_status_array, _p, UnknownEnum.Value_m1);
            array_push(global.__input_players_status.new_disconnections, _p);
        }
        else
        {
            array_set(_status_array, _p, UnknownEnum.Value_0);
        }
        _p++;
    }
    global.__input_players_status.any_changed = _any_players_changed;
    var _any_gamepads_changed = false;
    _connection_array = global.__input_gamepads_status.new_connections;
    _disconnection_array = global.__input_gamepads_status.new_disconnections;
    _status_array = global.__input_gamepads_status.gamepads;
    array_resize(_connection_array, 0);
    array_resize(_disconnection_array, 0);
    var _device_count = gamepad_get_device_count();
    if (array_length(_status_array) != _device_count)
    {
        array_resize(_status_array, _device_count);
    }
    var _g = 0;
    repeat (_device_count)
    {
        var _old_status = _status_array[_g];
        if (input_gamepad_is_connected(_g))
        {
            if (_old_status == UnknownEnum.Value_m1 || _old_status == UnknownEnum.Value_0)
            {
                _any_gamepads_changed = true;
                array_set(_status_array, _g, UnknownEnum.Value_1);
                array_push(_connection_array, _g);
            }
            else
            {
                array_set(_status_array, _g, UnknownEnum.Value_2);
            }
        }
        else if (_old_status == UnknownEnum.Value_1 || _old_status == UnknownEnum.Value_2)
        {
            _any_gamepads_changed = true;
            array_set(_status_array, _g, UnknownEnum.Value_m1);
            array_push(_disconnection_array, _g);
        }
        else
        {
            array_set(_status_array, _g, UnknownEnum.Value_0);
        }
        _g++;
    }
    global.__input_gamepads_status.any_changed = _any_gamepads_changed;
    switch (global.__input_source_mode)
    {
        case UnknownEnum.Value_0:
            break;
        case UnknownEnum.Value_1:
            __input_multiplayer_assignment_tick();
            break;
        case UnknownEnum.Value_2:
            __input_hotswap_tick();
            break;
        case UnknownEnum.Value_3:
            break;
        case UnknownEnum.Value_4:
            break;
    }
}

enum UnknownEnum
{
    Value_m1 = -1,
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4
}
