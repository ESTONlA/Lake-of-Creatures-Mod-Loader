function is_fish_hooked()
{
    var result = false;
    if (instance_exists(obj_rope_holder_end))
    {
        if (obj_rope_holder_end.fish_on_underwater_array[0] != -4)
        {
            if (instance_exists(obj_rope_holder_end.fish_on_underwater_array[0]))
            {
                result = true;
            }
        }
    }
    return result;
}
