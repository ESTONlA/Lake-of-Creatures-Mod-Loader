function drop_room_clear_rewards()
{
    if (global.run_ongoing == true)
    {
        var hp_total = global.player_hp;
        for (i = 0; i < 10; i += 1)
        {
            if (global.player_hp_extra[i] != 0)
            {
                hp_total = i;
            }
        }
        if (hp_total == 1)
        {
            task_add(5);
            task_add(6);
        }
        else
        {
            task_reset(6);
        }
        if (global.damage_taken_this_room == 0)
        {
            task_add(18);
            task_add(19);
            task_add(20);
        }
        else
        {
            task_reset(20);
        }
        if (global.gold_cricket_this_room == true && lake_has_boss(global.current_lake) && global.lake_array[global.current_lake].gold_crickets_spawned < 3)
        {
            global.gold_cricket_this_room = false;
            global.lake_array[global.current_lake].gold_crickets_spawned += 1;
        }
        if (global.current_world_block_id.enemies_respawned == false)
        {
            if (floor(random(3)) == 0)
            {
                if (global.damage_taken_this_room == 0)
                {
                    instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_cricket);
                }
            }
            var ammo_crate_chance = 5;
            if (global.difficulty_selection == 0)
            {
                ammo_crate_chance = 3;
            }
            if (floor(random(ammo_crate_chance)) == 0)
            {
            }
            if (floor(random(4 - global.item_fishing_magnet)) == 0)
            {
                var r = choose(0, 1, 1, 1, 2, 2, 2, 5, 5);
                if (global.player_weapon_secondary != -4)
                {
                    if (lake_has_boss(global.current_lake) == true)
                    {
                        r = choose(0, 1, 1, 1, 2, 2, 2, 5, 5);
                    }
                    else
                    {
                        r = choose(0, 1, 1, 1, 2, 2, 2, 4, 4, 5, 5);
                    }
                }
                else
                {
                    r = choose(0, 1, 1, 1, 2, 2, 2, 5, 5, 6, 6, 6, 6, 6, 6);
                }
                if (global.item_fishing_magnet == true)
                {
                    r = choose(0, 1, 2, 4, 5, 6);
                }
                if (global.challenge_run_selected == 1 || global.challenge_run_selected == 7)
                {
                    if (floor(random(5)) == 0)
                    {
                        r = 7;
                    }
                }
                switch (r)
                {
                    case 0:
                        var r2 = choose(0, 1);
                        if (r2 == 0)
                        {
                            drop_item("HP", global.last_enemy_death_x, global.last_enemy_death_y);
                        }
                        else
                        {
                            drop_item("HP_EXTRA", global.last_enemy_death_x, global.last_enemy_death_y);
                        }
                        break;
                    case 1:
                        drop_item("KEY", global.last_enemy_death_x, global.last_enemy_death_y);
                        break;
                    case 2:
                        var reward = instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_chest);
                        reward.direction = random_range(0, 359);
                        reward.spd = 2;
                        reward.xscale_ext = 0.2;
                        reward.yscale_ext = -0.2;
                        break;
                    case 3:
                        machine = instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_machine);
                        machine.image_index = choose(1, 2);
                        machine.xscale_ext = 0.2;
                        machine.yscale_ext = -0.2;
                        break;
                    case 4:
                        var reward = instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_ammo_crate);
                        reward.natural_spawn = 0;
                        reward.direction = random_range(0, 359);
                        reward.spd = 2;
                        break;
                    case 5:
                        var reward = instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_chest);
                        reward.direction = random_range(0, 359);
                        reward.spd = 2;
                        reward.xscale_ext = 0.2;
                        reward.yscale_ext = -0.2;
                        reward.sprite_index = choose(spr_chest_regular, spr_chest_hp, spr_chest_purple, spr_chest_moon, spr_chest_weapon, spr_chest_golden);
                        break;
                    case 6:
                        drop_item("WEAPON", global.last_enemy_death_x, global.last_enemy_death_y);
                        break;
                    case 7:
                        var reward = instance_create_depth(global.last_enemy_death_x, global.last_enemy_death_y, 0, obj_chest);
                        reward.direction = random_range(0, 359);
                        reward.spd = 2;
                        reward.xscale_ext = 0.2;
                        reward.yscale_ext = -0.2;
                        reward.sprite_index = choose(spr_chest_money);
                        break;
                }
            }
            else if (floor(random(2)) == 1)
            {
                drop_item("COIN", global.last_enemy_death_x, global.last_enemy_death_y);
            }
            if (global.item_more_hp_drops == true)
            {
                if (floor(random(5)) == 0)
                {
                    var reward = choose(0, 0, 1);
                    if (reward == 0)
                    {
                        drop_item("HP", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                    else
                    {
                        drop_item("HP_EXTRA", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                }
            }
            if (global.item_bloody_water == true)
            {
                if (floor(random(5)) == 0)
                {
                    var reward = choose(0, 0, 1);
                    if (reward == 0)
                    {
                        drop_item("HP", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                    else
                    {
                        drop_item("HP_EXTRA", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                }
            }
            if (global.item_bloody_water == true)
            {
                if (floor(random(5)) == 0)
                {
                    var reward = choose(0, 0, 1);
                    if (reward == 0)
                    {
                        drop_item("HP", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                    else
                    {
                        drop_item("HP_EXTRA", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                }
            }
            if (global.item_odd_spell == true)
            {
                if (floor(random(8)) == 0)
                {
                    drop_item("WEAPON", global.last_enemy_death_x, global.last_enemy_death_y);
                }
            }
            if (global.item_courage_amulet == true)
            {
                if (global.player_hp <= 1)
                {
                    if (floor(random(2)) == 0)
                    {
                        drop_item("HP", global.last_enemy_death_x, global.last_enemy_death_y);
                    }
                }
            }
            if (global.item_corrosion == true)
            {
                if (floor(random(7)) == 0)
                {
                    drop_item("KEY", global.last_enemy_death_x, global.last_enemy_death_y);
                }
            }
            if (global.item_gold_nugget == true && global.item_gold_nugget_active == true)
            {
                global.item_gold_nugget_money = floor(global.item_gold_nugget_money);
                global.item_gold_nugget_money += 1;
            }
            task_reset(77);
        }
        else
        {
            task_add(75);
            task_add(76);
            task_add(77);
            if (global.night_key_dropped == false)
            {
                if (global.night_key_drop_chance > 1)
                {
                    if (floor(random(global.night_key_drop_chance)) == 0)
                    {
                        drop_item("KEY", global.last_enemy_death_x, global.last_enemy_death_y);
                        global.night_key_dropped = true;
                    }
                    global.night_key_drop_chance -= 1;
                }
                else
                {
                    drop_item("KEY", global.last_enemy_death_x, global.last_enemy_death_y);
                    global.night_key_dropped = true;
                }
            }
        }
    }
}
