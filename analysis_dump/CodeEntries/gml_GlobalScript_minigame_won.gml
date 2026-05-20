function minigame_won(arg0, arg1)
{
    if (instance_exists(obj_rope_holder_end))
    {
        if (arg0 >= arg1)
        {
            obj_rope_holder_end.fish_on_underwater_array[0].fish_my_minigame = 0;
            if (obj_rope_holder_end.fish_on_underwater_array[0].fish_energy_left >= 10)
            {
                obj_rope_holder_end.fish_on_underwater_array[0].fish_energy_left = 9;
            }
            global.line_stress = 0;
            instance_destroy();
        }
    }
}
