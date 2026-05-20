function spawn_env_pieces(arg0, arg1, arg2, arg3)
{
    if (global.particles_enabled == true)
    {
        var spawn_range = 9;
        var fall_speed_default = 0.1;
        var amount = floor(random_range(3, 5));
        for (i = 0; i <= amount; i += 1)
        {
            var piece = instance_create_depth(arg1 + random_range(-spawn_range, spawn_range), arg2 + random_range(-spawn_range, spawn_range), depth - 5, obj_particle);
            piece.sprite_index = arg0;
            piece.yy_spd = random_range(-5, -2);
            piece.direction = random_range(0, 360);
            piece.spd = random_range(0.3, 1.5);
            piece.image_index = choose(0, 1, 2, 3);
            piece.spin_spd = choose(-4, -3, -2, -1, 1, 2, 3, 4);
            piece.image_angle = random_range(0, 360);
            piece.yy = random_range(-1, -3);
            piece.bounce = true;
            piece.shadow = true;
            piece.fall_speed = fall_speed_default;
            piece.sound_to_play = arg3;
        }
    }
}
