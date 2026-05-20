function __input_class_gamepad_mapping(arg0, arg1, arg2, arg3) constructor
{
    static tick = function(arg0, arg1, arg2)
    {
        held_previous = held;
        if (__value_previous != undefined)
        {
            __value_previous = value;
        }
        value = 0;
        held = false;
        press = false;
        release = false;
        if (!arg2)
        {
            exit;
        }
        if (!arg1)
        {
            switch (type)
            {
                case UnknownEnum.Value_0:
                    value = gamepad_button_check(arg0, raw);
                    break;
                case UnknownEnum.Value_1:
                    value = gamepad_axis_value(arg0, raw);
                    break;
                case UnknownEnum.Value_2:
                    value = (gamepad_hat_value(arg0, raw) & hat_mask) > 0;
                    break;
                case UnknownEnum.Value_3:
                    value = ((gamepad_hat_value(arg0, raw_positive) & hat_mask_positive) > 0) - ((gamepad_hat_value(arg0, raw_negative) & hat_mask_negative) > 0);
                    break;
                case UnknownEnum.Value_4:
                    var _positive = gamepad_button_check(arg0, raw_positive);
                    var _negative = gamepad_button_check(arg0, raw_negative);
                    value = _positive - _negative;
                    break;
                case UnknownEnum.Value_5:
                    var _positive = gamepad_axis_value(arg0, raw_positive);
                    var _negative = gamepad_axis_value(arg0, raw_negative);
                    if (positive_clamp_negative)
                    {
                        _positive = clamp(_positive, -1, 0);
                    }
                    if (positive_clamp_positive)
                    {
                        _positive = clamp(_positive, 0, 1);
                    }
                    if (negative_clamp_negative)
                    {
                        _negative = clamp(_negative, -1, 0);
                    }
                    if (negative_clamp_positive)
                    {
                        _negative = clamp(_negative, 0, 1);
                    }
                    value = _positive - _negative;
                    break;
            }
            if (limited_range)
            {
                value = (2 * value) - 1;
            }
            if (extended_range)
            {
                value = 0.5 + (0.5 * value);
            }
            if (clamp_negative)
            {
                value = clamp(value, -1, 0);
            }
            if (clamp_positive)
            {
                value = clamp(value, 0, 1);
            }
            if (invert)
            {
                value = 1 - value;
            }
            if (reverse)
            {
                value = -value;
            }
            value = clamp(value, -1, 1);
            if (__value_previous == undefined)
            {
                __value_previous = value;
            }
            __value_delta = value - __value_previous;
            held = abs(value) > 0.2;
        }
        if (held_previous != held)
        {
            if (held)
            {
                press = true;
            }
            else
            {
                release = true;
            }
        }
    };
    
    gm = arg0;
    raw = arg1;
    type = arg2;
    sdl_name = arg3;
    invert = false;
    clamp_negative = false;
    clamp_positive = false;
    reverse = false;
    limited_range = false;
    extended_range = false;
    hat_mask = undefined;
    raw_negative = undefined;
    raw_positive = undefined;
    hat_mask_negative = undefined;
    hat_mask_positive = undefined;
    positive_clamp_negative = false;
    positive_clamp_positive = false;
    negative_clamp_negative = false;
    negative_clamp_positive = false;
    held_previous = false;
    value = 0;
    held = false;
    press = false;
    release = false;
    __value_previous = undefined;
    __value_delta = 0;
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4,
    Value_5
}
