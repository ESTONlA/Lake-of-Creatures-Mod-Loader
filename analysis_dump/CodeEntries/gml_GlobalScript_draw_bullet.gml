function draw_bullet()
{
    if (sprite_index != spr_flame)
    {
        var bullet_size_multiplier = 1;
        if (player_bullet == true)
        {
            bullet_size_multiplier = bullet_size;
        }
        else
        {
            bullet_size_multiplier = 0.8;
            if (bullet_owner != -4)
            {
                if (instance_exists(bullet_owner))
                {
                    if (bullet_owner.is_boss == true)
                    {
                        bullet_size_multiplier = 1.1;
                    }
                }
            }
            if (from_boss == true)
            {
                bullet_size_multiplier = 1.1;
            }
        }
        bullet_size_final = (((img_xscale + xscale_ext) * 0.5) + (dmg * 0.4)) * bullet_size_multiplier;
        if (bullet_size_final > 8)
        {
            bullet_size_final = 8;
        }
        bullet_angle += bullet_spin_spd;
        var draw_direction = image_angle - 180;
        var draw_angle = (image_angle - 180) + bullet_angle;
        var update_frequency = 1.5;
        var times_drawn = floor(bullet_trail * spd);
        var core_times_drawn = times_drawn * (core_fill / 100);
        var flash = image_index;
        if (image_index == 0)
        {
            flash = true;
        }
        else
        {
            flash = false;
        }
        if (player_bullet == true)
        {
            if (instance_number(obj_bullet) > 50)
            {
                update_frequency = 6;
            }
            if (instance_number(obj_bullet) > 100)
            {
                update_frequency = 12;
            }
        }
        var bullet_draw_color = bullet_color;
        var core_draw_color = core_color;
        var glow_size = 13 + (core_type_modifier_1 * 0.9) + (flash * 1.6);
        if (flash == true)
        {
            bullet_draw_color = 16777215;
            core_draw_color = 16777215;
            times_drawn = 1;
        }
        if (times_drawn < 1)
        {
            times_drawn = 1;
            core_times_drawn = 1;
            update_frequency = 1;
        }
        if (times_drawn <= 3 && flash == false)
        {
            times_drawn = 3;
        }
        if (core_times_drawn < 1)
        {
            core_times_drawn = 1;
        }
        for (var i = 0; i < times_drawn; i += update_frequency)
        {
            draw_x = x + lengthdir_x(i, draw_direction);
            draw_y = y + yy + lengthdir_y(i, draw_direction);
            draw_size = (bullet_size_final * 0.1) + (flash * 0.05);
            draw_set_color(bullet_draw_color);
            draw_sprite_ext(spr_bullet_shape, shape_index, draw_x, draw_y, draw_size, draw_size, draw_angle, bullet_draw_color, 1);
            switch (core_type)
            {
                case 1:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 2:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 3:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle - 90), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1 * 0.6, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1 * 0.6, core_angle - 270), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 4:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 5:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 6:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 90), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 270), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 7:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 8:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 9:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 90), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 270), draw_size, draw_size, draw_angle, bullet_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
            }
        }
        for (var i = 0; i < core_times_drawn; i += update_frequency)
        {
            draw_x = x + lengthdir_x(i, draw_direction);
            draw_y = y + yy + lengthdir_y(i, draw_direction);
            var my_draw_size = bullet_size_final * (core_size / 100) * 0.1;
            draw_size = my_draw_size;
            if (core_pulse != 0)
            {
                draw_size = wave_effect(my_draw_size * 0.2, my_draw_size, core_pulse, 0);
            }
            draw_set_color(core_draw_color);
            draw_sprite_ext(spr_bullet_shape, shape_index, draw_x, draw_y, draw_size, draw_size, draw_angle, core_draw_color, 1);
            switch (core_type)
            {
                case 1:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 2:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 3:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 90), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 270), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 4:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 5:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 6:
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 90), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 270), draw_size, draw_size, draw_angle, core_draw_color, 1);
                    if (i == 0)
                    {
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 7:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 8:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
                case 9:
                    if (i == 0)
                    {
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle), draw_y + lengthdir_y(core_type_modifier_1, core_angle), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 90), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 90), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 180), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 180), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        draw_sprite_ext(spr_bullet_shape, shape_index, draw_x + lengthdir_x(core_type_modifier_1, core_angle - 270), draw_y + lengthdir_y(core_type_modifier_1, core_angle - 270), draw_size, draw_size, draw_angle, core_draw_color, 1);
                        core_angle += core_type_modifier_2;
                    }
                    break;
            }
        }
    }
}
