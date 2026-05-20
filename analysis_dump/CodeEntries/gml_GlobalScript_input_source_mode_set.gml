function input_source_mode_set(arg0)
{
    __input_initialize();
    if (arg0 != global.__input_source_mode)
    {
        global.__input_previous_source_mode = global.__input_source_mode;
        switch (arg0)
        {
            case UnknownEnum.Value_0:
                break;
            case UnknownEnum.Value_1:
                __input_trace("Storing previous source mode (", global.__input_previous_source_mode, ")");
                break;
            case UnknownEnum.Value_2:
                var _i = 1;
                repeat (3)
                {
                    input_source_clear(_i);
                    _i++;
                }
                break;
            case UnknownEnum.Value_3:
            case UnknownEnum.Value_4:
                input_source_set(-3, 0, false);
                break;
        }
    }
    global.__input_source_mode = arg0;
}

enum UnknownEnum
{
    Value_0,
    Value_1,
    Value_2,
    Value_3,
    Value_4
}
