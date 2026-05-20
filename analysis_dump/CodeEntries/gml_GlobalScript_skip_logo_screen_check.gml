function skip_logo_screen_check()
{
    if (file_exists("restarted.txt"))
    {
        file_delete("restarted.txt");
        return true;
    }
    return false;
}
