function smooth_rotation(arg0, arg1, arg2)
{
    var result = sin(degtorad(arg1 - arg0)) * arg2;
    return result;
}
