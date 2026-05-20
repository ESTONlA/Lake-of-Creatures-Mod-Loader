function scr_lm_mp_spawn_remote_player(_steam_id)
{
    if (!variable_global_exists("lm_mp_remote_player_instance"))
    {
        global.lm_mp_remote_player_instance = noone;
    }

    if (instance_exists(global.lm_mp_remote_player_instance))
    {
        return global.lm_mp_remote_player_instance;
    }

    var _ghost = instance_create_depth(0, 0, -90000, obj_lm_remote_player);
    _ghost.lm_mp_steam_id = _steam_id;
    global.lm_mp_remote_player_instance = _ghost;
    return _ghost;
}
