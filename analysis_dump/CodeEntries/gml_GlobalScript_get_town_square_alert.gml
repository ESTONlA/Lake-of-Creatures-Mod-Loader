function get_town_square_alert()
{
    if (my_text == "???")
    {
        return false;
    }
    if (global.button_unlock[53] == 1)
    {
        return true;
    }
    if (global.newspaper_unread == true)
    {
        return true;
    }
}
