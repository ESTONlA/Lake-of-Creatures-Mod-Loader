function approach_pulse_step(arg0, arg1, arg2)
{
    var target_final = arg1 * 1.9;
    var spd_final = arg2;
    if (arg0 > arg1)
    {
        approach_pulse_reverse = true;
    }
    if (approach_pulse_reverse == true)
    {
        target_final = arg1;
        spd_final = arg2 * 1.5;
    }
    return (target_final - arg0) * spd_final;
}
