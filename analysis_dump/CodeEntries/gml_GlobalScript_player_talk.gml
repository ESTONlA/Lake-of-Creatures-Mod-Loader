function player_talk(arg0, arg1)
{
    if (instance_exists(obj_player))
    {
        text_popup_pinned(arg0, arg1, obj_player);
    }
}
