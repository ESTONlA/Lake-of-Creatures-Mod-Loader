function hook_lifted()
{
    obj_rope_holder.cast_cooldown = true;
    obj_rope_holder.rod_movement_cooldown = true;
    obj_rope_holder.alarm[1] = 30;
    obj_rope_holder.alarm[2] = 30;
    physics_joint_delete(attach);
    if (instance_exists(obj_hotspot))
    {
        with (obj_hotspot)
        {
            used = false;
        }
    }
    animation = instance_create_depth(x, y, 0, obj_animation);
    animation.sprite_index = spr_splash_1;
    animation.my_color = global.current_color_water_light;
    if (instance_exists(obj_rope))
    {
        obj_rope.float_xscale_ext = 0.3;
        obj_rope.float_yscale_ext = 0.3;
    }
    if (instance_exists(obj_rope_end_mover))
    {
        instance_destroy(obj_rope_end_mover);
    }
    if (lure_stuck == true)
    {
        if (global.current_lure == 0)
        {
            if (global.crickets > 0)
            {
                global.crickets -= 1;
            }
        }
        if (global.current_lure != 0)
        {
            global.current_lure = 0;
        }
    }
    if (fish_on == true || fish_on_underwater == true)
    {
    }
    else
    {
        instance_destroy();
    }
}
