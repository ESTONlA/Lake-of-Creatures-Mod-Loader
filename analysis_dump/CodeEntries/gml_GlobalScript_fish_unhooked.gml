function fish_unhooked()
{
    obj_rope_holder_end.fish_on_underwater = false;
    obj_rope_holder_end.fish_on_underwater_amount -= 1;
    obj_rope_holder_end.fish_on_underwater_array[0] = -4;
    obj_rope_holder_end.alarm[0] = 1;
    instance_destroy(obj_minigame_4);
    caught = false;
    hp = hp_max;
}
