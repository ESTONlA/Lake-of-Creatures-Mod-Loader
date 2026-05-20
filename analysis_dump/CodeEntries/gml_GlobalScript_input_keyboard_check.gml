function input_keyboard_check(arg0)
{
    if (!global.__input_keyboard_allowed)
    {
        return false;
    }
    return keyboard_check(arg0);
}
