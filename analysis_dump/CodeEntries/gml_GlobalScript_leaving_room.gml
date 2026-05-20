function leaving_room()
{
    global.ammo_spent_in_room = false;
    play_sound(49);
    if (instance_exists(obj_item_pickup))
    {
        with (obj_item_pickup)
        {
            if (persist == false)
            {
                var animation = instance_create_depth(x, y, depth - 5, obj_animation);
                animation.sprite_index = spr_poof;
                animation.image_speed = random_range(0.7, 0.9);
                animation.image_angle = random_range(0, 360);
                animation.xscale_ext = 1.2;
                animation.yscale_ext = 1.2;
                play_sound(39);
                instance_destroy();
            }
        }
    }
    if (instance_exists(obj_pickup_item_pickup))
    {
        with (obj_pickup_item_pickup)
        {
            if (persist == false)
            {
                var animation = instance_create_depth(x, y, depth - 5, obj_animation);
                animation.sprite_index = spr_poof;
                animation.image_speed = random_range(0.7, 0.9);
                animation.image_angle = random_range(0, 360);
                animation.xscale_ext = 1.2;
                animation.yscale_ext = 1.2;
                play_sound(39);
                instance_destroy();
            }
        }
    }
    if (instance_exists(obj_shop_sign))
    {
        with (obj_shop_sign)
        {
            if (persist == false)
            {
                instance_destroy();
            }
        }
    }
    if (instance_exists(obj_ammo_crate))
    {
        with (obj_ammo_crate)
        {
            var animation = instance_create_depth(x, y, depth - 5, obj_animation);
            animation.sprite_index = spr_poof;
            animation.image_speed = random_range(0.7, 0.9);
            animation.image_angle = random_range(0, 360);
            animation.xscale_ext = 1.2;
            animation.yscale_ext = 1.2;
            play_sound(39);
            instance_destroy();
        }
    }
    if (instance_exists(obj_cricket))
    {
        with (obj_cricket)
        {
            if (sprite_index != spr_cricket_gold)
            {
                var animation = instance_create_depth(x, (y - 10) + yy, depth - 5, obj_animation);
                animation.sprite_index = spr_poof;
                animation.image_speed = random_range(0.7, 0.9);
                animation.image_angle = random_range(0, 360);
                animation.xscale_ext = 1;
                animation.yscale_ext = 1;
                play_sound(39);
                instance_destroy();
            }
        }
    }
    if (instance_exists(obj_fish_underwater))
    {
        with (obj_fish_underwater)
        {
            var obj = instance_create_depth(200, 200, -1000, obj_fish_consumer);
            obj.time_until_despawn = time_until_despawn;
            obj.fish_id = fish_id;
            obj.room_id = global.current_world_block_id;
        }
    }
    if (instance_exists(obj_secret_room_setter))
    {
        if (obj_secret_room_setter.ready == false)
        {
            instance_destroy(obj_secret_room_setter);
        }
    }
    if (global.item_sad_heart == true)
    {
        if (instance_exists(obj_weapon_pickup))
        {
            with (obj_weapon_pickup)
            {
                drop_item("HP", x, y);
                var animation = instance_create_depth(x, y, depth - 5, obj_animation);
                animation.sprite_index = spr_poof;
                animation.image_speed = 1;
                animation.image_angle = random_range(0, 360);
                animation.xscale_ext = 1.2;
                animation.yscale_ext = 1.2;
                play_sound(39);
                instance_destroy();
            }
        }
    }
    global.weapon_temporary_damage_multiplier_room = 1;
}
