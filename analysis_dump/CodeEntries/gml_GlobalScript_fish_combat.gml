function fish_combat()
{
    switch (fish_type)
    {
        case 0:
            if (floor(random(70)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 60;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    play_sound(26);
                    var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    var b = instance_create_depth(x + lengthdir_x(2, shoot_dir), y + lengthdir_y(2, shoot_dir), -1, obj_bullet);
                    b.sprite_index = spr_bullet;
                    b.image_angle = shoot_dir;
                    b.direction = b.image_angle;
                    b.image_xscale = random_range(1, 1.2);
                    b.image_yscale = b.image_xscale;
                    b.my_speed = random_range(1.8, 2.1);
                    b.my_range = 300;
                    b.dmg_to_deal = dmg_to_deal;
                    b.wall_collisions_enabled = false;
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 180);
                }
                shoot = false;
            }
            break;
        case 1:
            if (floor(random(70)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 80;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    play_sound(26);
                    var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    for (var i = 0; i < 2; i += 1)
                    {
                        var b = instance_create_depth(x + lengthdir_x(2, (shoot_dir - 15) + (i * 30)), y + lengthdir_y(2, (shoot_dir - 15) + (i * 30)), -1, obj_bullet);
                        b.sprite_index = spr_bullet;
                        b.image_angle = (shoot_dir - 15) + (i * 30);
                        b.direction = b.image_angle;
                        b.image_xscale = random_range(1, 1.2);
                        b.image_yscale = b.image_xscale;
                        b.my_speed = random_range(1.8, 2.1);
                        b.my_range = 300;
                        b.dmg_to_deal = dmg_to_deal;
                        b.wall_collisions_enabled = false;
                    }
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 180);
                }
                shoot = false;
            }
            break;
        case 2:
            if (floor(random(70)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 60;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    play_sound(26);
                    var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    var b = instance_create_depth(x + lengthdir_x(2, shoot_dir), y + lengthdir_y(2, shoot_dir), -1, obj_bullet);
                    b.sprite_index = spr_bullet;
                    b.image_angle = shoot_dir;
                    b.direction = b.image_angle;
                    b.image_xscale = random_range(1, 1.2);
                    b.image_yscale = b.image_xscale;
                    b.my_speed = random_range(0.6, 1);
                    b.my_range = 500;
                    b.dmg_to_deal = dmg_to_deal;
                    b.wall_collisions_enabled = false;
                    b.wobble_shot = true;
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 100);
                }
                shoot = false;
            }
            break;
        case 3:
            if (floor(random(120)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 90;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    play_sound(26);
                    for (var i = 0; i < 3; i += 1)
                    {
                        var b = instance_create_depth(x + lengthdir_x(2, (shoot_dir - 25) + (i * 25)), y + lengthdir_y(2, (shoot_dir - 25) + (i * 25)), -1, obj_bullet);
                        b.sprite_index = spr_bullet;
                        b.image_angle = (shoot_dir - 25) + (i * 25);
                        b.direction = b.image_angle;
                        b.image_xscale = random_range(1, 1.2);
                        b.image_yscale = b.image_xscale;
                        b.my_speed = random_range(1.8, 2.1);
                        b.my_range = 300;
                        b.dmg_to_deal = dmg_to_deal;
                        b.wall_collisions_enabled = false;
                    }
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 180);
                }
                shoot = false;
            }
            break;
        case 4:
            if (floor(random(120)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 90;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    var shoot_dir = 45;
                    play_sound(26);
                    for (var i = 0; i < 4; i += 1)
                    {
                        var b = instance_create_depth(x + lengthdir_x(2, shoot_dir + (i * 90)), y + lengthdir_y(2, shoot_dir + (i * 90)), -1, obj_bullet);
                        b.sprite_index = spr_bullet;
                        b.image_angle = shoot_dir + (i * 90);
                        b.direction = b.image_angle;
                        b.image_xscale = random_range(1, 1.2);
                        b.image_yscale = b.image_xscale;
                        b.my_speed = random_range(1.8, 2.1);
                        b.my_range = 300;
                        b.dmg_to_deal = dmg_to_deal;
                        b.wall_collisions_enabled = false;
                    }
                    var random_knockback_dir = random_range(0, 360);
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = random_knockback_dir;
                    direction += smooth_rotation(direction, random_knockback_dir - 180, 140);
                }
                shoot = false;
            }
            break;
        case 5:
            if (floor(random(120)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 90;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    var shoot_dir = 0;
                    play_sound(26);
                    for (var i = 0; i < 4; i += 1)
                    {
                        var b = instance_create_depth(x + lengthdir_x(2, shoot_dir + (i * 90)), y + lengthdir_y(2, shoot_dir + (i * 90)), -1, obj_bullet);
                        b.sprite_index = spr_bullet;
                        b.image_angle = shoot_dir + (i * 90);
                        b.direction = b.image_angle;
                        b.image_xscale = random_range(1, 1.2);
                        b.image_yscale = b.image_xscale;
                        b.my_speed = random_range(1.8, 2.1);
                        b.my_range = 300;
                        b.dmg_to_deal = dmg_to_deal;
                        b.wall_collisions_enabled = false;
                    }
                    var random_knockback_dir = random_range(0, 360);
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = random_knockback_dir;
                    direction += smooth_rotation(direction, random_knockback_dir - 180, 140);
                }
                shoot = false;
            }
            break;
        case 6:
            if (floor(random(200)) == 0 && shot_anticipation <= 0 && shoot == false)
            {
                shot_anticipation = 80;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shooting_left = floor(random_range(10, 20));
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (shooting_left > 0)
                {
                    if (shooting_cooldown <= 0)
                    {
                        if (instance_exists(obj_player))
                        {
                            var shoot_dir = direction + random_range(-7, 7);
                            play_sound(26);
                            var b = instance_create_depth(x + lengthdir_x(2, shoot_dir), y + lengthdir_y(2, shoot_dir), -1, obj_bullet);
                            b.sprite_index = spr_bullet;
                            b.image_angle = shoot_dir;
                            b.direction = b.image_angle;
                            b.image_xscale = random_range(1, 1.2);
                            b.image_yscale = b.image_xscale;
                            b.my_speed = random_range(2.2, 2.7);
                            b.my_range = 300;
                            b.dmg_to_deal = dmg_to_deal;
                            b.wall_collisions_enabled = true;
                            shoot_knockback_spd = 0.5;
                            shoot_knockback_dir = shoot_dir - 180;
                            direction += smooth_rotation(direction, shoot_dir - 180, 80);
                        }
                        shooting_cooldown = 10;
                        shooting_left -= 1;
                    }
                    else
                    {
                        shooting_cooldown -= 1;
                    }
                }
                else
                {
                    shoot = false;
                }
            }
            break;
        case 7:
            if (floor(random(200)) == 0 && shot_anticipation <= 0 && shoot == false)
            {
                shot_anticipation = 100;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shooting_left = floor(random_range(10, 40));
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (shooting_left > 0)
                {
                    if (shooting_cooldown <= 0)
                    {
                        if (instance_exists(obj_player))
                        {
                            var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y) + random_range(-5, 5);
                            play_sound(26);
                            var b = instance_create_depth(x + lengthdir_x(2, shoot_dir), y + lengthdir_y(2, shoot_dir), -1, obj_bullet);
                            b.sprite_index = spr_bullet;
                            b.image_angle = shoot_dir;
                            b.direction = b.image_angle;
                            b.image_xscale = random_range(1, 1.2);
                            b.image_yscale = b.image_xscale;
                            b.my_speed = random_range(2, 2.4);
                            b.my_range = 300;
                            b.dmg_to_deal = dmg_to_deal;
                            b.wall_collisions_enabled = true;
                            shoot_knockback_spd = 0.5;
                            shoot_knockback_dir = shoot_dir - 180;
                            direction += smooth_rotation(direction, shoot_dir - 180, 80);
                        }
                        shooting_cooldown = 12;
                        shooting_left -= 1;
                    }
                    else
                    {
                        shooting_cooldown -= 1;
                    }
                }
                else
                {
                    shoot = false;
                }
            }
            break;
        case 8:
            if (floor(random(150)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 90;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    var shoot_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    play_sound(26);
                    var b = instance_create_depth(x + lengthdir_x(2, shoot_dir), y + lengthdir_y(2, shoot_dir), -1, obj_bullet);
                    b.sprite_index = spr_bullet;
                    b.image_angle = shoot_dir;
                    b.direction = b.image_angle;
                    b.image_xscale = random_range(1, 1.2);
                    b.image_yscale = b.image_xscale;
                    b.my_speed = random_range(0.5, 0.7);
                    b.my_range = 300;
                    b.dmg_to_deal = dmg_to_deal;
                    b.wall_collisions_enabled = true;
                    b.exploding_bullet = true;
                    shoot_knockback_spd = 6;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 110);
                }
                shoot = false;
            }
            break;
        case 9:
            if (floor(random(200)) == 0 && shot_anticipation <= 0)
            {
                shot_anticipation = 90;
                shake_intensivity = 2;
            }
            if (shot_anticipation > 0)
            {
                laser_anticipation_alpha += approach(laser_anticipation_alpha, 1, 0.05);
                shot_anticipation -= 1;
                if (shot_anticipation == 0)
                {
                    shake_intensivity = 0;
                    shoot = true;
                }
            }
            if (shoot == true)
            {
                if (instance_exists(obj_player))
                {
                    laser_anticipation_alpha += approach(laser_anticipation_alpha, 1, 0.05);
                    play_sound(26);
                    var shoot_dir = laser_anticipation_direction;
                    var laser = instance_create_depth(x + lengthdir_x(4, shoot_dir), y + lengthdir_y(4, shoot_dir), -450, obj_laser_static);
                    laser.direction = shoot_dir;
                    laser.pin_id = id;
                    laser.pin = true;
                    laser.continous = false;
                    laser.laser_width = 13;
                    shoot_knockback_spd = 8;
                    shoot_knockback_dir = shoot_dir - 180;
                    direction += smooth_rotation(direction, shoot_dir - 180, 300);
                }
                shoot = false;
            }
            else
            {
                laser_anticipation_alpha += approach(laser_anticipation_alpha, 0, 0.2);
            }
            break;
    }
}
