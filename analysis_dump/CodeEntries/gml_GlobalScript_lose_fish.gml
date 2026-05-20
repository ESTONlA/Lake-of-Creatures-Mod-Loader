function lose_fish(arg0)
{
    if (instance_exists(obj_rope))
    {
        obj_rope.float_xscale_ext = 0.7;
        obj_rope.float_yscale_ext = 0.7;
    }
    if (arg0.damage_player_if_lost == true)
    {
        var fish_flying = instance_create_depth(x, y, -y, obj_fish_flying);
        fish_flying.sprite_index = arg0.fish_sprite;
    }
    screenshake(2);
    instance_destroy(arg0);
    hook_lifted();
    instance_destroy();
    if (instance_exists(obj_rope))
    {
        obj_rope.float_xscale_ext = 0.7;
        obj_rope.float_yscale_ext = 0.7;
    }
    animation = instance_create_layer(x, y, "Instances", obj_animation);
    animation.sprite_index = spr_splash_1;
    animation.my_color = global.current_color_water_light;
}
