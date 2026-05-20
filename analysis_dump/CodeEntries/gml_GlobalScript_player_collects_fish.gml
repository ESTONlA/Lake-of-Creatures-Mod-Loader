function player_collects_fish()
{
    show_debug_message("AAAAAAAAAAAAA");
    global.room_leave_cooldown = 45;
    obj_player.xscale_ext = -0.5;
    obj_player.yscale_ext = 0.5;
    screenshake(3);
    animation = instance_create_depth(x, y, obj_player.depth - 1, obj_animation);
    animation.sprite_index = spr_fish_caught_animation;
    animation.image_speed = 0.6;
    animation.image_xscale = 1.5;
    animation.image_yscale = 1.5;
    animation.target_xscale = 1;
    animation.target_yscale = 1;
    obj_player.sprite_index = obj_player.happy_sprite_index;
    obj_player.image_index = 0;
    obj_player.image_speed = 0;
    obj_player.alarm[0] = 45;
    global.caught_fish_total += 1;
    global.total_fish_caught_this_area += 1;
    show_debug_message("BBBBBBBBBBBBBBBBBB");
    if (global.fish_caught_this_run == 0)
    {
        global.fish_caught_tutorial_all_time += 1;
        global.fish_caught_this_run = 1;
    }
    show_debug_message("CCCCCCCCCCCCCCCCC");
    if (my_name != "fish")
    {
        show_debug_message("CCCCCCCCCCCCCCCCC     - 1");
        achievement_get("FISH_FIRST");
    }
    show_debug_message("CCCCCCCCCCCCCCCCC2222222");
    task_add(7);
    task_add(8);
    show_debug_message("DDDDDDDDDDDDDDDDDDD");
    if (instance_exists(obj_player))
    {
        obj_player.hold_fish = true;
        obj_player.hold_fish_index = fish_index;
        obj_player.hold_fish_id = fish_id2;
        obj_player.alarm[8] = 180;
        obj_player.sprite_index = obj_player.happy_sprite_index;
        obj_player.image_index = 0;
        obj_player.image_speed = 0;
        obj_player.alarm[0] = 45;
        obj_player.hold_fish_yy = 6;
    }
    show_debug_message("EEEEEEEEEEEEEEEEE");
    if (instance_exists(obj_fish_displayer))
    {
        instance_destroy(obj_fish_displayer);
    }
    show_debug_message("FFFFFFFFFFFFFFFFFFFFF");
    global.fishes_caught[fish_index][0] += 1;
    if (fish_original_value > global.fishes_caught[fish_index][1])
    {
        global.fishes_caught[fish_index][1] = fish_original_value;
    }
    show_debug_message("GGGGGGGGGGGGGGGGG");
    if (instance_exists(obj_player))
    {
        get_fish_reward(fish_index);
    }
    show_debug_message("HHHHHHHHHHHHHHHHHHHH");
    var fish_displayer = instance_create_depth(x, y, obj_player.depth - 5, obj_fish_displayer);
    fish_displayer.fish_worth = this_fish_worth;
    fish_displayer.fish_rarity = this_fish_rarity;
    fish_displayer.fish_name = string_upper(my_name);
    fish_displayer.fish_caught_previously = global.fish_that_have_been_caught[fish_id2];
    show_debug_message("IIIIIIIIIIIIIIIIIII");
    switch (this_fish_rarity)
    {
        case 1:
            achievement_get("FISH_UNCOMMON");
            break;
        case 2:
            achievement_get("FISH_RARE");
            break;
        case 3:
            achievement_get("FISH_SUPER_RARE");
            newspaper_enable(14);
            break;
    }
    show_debug_message("JJJJJJJJJJJ");
    play_sound(100);
    show_debug_message("KKKKKKKKKKKKKKKKK");
    if (fish_id2 != 0)
    {
        if (global.fish_that_have_been_caught[fish_id2] == 0)
        {
            global.fish_that_have_been_caught[fish_id2] = 1;
        }
    }
    else if (global.current_tutorial_arrow == 15)
    {
        global.current_tutorial_arrow = 16;
    }
    show_debug_message("LLLLLLLLLLLLLLLL");
    global.fish_caught_this_room += 1;
    var coins_left_to_spawn = this_fish_worth;
    if (global.playable_characters_selected != 2)
    {
        while (coins_left_to_spawn > 0)
        {
            if (coins_left_to_spawn >= 10)
            {
                drop_item("COIN_GOLD", x, y);
                coins_left_to_spawn -= 10;
            }
            else
            {
                drop_item("COIN_SILVER", x, y);
                coins_left_to_spawn -= 1;
            }
        }
    }
    else
    {
        global.raikku_fish_cost_total += coins_left_to_spawn;
        global.raikku_fish_in_backpack += 1;
    }
    global.fish_caught_value_this_run += this_fish_worth;
    if (global.fish_caught_value_this_run >= 1000)
    {
        achievement_get("FISH_500WORTH");
    }
    if (this_fish_worth >= 50)
    {
        achievement_get("FISH_1KG");
    }
    if (this_fish_worth >= 100)
    {
        achievement_get("FISH_5KG");
    }
    if (this_fish_worth >= 200)
    {
        achievement_get("FISH_10KG");
    }
    global.fish_array_this_room_img_index[global.fish_caught_this_room - 1] = image_index;
    global.fish_array_this_room_value[global.fish_caught_this_room - 1] = this_fish_worth;
    global.fish_array_this_room_scale[global.fish_caught_this_room - 1] = 0.6;
    switch (sprite_index)
    {
        case spr_fish_00:
            var spr_index = spr_fish_00_hud;
            break;
        case spr_fish_01:
            var spr_index = spr_fish_01_hud;
            break;
    }
    update_challenge_progression("fish");
    if (global.item_fish_cracker == true)
    {
        global.weapon_temporary_damage_multiplier += 0.02;
    }
    if (global.item_catch_hp_regen == true)
    {
        if (floor(random(20)) == 0)
        {
            if (global.player_hp < global.player_hp_max)
            {
                global.player_hp += 1;
                item_effect_animation(53);
            }
        }
    }
    instance_destroy();
}
