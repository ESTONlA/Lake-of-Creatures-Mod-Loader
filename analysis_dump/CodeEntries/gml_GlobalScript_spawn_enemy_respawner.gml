function spawn_enemy_respawner()
{
    var fish_respawn_disabled = true;
    if (fish_respawn_disabled == false)
    {
        if (instance_exists(obj_fish_underwater))
        {
            var respawner = instance_create_depth(x, y, 0, obj_enemy_respawner);
            respawner.spawner_index = image_index;
            respawner.spawner_angle = image_angle;
            respawner.tracked_enemy_id = obj;
        }
    }
}
