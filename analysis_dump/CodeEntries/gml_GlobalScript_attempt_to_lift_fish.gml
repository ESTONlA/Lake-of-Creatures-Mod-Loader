function attempt_to_lift_fish(arg0, arg1, arg2)
{
    var rope_holder_object = -4;
    if (instance_exists(obj_rope_holder_end))
    {
        rope_holder_object = obj_rope_holder_end;
    }
    if (rope_holder_object != -4)
    {
        if (arg0.lift_anywhere == true)
        {
            spawn_fish_lifted_up(arg0, arg1, arg2);
        }
        else if (instance_exists(obj_player))
        {
            if (collision_circle(obj_player.x, obj_player.y, 50, rope_holder_object, 0, 0) && arg0.fish_energy_left <= 10)
            {
                spawn_fish_lifted_up(arg0, arg1, arg2);
            }
            else
            {
                yank_fish(arg0);
            }
        }
    }
}
