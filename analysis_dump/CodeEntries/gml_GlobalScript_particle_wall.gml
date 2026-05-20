function particle_wall(arg0, arg1, arg2, arg3, arg4)
{
    if (global.particles_enabled == true)
    {
        var speed_mod = oth.spd / oth.my_speed;
        var blood_amount = floor(random_range(arg0, arg1));
        var col = 4542312;
        for (i = 0; i <= blood_amount; i += 1)
        {
            blood = instance_create_depth(arg2 + random_range(-7, 7), arg3 + random_range(-7, 7), depth - 5, obj_particle);
            blood.sprite_index = spr_blood;
            blood.yy_spd = random_range(-5, -2) * speed_mod;
            blood.direction = random_range(0, 360);
            blood.spd = random_range(0.3, 1.5) * speed_mod;
            blood.image_index = choose(0, 1, 2);
            blood.yy = random_range(-1, -3);
            blood.my_color = col;
        }
    }
}
