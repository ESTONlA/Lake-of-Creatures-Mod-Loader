function copy_bullet(arg0, arg1)
{
    if (instance_exists(id) && sprite_index != spr_melee_attack)
    {
        var bullet_object_name = object_get_name(id.object_index);
        var bullet_object_asset = asset_get_index(bullet_object_name);
        b = instance_create_depth(arg0, arg1, -1, bullet_object_asset);
        b.image_angle = direction;
        b.direction = b.image_angle;
        b.player_bullet = true;
        b.player_bullet_not_from_player = true;
        b.my_speed = spd;
        b.my_spd_decrease = my_spd_decrease;
        b.dmg = dmg;
        b.wall_collisions_enabled = wall_collisions_enabled;
        b.yy = yy;
        b.image_speed = image_speed;
        b.image_index = image_index;
        b.sprite_index = sprite_index;
        b.image_xscale = image_xscale;
        b.image_yscale = image_yscale;
        b.img_xscale = img_xscale;
        b.img_yscale = img_yscale;
        b.my_range = my_range;
        return b;
    }
    else
    {
        return -4;
    }
}
