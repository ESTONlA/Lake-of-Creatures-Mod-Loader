function birgit_get_wand_bar_image_index()
{
    var left = clamp(global.birgit_wand_misses_left, 0, global.birgit_wand_misses_max);
    var index = round((left / global.birgit_wand_misses_max) * 15);
    return index;
}
