function player_hurt_effect(arg0)
{
    var result = true;
    switch (arg0)
    {
        case 1:
            var is_destroyed = choose(0, 1);
            if (is_destroyed == 0)
            {
                result = false;
            }
            break;
        case 2:
            drop_item("ITEM", obj_player.x, obj_player.y);
            break;
        case 3:
            play_sound(29);
            for (var i = 0; i < 8; i += 1)
            {
                var shoot_dir = i * 45;
                xscale_ext = -0.4;
                yscale_ext = 0.4;
                b = instance_create_depth(x + lengthdir_x(1, shoot_dir), y + lengthdir_y(1, shoot_dir), -1, obj_bullet);
                b.sprite_index = spr_bullet_player;
                b.image_angle = shoot_dir;
                b.direction = b.image_angle;
                b.image_xscale = random_range(1, 1.2);
                b.image_yscale = b.image_xscale;
                b.my_speed = 2;
                b.player_bullet = true;
                b.my_range = 360;
                b.player_bullet_not_from_player = true;
            }
            break;
        case 4:
            var coin_reward_amount = 20;
            for (var i = 0; i < coin_reward_amount; i += 1)
            {
                if (floor(random(6)) == 0)
                {
                    drop_item("COIN", x, y);
                }
                else
                {
                    drop_item("COIN_SILVER", x, y);
                }
            }
            break;
    }
    return result;
}
