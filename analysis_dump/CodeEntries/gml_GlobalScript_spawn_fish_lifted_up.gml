function spawn_fish_lifted_up(arg0, arg1, arg2)
{
    hook_lifted();
    play_sound(55);
    play_sound(61);
    var fish_sprite = spr_fish;
    switch (arg0.sprite_index)
    {
        case spr_fish_00_underwater:
            fish_sprite = spr_fish_00;
            break;
        case spr_fish_01_underwater:
            fish_sprite = spr_fish_01;
            break;
    }
    var fish_original_value = get_fish_cost(arg0.rarity_level);
    var fish_final_worth = get_fish_additional_worth(fish_original_value);
    var fish = instance_create_layer(arg1, arg2, "Instances", obj_fish_caught);
    fish.sprite_index = arg0.fish_sprite;
    fish.fish_sprite = arg0.fish_sprite;
    fish.fish_index = arg0.fish_index;
    fish.image_index = arg0.image_index;
    fish.this_fish_worth = fish_final_worth;
    fish.this_fish_rarity = arg0.rarity_level;
    fish.fish_original_value = fish_original_value;
    fish.fish_id2 = arg0.fish_id2;
    fish.my_name = arg0.my_name;
    yank_animation(130);
    if (instance_exists(obj_fish_on_displayer))
    {
        instance_destroy(obj_fish_on_displayer);
    }
    if (instance_exists(obj_rope))
    {
        obj_rope.float_xscale_ext = 0.7;
        obj_rope.float_yscale_ext = 0.7;
    }
    animation = instance_create_layer(x, y, "Instances", obj_animation);
    animation.sprite_index = spr_splash_2;
    animation.my_color = global.current_color_water_light;
    if (instance_exists(obj_fish_underwater))
    {
        with (obj_fish_underwater)
        {
            if (caught == true)
            {
                shrink_out = true;
            }
        }
    }
    if (fish_on == true)
    {
        if (global.hotspot_visited == true)
        {
            if (instance_exists(obj_hotspot))
            {
                hotspot = instance_nearest(phy_position_x, phy_position_y, obj_hotspot);
                hotspot.my_fishes_left -= 1;
            }
        }
    }
    fish_on_underwater_amount = 0;
    global.hotspot_visited = false;
    instance_destroy();
}
