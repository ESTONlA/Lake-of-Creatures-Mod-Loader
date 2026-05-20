function fishing_line_delete()
{
    if (instance_exists(obj_rope_holder))
    {
        with (obj_rope_holder)
        {
            physics_joint_delete(attach);
            if (instance_exists(obj_rope))
            {
                instance_destroy(obj_rope);
            }
            if (instance_exists(obj_rope_holder_end))
            {
                instance_destroy(obj_rope_holder_end);
            }
            if (instance_exists(obj_rope_end_mover))
            {
                instance_destroy(obj_rope_end_mover);
            }
            if (instance_exists(obj_whip_mask))
            {
                instance_destroy(obj_whip_mask);
            }
            global.fishing_line_cast_phase = 0;
            instance_destroy();
        }
    }
}
