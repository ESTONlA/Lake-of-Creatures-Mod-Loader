function item_effect_animation(arg0)
{
    play_sound(102);
    if (instance_exists(obj_player))
    {
        var effect = instance_create_depth(obj_player.x, obj_player.y, -980, obj_animation);
        effect.sprite_index = spr_item;
        effect.image_speed = 0;
        effect.yy_target = -34;
        effect.pinned_id = obj_player;
        effect.pinned = true;
        effect.spin_spd = 0;
        effect.image_index = arg0;
        effect.image_xscale = 1.2;
        effect.image_yscale = 0.8;
        effect.alarm[2] = 150;
        animation = instance_create_depth(obj_player.x, obj_player.y, 0, obj_animation);
        animation.sprite_index = spr_weapon_pickup_flash;
        animation.pinned = true;
        animation.pinned_id = obj_player;
        animation.depth = obj_player.depth - 1;
        animation.image_xscale = 1.1;
        animation.image_yscale = 1.1;
        animation.image_speed = 0.7;
        animation.target_xscale = 0.7;
        animation.target_yscale = 0.7;
    }
    else
    {
        var effect = instance_create_depth(room_width / 2, room_height / 2, -980, obj_animation);
        effect.sprite_index = spr_item;
        effect.image_speed = 0;
        effect.yy_target = -34;
        effect.pinned = false;
        effect.spin_spd = 0;
        effect.image_index = arg0;
        effect.image_xscale = 1.2;
        effect.image_yscale = 0.8;
        effect.alarm[2] = 150;
    }
    adjust_extra_hp();
}
