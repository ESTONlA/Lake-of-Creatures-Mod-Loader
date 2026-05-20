__input_initialize();
for (var _i = 0; _i < 2; _i++)
{
    if (_i == 1)
    {
        __input_finalize_default_profiles();
    }
    else if (is_struct(global.__input_default_profile_dict))
    {
        break;
    }
    else
    {
        global.__input_default_profile_dict = 
        {
            keyboard_and_mouse: 
            {
                up: [input_binding_key("W"), input_binding_key(38)],
                down: [input_binding_key("S"), input_binding_key(40)],
                left: [input_binding_key("A"), input_binding_key(37)],
                right: [input_binding_key("D"), input_binding_key(39)],
                reload: input_binding_key("R"),
                speedboost: input_binding_key(16),
                scroll_back: [input_binding_key("Q"), input_binding_mouse_wheel_down()],
                scroll_next: [input_binding_key("E"), input_binding_mouse_wheel_up()],
                interact: input_binding_key("F"),
                shoot: input_binding_mouse_button(1),
                melee: input_binding_mouse_button(2),
                pause: input_binding_key(27),
                leave: input_binding_key(27),
                menu_select: [input_binding_mouse_button(1), input_binding_key(32)],
                map_expand: input_binding_key(9)
            },
            gamepad: 
            {
                up: [input_binding_gamepad_axis(32786, true), input_binding_gamepad_button(32781)],
                down: [input_binding_gamepad_axis(32786, false), input_binding_gamepad_button(32782)],
                left: [input_binding_gamepad_axis(32785, true), input_binding_gamepad_button(32783)],
                right: [input_binding_gamepad_axis(32785, false), input_binding_gamepad_button(32784)],
                reload: input_binding_gamepad_button(32770),
                speedboost: input_binding_gamepad_button(32779),
                scroll_back: input_binding_gamepad_button(32775),
                scroll_next: input_binding_gamepad_button(32776),
                interact: input_binding_gamepad_button(32769),
                aim_up: input_binding_gamepad_axis(32788, true),
                aim_down: input_binding_gamepad_axis(32788, false),
                aim_left: input_binding_gamepad_axis(32787, true),
                aim_right: input_binding_gamepad_axis(32787, false),
                shoot: input_binding_gamepad_button(32774),
                melee: input_binding_gamepad_button(32773),
                pause: input_binding_gamepad_button(32778),
                leave: input_binding_gamepad_button(32770),
                menu_select: input_binding_gamepad_button(32769),
                map_expand: input_binding_gamepad_button(32777),
                axis_h_pos: input_binding_gamepad_axis(32787, false),
                axis_v_pos: input_binding_gamepad_axis(32788, false),
                axis_h_neg: input_binding_gamepad_axis(32787, true),
                axis_v_neg: input_binding_gamepad_axis(32788, true)
            }
        };
    }
}
