function bullet_premature_destroy()
{
    if (oth.image_index == 0)
    {
        if (oth.player_bullet == true && oth.bomb_bullet == false && oth.scatter_bullet_child == false)
        {
            if (oth.deflected_bullet == false)
            {
                if (instance_exists(obj_player))
                {
                    with (obj_player)
                    {
                        weapon_knockback_offset = global.weapon_knockback_dis;
                        boat_knockback = global.weapon_knockback_boat;
                        boat_knockback_dir = mouse_direction + random_range(-5, 5);
                        if (other.oth.first_shot == true)
                        {
                            for (i = 0; i < global.shells_to_spawn; i += 1)
                            {
                                shell = instance_create_depth(x + lengthdir_x(weapon_offset_length + weapon_knockback_offset, mouse_direction), (y - 10) + lengthdir_y(weapon_offset_length + weapon_knockback_offset, mouse_direction), -50, obj_bullet_shell);
                                shell.sprite_index = global.shell_sprite_to_spawn;
                                shell.direction = (mouse_direction - 180) + random_range(-15, 15);
                                shell.spd = global.weapon_shell_speed + random_range(0, 3) + random_range(-0.2, 0.2);
                                shell.fall_spd = -4 + random_range(-1, 1);
                            }
                        }
                        global.shells_to_spawn = 0;
                        screenshake(10);
                    }
                }
            }
        }
    }
}
