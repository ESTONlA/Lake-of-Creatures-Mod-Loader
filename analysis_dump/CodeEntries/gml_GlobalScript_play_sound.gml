function play_sound(arg0, arg1 = -4)
{
    var snd_time = 0;
    var sounds_on = true;
    if (global.volume_sound_final <= 0)
    {
        sounds_on = false;
    }
    if (sounds_on == true)
    {
        switch (arg0)
        {
            case 0:
                var snd_name = global.weapon_sound_effect_name;
                var snd_volume = 0.25;
                var snd_pitch = 1 + random_range(-0.09, 0.09);
                var sound_disabled = false;
                if (global.weapon_sound_effect_name == snd_gun_flamethrower_B)
                {
                    play_sound(33);
                    sound_disabled = true;
                }
                if (global.weapon_sound_effect_name == snd_flamethrower)
                {
                    play_sound(115);
                    sound_disabled = true;
                }
                if (sound_disabled == false)
                {
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                    play_music(5);
                    play_sound(40);
                }
                break;
            case 1:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                var volume_multiplier = 1;
                if (sound_disabled == false)
                {
                    if (audio_is_playing(snd_enemy_hit_1))
                    {
                        audio_stop_sound(snd_enemy_hit_1);
                    }
                    var snd_name = snd_enemy_hit_1;
                    var snd_volume = 0.45 * volume_multiplier;
                    var snd_pitch = random_range(0.85, 1.15);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 2:
                var snd_name = snd_splash_1;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.85, 1.15);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 3:
                var snd_name = choose(snd_bullet_casing_1, snd_bullet_casing_2, snd_bullet_casing_3, snd_bullet_casing_4, snd_bullet_casing_5, snd_bullet_casing_6, snd_bullet_casing_7, snd_bullet_casing_8);
                var snd_volume = random_range(0.045, 0.085);
                var snd_pitch = random_range(0.85, 1.15);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 4:
                if (audio_is_playing(snd_coin))
                {
                    audio_stop_sound(snd_coin);
                }
                var snd_name = snd_coin;
                var snd_volume = 0.5;
                var snd_pitch = 1.9 + random_range(-0.05, 0.05) + global.coin_pitch_increase;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                if (global.coin_pitch_increase < 1.8)
                {
                    global.coin_pitch_increase += 0.05;
                }
                break;
            case 5:
                if (audio_is_playing(snd_enemy_dead_1))
                {
                    audio_stop_sound(snd_enemy_dead_1);
                }
                if (audio_is_playing(snd_enemy_dead_2))
                {
                    audio_stop_sound(snd_enemy_dead_2);
                }
                if (audio_is_playing(snd_enemy_dead_3))
                {
                    audio_stop_sound(snd_enemy_dead_3);
                }
                if (audio_is_playing(snd_enemy_dead_4))
                {
                    audio_stop_sound(snd_enemy_dead_4);
                }
                var snd_name = choose(snd_enemy_dead_1, snd_enemy_dead_2, snd_enemy_dead_3, snd_enemy_dead_4);
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 6:
                var snd_name = choose(snd_melee_1, snd_melee_2, snd_melee_3);
                var snd_volume = 1.1;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 7:
                if (audio_is_playing(snd_melee_hit_1))
                {
                    audio_stop_sound(snd_melee_hit_1);
                }
                if (audio_is_playing(snd_melee_hit_2))
                {
                    audio_stop_sound(snd_melee_hit_2);
                }
                if (audio_is_playing(snd_melee_hit_3))
                {
                    audio_stop_sound(snd_melee_hit_3);
                }
                var snd_name = choose(snd_melee_hit_1, snd_melee_hit_2, snd_melee_hit_3);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 8:
                var snd_name = snd_gun_swap;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 9:
                var snd_name = snd_ammo_refill;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 10:
                var snd_name = snd_pickup_hurt;
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 11:
                var snd_name = snd_hp_pickup;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 12:
                var snd_name = snd_chest_open;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 13:
                var snd_name = snd_key_pickup;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 14:
                var snd_name = snd_key_use;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 15:
                if (audio_is_playing(snd_bush_1))
                {
                    audio_stop_sound(snd_bush_1);
                }
                if (audio_is_playing(snd_bush_2))
                {
                    audio_stop_sound(snd_bush_2);
                }
                if (audio_is_playing(snd_bush_3))
                {
                    audio_stop_sound(snd_bush_3);
                }
                var snd_name = choose(snd_bush_1, snd_bush_2, snd_bush_3);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 16:
                if (audio_is_playing(snd_mushroom_1))
                {
                    audio_stop_sound(snd_mushroom_1);
                }
                if (audio_is_playing(snd_mushroom_2))
                {
                    audio_stop_sound(snd_mushroom_2);
                }
                if (audio_is_playing(snd_mushroom_3))
                {
                    audio_stop_sound(snd_mushroom_3);
                }
                var snd_name = choose(snd_mushroom_1, snd_mushroom_2, snd_mushroom_3);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 17:
                var snd_name = snd_button_hover;
                var snd_volume = 0.8;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 18:
                var snd_name = snd_button_press;
                var snd_volume = 0.8;
                var snd_pitch = random_range(0.99, 1.01);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 19:
                var snd_name = snd_button_exit;
                var snd_volume = 0.8;
                var snd_pitch = random_range(0.99, 1.01);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 20:
                var snd_name = snd_tentacle_open;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 21:
                var snd_name = snd_new_area;
                var snd_volume = 0.7;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 22:
                var snd_name = snd_game_over;
                var snd_volume = 1.6;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 23:
                var snd_name = snd_reload_end;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 24:
                var snd_name = snd_reload_start;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 25:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                if (sound_disabled == false)
                {
                    if (spd > 1.5)
                    {
                        if (!audio_is_playing(snd_bullet_hit_wall))
                        {
                            var snd_name = snd_bullet_hit_wall;
                            var snd_volume = 0.07;
                            var snd_pitch = random_range(0.8, 1.2);
                            var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                        }
                    }
                    else
                    {
                        play_sound(90, arg1);
                    }
                }
                break;
            case 26:
                if (audio_is_playing(snd_enemy_shot))
                {
                    audio_stop_sound(snd_enemy_shot);
                }
                var snd_name = snd_enemy_shot;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.9, 1.1);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 27:
                if (global.melee_attackrate_increase == 0)
                {
                    var snd_name = snd_melee_ready;
                    var snd_volume = 0.7;
                    var snd_pitch = random_range(0.98, 1.02);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 28:
                var snd_name = snd_button_hover;
                var snd_volume = 0.8;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 29:
                if (audio_is_playing(snd_gunshot_pistol))
                {
                    audio_stop_sound(snd_gunshot_pistol);
                }
                var snd_name = snd_gunshot_pistol;
                var snd_volume = 0.05;
                var snd_pitch = 1 + random_range(-0.15, 0.15);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 30:
                break;
            case 31:
                var snd_name = snd_logo;
                var snd_volume = 0.45;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 32:
                break;
            case 33:
                var snd_name = snd_gun_flamethrower_B;
                var snd_volume = 1;
                var snd_pitch = 1 + random_range(-0.01, 0.01);
                if (!audio_is_playing(snd_gun_flamethrower_B))
                {
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                else
                {
                    audio_sound_gain(snd_gun_flamethrower_B, snd_volume, 0);
                    audio_sound_gain(snd_gun_flamethrower_B, 0, 100);
                }
                break;
            case 34:
                var snd_name = snd_cricket_pickup;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 35:
                var snd_name = snd_cricket_gold_pickup;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                switch (global.gold_crickets_given + global.gold_crickets_held)
                {
                    case 2:
                        snd_pitch = snd_pitch + 0.1;
                        break;
                    case 3:
                        snd_pitch = snd_pitch + 0.2;
                        break;
                }
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 36:
                var snd_name = snd_secret_room_presence;
                var snd_volume = 0.5;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 37:
                if (!audio_is_playing(snd_quest_progress))
                {
                    var snd_name = snd_quest_progress;
                    var snd_volume = 1;
                    var snd_pitch = quest_progress_pitch + 0.5;
                    quest_progress_pitch += 0.24;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 38:
                if (audio_is_playing(snd_unlock))
                {
                    audio_stop_sound(snd_unlock);
                }
                var snd_name = snd_unlock;
                var snd_volume = 1;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 39:
                if (!audio_is_playing(snd_poof))
                {
                    var snd_name = snd_poof;
                    var snd_volume = 0.3;
                    var snd_pitch = random_range(0.96, 1.04);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 40:
                var snd_name = snd_gunshot_echo;
                var snd_volume = 1;
                var snd_pitch = random_range(0.96, 1.04);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 41:
                play_sound(62);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                var snd_name = snd_fishing_yank;
                var snd_volume = 0.65;
                var snd_pitch = random_range(0.94, 1.06);
                snd_time = 0;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                snd_time = 330;
                snd_volume = 0;
                audio_sound_gain(snd, snd_volume, snd_time);
                break;
            case 42:
                play_sound(62);
                var snd_name = snd_fishing_hook;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.96, 1.04);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 43:
                var snd_name = snd_fishing_reel_in_no_fish;
                var snd_volume = 0.3;
                var snd_pitch = 1;
                snd_time = 0;
                var fish_hooked = false;
                if (instance_exists(obj_rope_holder_end))
                {
                    if (obj_rope_holder_end.fish_on_underwater == true)
                    {
                        fish_hooked = true;
                    }
                }
                if (input_check("melee") && global.player_is_dead == false && instance_exists(obj_rope_holder_end))
                {
                    if (fish_hooked == false)
                    {
                        snd_name = snd_fishing_reel_in_no_fish;
                        if (!audio_is_playing(snd_fishing_reel_in_no_fish))
                        {
                            var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                            snd_volume = 0;
                            snd_time = 30;
                            audio_sound_gain(snd_fishing_reel_in_no_fish, snd_volume, snd_time);
                        }
                        else
                        {
                            audio_sound_gain(snd_fishing_reel_in_no_fish, snd_volume, 0);
                            snd_volume = 0;
                            snd_time = 30;
                            audio_sound_gain(snd_fishing_reel_in_no_fish, snd_volume, snd_time);
                        }
                    }
                    else
                    {
                        snd_name = snd_fishing_reel_in;
                        if (!audio_is_playing(snd_fishing_reel_in))
                        {
                            var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                            snd_volume = 0;
                            snd_time = 30;
                            audio_sound_gain(snd_fishing_reel_in, snd_volume, snd_time);
                        }
                        else
                        {
                            audio_sound_gain(snd_fishing_reel_in, snd_volume, 0);
                            snd_volume = 0;
                            snd_time = 30;
                            audio_sound_gain(snd_fishing_reel_in, snd_volume, snd_time);
                        }
                    }
                }
                break;
            case 44:
                play_sound(62);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                var snd_name = snd_fishing_yank;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.94, 1.06) - 0.025;
                snd_time = 0;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                snd_time = 120;
                snd_volume = 0;
                audio_sound_gain(snd, snd_volume, snd_time);
                break;
            case 45:
                play_sound(62);
                play_sound(1);
                play_sound(1);
                var snd_name = snd_fishing_yank;
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.94, 1.06) - 0.05;
                snd_time = 0;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                snd_time = 60;
                snd_volume = 0;
                audio_sound_gain(snd, snd_volume, snd_time);
                break;
            case 46:
                play_music(7);
                var snd_name = snd_item_room_enter;
                var snd_volume = 0.3;
                var snd_pitch = 0.6;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 47:
                var snd_name = snd_pink_button_squash;
                var snd_volume = 0.2;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 48:
                if (audio_is_playing(snd_bush_1))
                {
                    audio_stop_sound(snd_bush_1);
                }
                if (audio_is_playing(snd_bush_2))
                {
                    audio_stop_sound(snd_bush_2);
                }
                if (audio_is_playing(snd_bush_3))
                {
                    audio_stop_sound(snd_bush_3);
                }
                var snd_name = choose(snd_bush_1, snd_bush_2, snd_bush_3);
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 49:
                var snd_name = snd_change_room;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 50:
                if (!audio_is_playing(snd_hit_plank))
                {
                    var snd_name = snd_hit_plank;
                    var snd_volume = 0.1;
                    var snd_pitch = random_range(0.98, 1.02);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 51:
                var snd_name = snd_block_destroy;
                var snd_volume = 0.45;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 52:
                var snd_name = snd_block_appear;
                var snd_volume = 0.6;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 53:
                var snd_name = choose(snd_bubble_1, snd_bubble_2, snd_bubble_3, snd_bubble_4, snd_bubble_5, snd_bubble_6, snd_bubble_7, snd_bubble_8, snd_bubble_9, snd_bubble_10, snd_bubble_11);
                var snd_volume = 0.05;
                var snd_pitch = 1 + random_range(-0.02, 0.02);
                snd_time = 0;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 54:
                play_sound(1);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                break;
            case 55:
                play_sound(1);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                play_sound(1);
                break;
            case 56:
                var snd_name = snd_weapon_pickup;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 57:
                play_music(5);
                var snd_name = snd_item_pickup;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 58:
                play_sound(10);
                play_music(6);
                var snd_name = snd_item_evil_pickup;
                var snd_volume = 0.6;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 59:
                play_sound(62);
                var snd_name = choose(snd_lure_splash_1, snd_lure_splash_2, snd_lure_splash_3, snd_lure_splash_4, snd_lure_splash_5, snd_lure_splash_6, snd_lure_splash_7);
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 60:
                var snd_name = choose(snd_splash_tiny_1, snd_splash_tiny_2, snd_splash_tiny_3, snd_splash_tiny_4, snd_splash_tiny_5, snd_splash_tiny_6, snd_splash_tiny_7, snd_splash_tiny_8);
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 61:
                play_sound(62);
                var snd_name = choose(snd_splash_big_1, snd_splash_big_2, snd_splash_big_3, snd_splash_big_4);
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 62:
                var snd_name = choose(snd_splash_crunch_1, snd_splash_crunch_2, snd_splash_crunch_3, snd_splash_crunch_4, snd_splash_crunch_5, snd_splash_crunch_6, snd_splash_crunch_7);
                var snd_volume = 0.05;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 63:
                var snd_name = choose(snd_cricket_gold_toss_1, snd_cricket_gold_toss_2, snd_cricket_gold_toss_3, snd_cricket_gold_toss_4);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 64:
                var snd_name = choose(snd_cricket_gold_donate);
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 65:
                play_sound(1);
                play_sound(1);
                play_sound(1);
                break;
            case 66:
                var snd_name = snd_unlock;
                var snd_volume = 1;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 67:
                var snd_name = snd_quest_refresh;
                var snd_volume = 1;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 68:
                if (audio_is_playing(snd_stone_destroy))
                {
                    audio_stop_sound(snd_stone_destroy);
                }
                var snd_name = snd_stone_destroy;
                var snd_volume = 0.7;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 69:
                var snd_name = snd_interact;
                var snd_volume = 0.15;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 70:
                var snd_name = snd_purchase;
                var snd_volume = 0.05;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                snd_name = choose(snd_purchase_1, snd_purchase_2, snd_purchase_3, snd_purchase_4);
                snd_volume = 0.4;
                snd_pitch = 1;
                snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 71:
                var snd_name = snd_interact;
                var snd_volume = 0.9;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 72:
                var snd_name = snd_quest_refresh;
                var snd_volume = 1;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 73:
                break;
            case 74:
                if (audio_is_playing(snd_gravel_1))
                {
                    audio_stop_sound(snd_gravel_1);
                }
                if (audio_is_playing(snd_gravel_2))
                {
                    audio_stop_sound(snd_gravel_2);
                }
                if (audio_is_playing(snd_gravel_3))
                {
                    audio_stop_sound(snd_gravel_3);
                }
                var snd_name = choose(snd_gravel_1, snd_gravel_2, snd_gravel_3);
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 75:
                break;
            case 76:
                break;
            case 77:
                if (audio_is_playing(snd_ice_piece_1))
                {
                    audio_stop_sound(snd_ice_piece_1);
                }
                if (audio_is_playing(snd_ice_piece_2))
                {
                    audio_stop_sound(snd_ice_piece_2);
                }
                if (audio_is_playing(snd_ice_piece_3))
                {
                    audio_stop_sound(snd_ice_piece_3);
                }
                if (audio_is_playing(snd_ice_piece_4))
                {
                    audio_stop_sound(snd_ice_piece_4);
                }
                var snd_name = choose(snd_ice_piece_1, snd_ice_piece_2, snd_ice_piece_3, snd_ice_piece_4);
                var snd_volume = 0.04;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 78:
                if (audio_is_playing(snd_enemy_piece_1))
                {
                    audio_stop_sound(snd_enemy_piece_1);
                }
                if (audio_is_playing(snd_enemy_piece_2))
                {
                    audio_stop_sound(snd_enemy_piece_2);
                }
                if (audio_is_playing(snd_enemy_piece_3))
                {
                    audio_stop_sound(snd_enemy_piece_3);
                }
                if (audio_is_playing(snd_enemy_piece_4))
                {
                    audio_stop_sound(snd_enemy_piece_4);
                }
                var snd_name = choose(snd_enemy_piece_1, snd_enemy_piece_2, snd_enemy_piece_3, snd_enemy_piece_4);
                var snd_volume = 0.04;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 79:
                var snd_name = choose(snd_splash_tiny_1, snd_splash_tiny_2, snd_splash_tiny_3, snd_splash_tiny_4, snd_splash_tiny_5, snd_splash_tiny_6, snd_splash_tiny_7, snd_splash_tiny_8);
                var snd_volume = 0.025;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 80:
                play_sound(65);
                play_sound(40);
                var snd_name = choose(snd_whip_1, snd_whip_2, snd_whip_3);
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.92, 1.08);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 81:
                play_sound(65);
                var snd_name = choose(snd_whip_1, snd_whip_2, snd_whip_3);
                var snd_volume = 0.04;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 82:
                var snd_name = choose(snd_dialogue);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 83:
                var snd_name = choose(snd_dialogue);
                var snd_volume = 0.05;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 84:
                if (audio_is_playing(snd_bullet_hit_wall))
                {
                    audio_stop_sound(snd_bullet_hit_wall);
                }
                var snd_name = snd_bullet_hit_wall;
                var snd_volume = 0.07;
                var snd_pitch = random_range(0.8, 1.2);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                snd_name = choose(snd_mine_hit);
                snd_volume = 0.15;
                snd_pitch = random_range(0.95, 1.05);
                snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 85:
                play_music(7);
                var snd_name = choose(snd_explosion);
                var snd_volume = 0.36;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 86:
                var snd_name = choose(snd_player_hurt_1, snd_player_hurt_2, snd_player_hurt_3, snd_player_hurt_4);
                var snd_volume = 0.22;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 87:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                if (sound_disabled == false)
                {
                    if (audio_is_playing(snd_hit_plank))
                    {
                        audio_stop_sound(snd_hit_plank);
                    }
                    var snd_name = snd_hit_plank;
                    var snd_volume = 0.125;
                    var snd_pitch = random_range(0.95, 1.05);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 88:
                play_sound(61);
                play_sound(62);
                var snd_name = choose(snd_toad_boss_1, snd_toad_boss_2, snd_toad_boss_3);
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.96, 1.04);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 89:
                break;
            case 90:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                if (sound_disabled == false)
                {
                    if (audio_is_playing(snd_bullet_hit_wall_old))
                    {
                        audio_stop_sound(snd_bullet_hit_wall_old);
                    }
                    var snd_name = snd_bullet_hit_wall_old;
                    var snd_volume = 0.4;
                    var snd_pitch = random_range(0.95, 1.05);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 91:
                var snd_name = -4;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                switch (enemy_index)
                {
                    case 1:
                        snd_name = snd_enemy_crocodile;
                        snd_volume = 0.15;
                        break;
                    case 3:
                        snd_name = snd_enemy_waterspider;
                        break;
                    case 4:
                        snd_name = snd_enemy_waterspider_big;
                        break;
                    case 5:
                        snd_name = snd_enemy_waterspider_nest;
                        break;
                    case 6:
                        snd_name = snd_enemy_bird;
                        snd_volume = 0.1;
                        break;
                    case 7:
                        snd_name = snd_enemy_turtle_old;
                        snd_volume = 0.1;
                        break;
                    case 9:
                        snd_name = snd_enemy_slug;
                        snd_volume = 0.15;
                        break;
                    case 11:
                        snd_name = snd_enemy_tentacle;
                        snd_volume = 0.075;
                        break;
                    case 12:
                        snd_name = snd_enemy_maggot;
                        snd_volume = 0.15;
                        break;
                    case 13:
                        snd_name = snd_enemy_raven;
                        break;
                    case 14:
                        snd_name = snd_enemy_mushroom;
                        snd_volume = 0.15;
                        break;
                    case 15:
                        snd_name = snd_enemy_beetle;
                        break;
                    case 18:
                        snd_name = snd_enemy_bubble;
                        break;
                    case 19:
                        snd_name = snd_enemy_snail;
                        break;
                    case 21:
                        snd_name = snd_enemy_turtle;
                        break;
                    case 22:
                        snd_name = snd_enemy_muncher;
                        break;
                    case 24:
                        snd_name = snd_enemy_frog;
                        break;
                    case 25:
                        snd_name = snd_enemy_waterspider;
                        break;
                    case 26:
                        snd_name = snd_enemy_green_slug;
                        snd_volume = 0.075;
                        break;
                    case 27:
                        snd_name = snd_enemy_beak;
                        snd_volume = 0.1;
                        break;
                    case 28:
                        snd_name = snd_enemy_tentacle_blue;
                        snd_volume = 0.075;
                        break;
                    case 31:
                        snd_name = snd_enemy_waterspider_champion;
                        snd_volume = 0.15;
                        break;
                    case 33:
                        snd_name = snd_enemy_starfish;
                        snd_volume = 0.1;
                        break;
                    case 37:
                        snd_name = snd_enemy_fourleg;
                        snd_volume = 0.2;
                        break;
                    case 38:
                        snd_name = snd_enemy_big_bird;
                        snd_volume = 0.2;
                        break;
                    case 39:
                        snd_name = snd_enemy_water_spider_eye;
                        snd_volume = 0.05;
                        break;
                    case 40:
                        snd_name = snd_enemy_greenblob;
                        snd_volume = 0.125;
                        break;
                    case 41:
                        snd_name = snd_enemy_hole_mouth;
                        snd_volume = 0.05;
                        break;
                    case 42:
                        snd_name = snd_enemy_spooker;
                        snd_volume = 0.2;
                        break;
                    case 43:
                        snd_name = snd_enemy_crab;
                        snd_volume = 0.15;
                        break;
                }
                if (snd_name != -4)
                {
                    if (!audio_is_playing(snd_name))
                    {
                        var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                    }
                }
                break;
            case 92:
                var snd_name = choose(snd_run_start);
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 93:
                if (audio_is_playing(snd_coin_gold))
                {
                    audio_stop_sound(snd_coin_gold);
                }
                var snd_name = snd_coin_gold;
                var snd_volume = 0.5;
                var snd_pitch = 1.7;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 94:
                var snd_name = snd_coin_red;
                var snd_volume = 0.5;
                var snd_pitch = 1.4;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 95:
                if (audio_is_playing(snd_spike_appear))
                {
                    audio_stop_sound(snd_spike_appear);
                }
                var snd_name = snd_spike_appear;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.96, 1.04);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 96:
                if (audio_is_playing(snd_spike_activate))
                {
                    audio_stop_sound(snd_spike_activate);
                }
                var snd_name = snd_spike_activate;
                var snd_volume = 1;
                var snd_pitch = random_range(0.96, 1.04);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 97:
                var audio_playing = false;
                if (audio_is_playing(snd_ice_crack_1))
                {
                    audio_playing = true;
                }
                if (audio_is_playing(snd_ice_crack_2))
                {
                    audio_playing = true;
                }
                if (audio_is_playing(snd_ice_crack_3))
                {
                    audio_playing = true;
                }
                if (audio_playing == false)
                {
                    var snd_name = choose(snd_ice_crack_1, snd_ice_crack_2, snd_ice_crack_3);
                    var snd_volume = 0.025;
                    var snd_pitch = random_range(0.92, 1.08);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 98:
                if (audio_is_playing(snd_ice_break_1))
                {
                    audio_stop_sound(snd_ice_break_1);
                }
                if (audio_is_playing(snd_ice_break_2))
                {
                    audio_stop_sound(snd_ice_break_2);
                }
                if (audio_is_playing(snd_ice_break_3))
                {
                    audio_stop_sound(snd_ice_break_3);
                }
                if (audio_is_playing(snd_ice_break_4))
                {
                    audio_stop_sound(snd_ice_break_4);
                }
                var snd_name = choose(snd_ice_break_1, snd_ice_break_2, snd_ice_break_3, snd_ice_break_4);
                var snd_volume = 0.045;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 99:
                if (audio_is_playing(snd_gas_1))
                {
                    audio_stop_sound(snd_gas_1);
                }
                if (audio_is_playing(snd_gas_2))
                {
                    audio_stop_sound(snd_gas_2);
                }
                if (audio_is_playing(snd_gas_3))
                {
                    audio_stop_sound(snd_gas_3);
                }
                var snd_name = choose(snd_gas_1, snd_gas_2, snd_gas_3);
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 100:
                var snd_name = snd_fish_caught_1;
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.95, 1.05);
                switch (this_fish_rarity)
                {
                    case 1:
                        snd_name = snd_fish_caught_2;
                        break;
                    case 2:
                        snd_name = snd_fish_caught_2;
                        break;
                    case 3:
                        snd_name = snd_fish_caught_4;
                        break;
                }
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 101:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                var volume_multiplier = 1;
                if (sound_disabled == false)
                {
                    if (audio_is_playing(snd_explosion_small))
                    {
                        audio_stop_sound(snd_explosion_small);
                    }
                    var snd_name = choose(snd_explosion_small);
                    var snd_volume = 0.05;
                    var snd_pitch = random_range(0.98, 1.02);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 102:
                var snd_name = snd_item_use;
                var snd_volume = 0.275;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 103:
                var snd_name = snd_smg1;
                var snd_volume = 0.15;
                var snd_pitch = 1 + random_range(-0.06, 0.06);
                var sound_disabled = false;
                if (sound_disabled == false)
                {
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                    play_music(5);
                    play_sound(40);
                }
                break;
            case 104:
                var snd_name = snd_grenade_launcher;
                var snd_volume = 0.55;
                var snd_pitch = 1 + random_range(-0.06, 0.06);
                var sound_disabled = false;
                if (sound_disabled == false)
                {
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                    play_music(5);
                    play_sound(40);
                }
                break;
            case 105:
                if (audio_is_playing(snd_shopkeeper_1))
                {
                    audio_stop_sound(snd_shopkeeper_1);
                }
                if (audio_is_playing(snd_shopkeeper_2))
                {
                    audio_stop_sound(snd_shopkeeper_2);
                }
                if (audio_is_playing(snd_shopkeeper_3))
                {
                    audio_stop_sound(snd_shopkeeper_3);
                }
                var snd_name = choose(snd_shopkeeper_1, snd_shopkeeper_2, snd_shopkeeper_3);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 106:
                var snd_name = snd_bottle_pickup;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 107:
                var snd_name = snd_sausage_fight_spawner_appear;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 108:
                var snd_name = snd_sausage_fight_spawn_enemy;
                var snd_volume = 0.6;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 109:
                var snd_name = snd_sausage_stolen;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 110:
                var snd_name = snd_newspaper;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 111:
                var snd_name = snd_earthquake;
                var snd_volume = 0.6;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 112:
                if (audio_is_playing(snd_explosion_small))
                {
                    audio_stop_sound(snd_explosion_small);
                }
                var snd_name = choose(snd_explosion_small);
                var snd_volume = 0.11;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 113:
                if (audio_is_playing(snd_explosion_small))
                {
                    audio_stop_sound(snd_explosion_small);
                }
                var snd_name = choose(snd_explosion_small);
                var snd_volume = 0.14;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 114:
                if (audio_is_playing(snd_spike_activate))
                {
                    audio_stop_sound(snd_spike_activate);
                }
                var snd_name = snd_spike_activate;
                var snd_volume = 1;
                var snd_pitch = random_range(1.53, 1.57);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 115:
                var snd_name = snd_flamethrower;
                var snd_volume = 0.45;
                var snd_pitch = 1 + random_range(-0.01, 0.01);
                if (!audio_is_playing(snd_flamethrower))
                {
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                else
                {
                    audio_sound_gain(snd_flamethrower, snd_volume, 0);
                    audio_sound_gain(snd_flamethrower, 0, 100);
                }
                break;
            case 116:
                var snd_name = snd_fish_sold;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 117:
                var snd_name = snd_smiley_pick_up;
                var snd_volume = 0.6;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 118:
                var snd_name = snd_cheering;
                var snd_volume = 0.45;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 119:
                var sound_disabled = false;
                sound_disabled = disable_bullet_sound(arg1);
                var volume_multiplier = 1;
                if (sound_disabled == false)
                {
                    if (audio_is_playing(snd_enemy_hit_1))
                    {
                        audio_stop_sound(snd_enemy_hit_1);
                    }
                    var snd_name = snd_enemy_hit_1;
                    var snd_volume = 0.45 * volume_multiplier;
                    var snd_pitch = random_range(0.85, 1.15);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case 120:
                if (audio_is_playing(snd_toxic_puddle))
                {
                    audio_stop_sound(snd_toxic_puddle);
                }
                var snd_name = snd_toxic_puddle;
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 121:
                if (audio_is_playing(snd_laserspider))
                {
                    audio_stop_sound(snd_laserspider);
                }
                var snd_name = snd_laserspider;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 122:
                var snd_name = snd_laserspider_charge;
                var snd_volume = 0.1;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case 123:
                if (audio_is_playing(snd_explosion_dynamite))
                {
                    audio_stop_sound(snd_explosion_dynamite);
                }
                var snd_name = choose(snd_explosion_dynamite);
                var snd_volume = 0.17;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_124:
                var snd_name = snd_boss_intro;
                var snd_volume = 0.1;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_125:
                var snd_name = snd_boss_toad_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_134:
                var snd_name = snd_boss_mayor_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_153:
                var snd_name = snd_boss_fish_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_132:
                var snd_name = snd_boss_aggrorator_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_131:
                var snd_name = snd_boss_dragon_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_130:
                var snd_name = snd_boss_eye_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_129:
                var snd_name = snd_boss_clawking_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_128:
                var snd_name = snd_boss_gobolin_intro;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_133:
                var snd_name = snd_boss_drooler_intro;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_126:
                var snd_name = snd_boss_moth_intro;
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_127:
                var snd_name = snd_boss_pig_intro;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_135:
                var snd_name = snd_boss_toad_slam;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_136:
                var snd_name = snd_boss_toad_shoot;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_137:
                var snd_name = snd_boss_toad_egg_lay;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_138:
                var snd_name = snd_boss_toad_egg_break;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_139:
                var snd_name = snd_boss_toad_egg_hatch;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_140:
                if (arg1 != -4)
                {
                    if (instance_exists(arg1))
                    {
                        switch (arg1.my_boss_index)
                        {
                            case 10:
                                play_sound(UnknownEnum.Value_125);
                                break;
                            case 16:
                                play_sound(UnknownEnum.Value_132);
                                break;
                            case 29:
                                play_sound(UnknownEnum.Value_131);
                                break;
                            case 35:
                                play_sound(UnknownEnum.Value_130);
                                break;
                            case 47:
                                play_sound(UnknownEnum.Value_128);
                                break;
                            case 48:
                                play_sound(UnknownEnum.Value_126);
                                break;
                            case 49:
                                play_sound(UnknownEnum.Value_127);
                                break;
                            case 50:
                                play_sound(UnknownEnum.Value_129);
                                break;
                            case 52:
                                play_sound(UnknownEnum.Value_134);
                                break;
                            case 54:
                                play_sound(UnknownEnum.Value_133);
                                break;
                            case 55:
                                play_sound(UnknownEnum.Value_153);
                                break;
                        }
                    }
                }
                break;
            case UnknownEnum.Value_141:
                var snd_name = snd_crawler_shot;
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_142:
                var snd_name = snd_crawler_shot_anticipate;
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_155:
                var snd_name = snd_tentacle_interact;
                var snd_volume = 0.3;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_156:
                if (audio_is_playing(snd_logo))
                {
                    audio_stop_sound(snd_logo);
                }
                break;
            case UnknownEnum.Value_164:
                var snd_name = snd_update_banner;
                var snd_volume = 0.6;
                var snd_pitch = 1;
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_144:
                break;
            case UnknownEnum.Value_143:
                var snd_name = snd_boss_gobolin_taunt;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_145:
                var snd_name = snd_plop;
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_165:
                var snd_name = snd_plop;
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_148:
                var snd_name = snd_plop;
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_146:
                var snd_name = snd_boss_eye_bush;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_147:
                var snd_name = snd_boss_eye_bush_2;
                var snd_volume = 0.13;
                var snd_pitch = random_range(0.9, 1.1);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_152:
                var snd_name = snd_plop;
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_149:
                var snd_name = snd_boss_dragon_laser;
                var snd_volume = 0.35;
                var snd_pitch = random_range(0.97, 1.03);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_150:
                var snd_name = snd_boss_dragon_blast;
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_151:
                var snd_name = snd_boss_dragon_shoot;
                var snd_volume = 0.25;
                var snd_pitch = random_range(0.9, 1.1);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_154:
                var snd_name = snd_plop;
                var snd_volume = 0.15;
                var snd_pitch = random_range(0.95, 1.05);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_157:
                if (audio_is_playing(snd_explosion_final_boss))
                {
                    audio_stop_sound(snd_explosion_final_boss);
                }
                var snd_name = choose(snd_explosion_final_boss);
                var snd_volume = 0.2;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_159:
                var snd_name = choose(snd_final_boss_death);
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_158:
                var snd_name = choose(snd_final_boss_death_mayor);
                var snd_volume = 0.5;
                var snd_pitch = random_range(0.98, 1.02);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_160:
                var snd_name = choose(snd_boss_mayor_ouch);
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.92, 1.08);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_162:
                play_sound(120);
                var snd_name = choose(snd_mayor_toxic_attack);
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.92, 1.08);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_161:
                var snd_name = choose(snd_mayor_transform);
                var snd_volume = 0.4;
                var snd_pitch = random_range(0.92, 1.08);
                var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                break;
            case UnknownEnum.Value_163:
                if (!audio_is_playing(snd_mayor_warning))
                {
                    var snd_name = choose(snd_mayor_warning);
                    var snd_volume = 0.2;
                    var snd_pitch = random_range(0.92, 1.08);
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case UnknownEnum.Value_166:
                if (audio_is_playing(snd_dlc_story_1))
                {
                    audio_stop_sound(snd_dlc_story_1);
                }
                if (audio_is_playing(snd_dlc_story_2))
                {
                    audio_stop_sound(snd_dlc_story_2);
                }
                if (audio_is_playing(snd_dlc_story_3))
                {
                    audio_stop_sound(snd_dlc_story_3);
                }
                if (audio_is_playing(snd_dlc_story_4))
                {
                    audio_stop_sound(snd_dlc_story_4);
                }
                if (audio_is_playing(snd_dlc_story_5))
                {
                    audio_stop_sound(snd_dlc_story_5);
                }
                break;
            case UnknownEnum.Value_167:
                play_sound(UnknownEnum.Value_166);
                if (!audio_is_playing(snd_dlc_story_1))
                {
                    var snd_name = choose(snd_dlc_story_1);
                    var snd_volume = 1;
                    var snd_pitch = 1;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case UnknownEnum.Value_168:
                play_sound(UnknownEnum.Value_166);
                if (!audio_is_playing(snd_dlc_story_2))
                {
                    var snd_name = choose(snd_dlc_story_2);
                    var snd_volume = 1;
                    var snd_pitch = 1;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case UnknownEnum.Value_169:
                play_sound(UnknownEnum.Value_166);
                if (!audio_is_playing(snd_dlc_story_3))
                {
                    var snd_name = choose(snd_dlc_story_3);
                    var snd_volume = 1;
                    var snd_pitch = 1;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case UnknownEnum.Value_170:
                play_sound(UnknownEnum.Value_166);
                if (!audio_is_playing(snd_dlc_story_4))
                {
                    var snd_name = choose(snd_dlc_story_4);
                    var snd_volume = 1;
                    var snd_pitch = 1;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
            case UnknownEnum.Value_171:
                play_sound(UnknownEnum.Value_166);
                if (!audio_is_playing(snd_dlc_story_5))
                {
                    var snd_name = choose(snd_dlc_story_5);
                    var snd_volume = 1;
                    var snd_pitch = 1;
                    var snd = play_sound_default(snd_name, snd_volume, snd_pitch, snd_time);
                }
                break;
        }
    }
}

enum UnknownEnum
{
    Value_124 = 124,
    Value_125,
    Value_126,
    Value_127,
    Value_128,
    Value_129,
    Value_130,
    Value_131,
    Value_132,
    Value_133,
    Value_134,
    Value_135,
    Value_136,
    Value_137,
    Value_138,
    Value_139,
    Value_140,
    Value_141,
    Value_142,
    Value_143,
    Value_144,
    Value_145,
    Value_146,
    Value_147,
    Value_148,
    Value_149,
    Value_150,
    Value_151,
    Value_152,
    Value_153,
    Value_154,
    Value_155,
    Value_156,
    Value_157,
    Value_158,
    Value_159,
    Value_160,
    Value_161,
    Value_162,
    Value_163,
    Value_164,
    Value_165,
    Value_166,
    Value_167,
    Value_168,
    Value_169,
    Value_170,
    Value_171
}
