function enemy_splatter_blood(arg0, arg1, arg2, arg3)
{
    if (global.particles_enabled == true)
    {
        var blood_amount = floor(random_range(arg0, arg1));
        var col = 2165729;
        var spawn_range = 7;
        var fall_speed_default = 0.1;
        blood_amount = floor(random_range(7, 10));
        for (i = 0; i <= blood_amount; i += 1)
        {
            var piece = instance_create_depth(arg2 + random_range(-spawn_range, spawn_range), arg3 + random_range(-spawn_range, spawn_range), depth - 5, obj_particle);
            piece.sprite_index = spr_blood_2;
            piece.yy_spd = random_range(-5, -2);
            piece.direction = random_range(0, 360);
            piece.spd = random_range(0.3, 1.5);
            piece.image_index = choose(0, 1, 2, 3, 4, 5, 6);
            piece.spin_spd = choose(-4, -3, -2, -1, 1, 2, 3, 4);
            piece.image_angle = random_range(0, 360);
            piece.yy = yy - random_range(1, 3);
            piece.bounce = true;
            piece.shadow = true;
            piece.fall_speed = fall_speed_default;
        }
    }
}
