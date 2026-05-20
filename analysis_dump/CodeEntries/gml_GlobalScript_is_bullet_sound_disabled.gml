function is_bullet_sound_disabled(arg0)
{
    var result = false;
    if (arg0.scatter_bullet_child == true)
    {
        result = true;
    }
    if (arg0.burning_shot == true)
    {
        result = true;
    }
    if (arg0.duplication_shot_child == true)
    {
        result = true;
    }
    return result;
}
