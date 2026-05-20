function player_hurt_2(arg0)
{
    if (can_get_hurt == true)
    {
        sprite_index = hurt_sprite_index;
        image_index = 0;
        image_speed = 0.4;
        xscale_ext = -0.3;
        yscale_ext = 0.3;
        can_get_hurt = false;
        alarm[2] = 120;
        freeze_frame(50);
        screenshake(5);
        if (arg0 != 0)
        {
            play_sound(86);
            global.damage_taken_amount += 1;
            if (is_night() == true)
            {
                global.night_cancelled = true;
                arg0 = 0;
            }
            if (arg0 == 0)
            {
                exit;
            }
            if (global.challenge_run_selected == 7)
            {
                var dmg_cost = 50;
                global.player_money -= dmg_cost;
                get_money_spent_hud(dmg_cost, 0);
            }
            global.enemy_kills_in_row = 0;
            for (var i = 0; i < arg0; i += 1)
            {
                task_add(50);
                task_add(51);
            }
            if (global.item_bursting_heart == true)
            {
                var total_bullets = global.bullets_shot_at_once * 5;
                for (var i = 0; i < total_bullets; i += 1)
                {
                    var b = copy_bullet_2(obj_player.x, obj_player.y);
                    if (b != -4)
                    {
                        b.sprite_index = spr_bullet_bubble_player;
                        b.yy = -3;
                        b.yy_spd = -3;
                        b.lob_shot = true;
                        b.my_speed = b.my_speed * 0.7;
                        b.image_angle = random_range(0, 360);
                        b.direction = b.image_angle;
                    }
                }
            }
            if (global.item_sea_tumor == true)
            {
                if (instance_exists(obj_item_sea_tumor))
                {
                    with (obj_item_sea_tumor)
                    {
                        for (var i = 0; i < (global.item_sea_tumor_level + 1); i += 1)
                        {
                            instance_create_layer(x + random_range(-4, 4), y + random_range(-4, 4), "Instances", obj_item_sea_tumor_invidual);
                        }
                        instance_destroy();
                    }
                    global.item_sea_tumor_level = 0;
                }
            }
        }
        for (var ii = 0; ii < arg0; ii += 1)
        {
            var has_extra_hp = false;
            for (var i = 9; i >= 0; i -= 1)
            {
                if (has_extra_hp == false)
                {
                    if (global.player_hp_extra[i] != 0)
                    {
                        var hp_type = global.player_hp_extra[i] - 1;
                        var destroy_hp = player_hurt_effect(hp_type);
                        if (destroy_hp == true)
                        {
                            global.player_hp_extra[i] = 0;
                            var animation = instance_create_depth(0, 0, -50, obj_animation);
                            animation.depth = -998;
                            animation.sprite_index = spr_hud_hp;
                            animation.image_index = 2;
                            animation.image_speed = 0;
                            animation.image_xscale = 0.1;
                            animation.image_yscale = 1.9;
                            animation.fadeout = true;
                            animation.pin_to_view = true;
                            animation.pin_x = 17 + (i * 16);
                            animation.pin_y = 13;
                            animation = instance_create_depth(0, 0, -50, obj_animation);
                            animation.depth = -999;
                            animation.sprite_index = spr_hud_hp_white;
                            animation.image_index = 2;
                            animation.image_speed = 0;
                            animation.image_xscale = 0.1;
                            animation.image_yscale = 1.9;
                            animation.fadeout = true;
                            animation.fadeout_speed = 0.2;
                            animation.pin_to_view = true;
                            animation.pin_x = 17 + (i * 16);
                            animation.pin_y = 13;
                        }
                        has_extra_hp = true;
                    }
                }
            }
            if (has_extra_hp == false)
            {
                global.player_hp -= 1;
                if (global.player_hp > 0)
                {
                    obj_ctrl.hud_hp_xscale[floor(global.player_hp)] = -0.9;
                    obj_ctrl.hud_hp_yscale[floor(global.player_hp)] = 0.9;
                    obj_ctrl.hud_hp_white[floor(global.player_hp)] = 1.9;
                }
            }
            global.damage_taken_this_room += 1;
        }
        adjust_extra_hp();
        if (arg0 > 0)
        {
            if (global.item_love_wand == true && instance_exists(obj_player))
            {
                if (floor(random(20)) == 0)
                {
                    drop_item("KEY", obj_player.x, obj_player.y);
                    item_effect_animation(116);
                }
            }
            if (global.item_dull_knife == true && instance_exists(obj_player))
            {
                if (floor(random(20)) == 0)
                {
                    item_effect_animation(117);
                    drop_item("WEAPON", obj_player.x, obj_player.y);
                }
            }
            if (global.item_potato == true && instance_exists(obj_player))
            {
                if (floor(random(20)) == 0)
                {
                    var reward = choose(1, 2);
                    if (reward == 1)
                    {
                        drop_item("HP", obj_player.x, obj_player.y);
                    }
                    else
                    {
                        drop_item("HP_EXTRA", obj_player.x, obj_player.y);
                    }
                    item_effect_animation(118);
                }
            }
        }
    }
}
