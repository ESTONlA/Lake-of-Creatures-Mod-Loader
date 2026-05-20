function lake_start()
{
    if (global.current_lake == 1)
    {
        shopkeeper_chance_reset();
        task_reset_all_row();
    }
    else
    {
        shopkeeper_chance_increase();
        play_music(2);
        play_music(17);
        var coin_drop_multiplier = 0;
        var coin_drop_amount = 0;
        for (var i = 0; i < 10; i += 1)
        {
            if (global.player_hp_extra[i] == 6)
            {
                coin_drop_multiplier += 0.2;
            }
        }
        coin_drop_amount = floor(global.player_money * coin_drop_multiplier);
        global.player_coin_drop_amount_when_lake_starts = coin_drop_amount;
        if (global.damage_taken_this_lake == 0)
        {
            task_add(27);
            task_add(28);
            task_add(29);
        }
        else
        {
            task_reset(29);
        }
    }
    global.area_transition_animation = false;
    global.area_transition_cutscene_ended = false;
    global.area_transition_cutscene_active = false;
    global.cutscene_played = false;
    birgit_reset_wand_hits();
    if (global.difficulty_selection == 0)
    {
        if (global.current_lake <= 4)
        {
            global.difficulty_mod_enemy_shot_speed = 0.75;
        }
        else
        {
            global.difficulty_mod_enemy_shot_speed = 0.825;
        }
    }
    global.total_money_spent_this_lake = 0;
    global.night_cancelled = false;
    global.boss_battle = false;
    global.boss_current_hp = 0;
    global.boost_speed_multiplier_saved = 0;
    global.player_h_spd_saved = 0;
    global.player_v_spd_saved = 0;
    instance_create_depth(0, 0, -998, obj_area_displayer);
    global.gold_crickets_held = 0;
    global.gold_crickets_given = 0;
    global.boss_beaten = 0;
    global.in_boss_room = false;
    global.damage_taken_this_lake = 0;
    global.line_kill_key_drop = true;
    if (get_lake_type(global.current_lake) == 4)
    {
        global.area4_visited = true;
        achievement_get("AREA4_ENTER");
    }
    global.weapon_temporary_damage_multiplier = 1;
    global.enemy_temporary_hp_multiplier = 1;
    if (instance_exists(obj_fish_consumer))
    {
        instance_destroy(obj_fish_consumer);
    }
    if (instance_exists(obj_pink_lock_swapper))
    {
        instance_destroy(obj_pink_lock_swapper);
    }
    if (instance_exists(obj_key_swapper_ctrl))
    {
        instance_destroy(obj_key_swapper_ctrl);
    }
    if (instance_exists(obj_pickup_swapper_ctrl))
    {
        instance_destroy(obj_pickup_swapper_ctrl);
    }
    if (instance_exists(obj_item_swapper_ctrl))
    {
        instance_destroy(obj_item_swapper_ctrl);
    }
    for (var i = 0; i < 5; i += 1)
    {
        global.event_icon[i] = -4;
    }
    global.night_key_dropped = false;
    global.night_key_drop_chance = 3;
    if (instance_exists(obj_skull))
    {
        instance_destroy(obj_skull);
    }
    if (global.item_random_hp_drop == true)
    {
        create_effect_waiter(76);
    }
    if (global.item_regen_at_tent == true)
    {
        create_effect_waiter(4);
    }
    if (global.item_msg_bottle == true)
    {
        global.item_msg_bottle_hp = 5;
    }
    if (global.item_juice_box == true)
    {
        global.item_juice_box_active = 60;
    }
    if (global.item_charm_of_risk == true)
    {
        var effect = choose(1, 2);
        if (effect == 1)
        {
            global.weapon_temporary_damage_multiplier += 0.3;
        }
        else
        {
            global.enemy_temporary_hp_multiplier += 0.5;
        }
    }
    if (global.item_fishing_rewarded_active == true)
    {
        if (instance_exists(obj_player))
        {
            drop_item("ITEM", obj_player.x, obj_player.y);
        }
        global.item_fishing_rewarded_active = false;
    }
    if (global.item_gold_nugget == true)
    {
        global.item_gold_nugget_active = true;
        global.item_gold_nugget_money = 0;
        if (instance_exists(obj_player))
        {
            instance_create_depth(obj_player.x, obj_player.y, 100, obj_item_gold_nugget);
        }
    }
    adjust_extra_hp();
}
