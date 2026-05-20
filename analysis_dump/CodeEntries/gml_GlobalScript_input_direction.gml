function input_direction(arg0, arg1, arg2, arg3, arg4 = undefined, arg5 = false)
{
    var _result = input_xy(arg0, arg1, arg2, arg3, arg4, arg5);
    if (_result.x == 0 && _result.y == 0)
    {
        return undefined;
    }
    return point_direction(0, 0, _result.x, _result.y);
}
