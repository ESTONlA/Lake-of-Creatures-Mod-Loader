function input_source_detect_input(arg0, arg1 = true)
{
    switch (arg0.__source)
    {
        case UnknownEnum.Value_0:
            if (global.__input_any_keyboard_binding_defined && (!arg1 || input_source_is_available(arg0)) && keyboard_check_pressed(vk_anykey) && !__input_key_is_ignored(__input_keyboard_key()))
            {
                return true;
            }
            if ((!arg1 || input_source_is_available(arg0)) && (input_mouse_check(-1) || mouse_wheel_up() || mouse_wheel_down()))
            {
                return true;
            }
            break;
        case UnknownEnum.Value_1:
            if ((!arg1 || input_source_is_available(arg0)) && (input_mouse_check(-1) || mouse_wheel_up() || mouse_wheel_down()))
            {
                return true;
            }
            break;
        case UnknownEnum.Value_2:
            if (global.__input_any_gamepad_binding_defined)
            {
                var _gamepad = arg0.__gamepad;
                if (input_gamepad_is_connected(_gamepad) && (!arg1 || input_source_is_available(arg0)))
                {
                    if (input_gamepad_check_pressed(_gamepad, 32769) || input_gamepad_check_pressed(_gamepad, 32770) || input_gamepad_check_pressed(_gamepad, 32771) || input_gamepad_check_pressed(_gamepad, 32772) || input_gamepad_check_pressed(_gamepad, 32781) || input_gamepad_check_pressed(_gamepad, 32782) || input_gamepad_check_pressed(_gamepad, 32783) || input_gamepad_check_pressed(_gamepad, 32784) || input_gamepad_check_pressed(_gamepad, 32773) || input_gamepad_check_pressed(_gamepad, 32774) || input_gamepad_check_pressed(_gamepad, 32775) || input_gamepad_check_pressed(_gamepad, 32776) || input_gamepad_check_pressed(_gamepad, 32778) || input_gamepad_check_pressed(_gamepad, 32777) || input_gamepad_check_pressed(_gamepad, 32779) || input_gamepad_check_pressed(_gamepad, 32780))
                    {
                        return true;
                    }
                    if (input_gamepad_check_pressed(_gamepad, 32889) || input_gamepad_check_pressed(_gamepad, 32890) || input_gamepad_check_pressed(_gamepad, 32891) || input_gamepad_check_pressed(_gamepad, 32892) || input_gamepad_check_pressed(_gamepad, 32893) || input_gamepad_check_pressed(_gamepad, 32894) || input_gamepad_check_pressed(_gamepad, 32895))
                    {
                        return true;
                    }
                }
            }
            break;
    }
    return false;
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2
}
