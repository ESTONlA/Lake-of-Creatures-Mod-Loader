function play_music(arg0)
{
    var max_music_volume = 0.5;
    audio_sound_loop_start(bgm_music_lake1_new, 164.07);
    audio_sound_loop_end(bgm_music_lake1_new, 288.62);
    audio_sound_loop_start(bgm_music_lake1_solo_new, 164.07);
    audio_sound_loop_end(bgm_music_lake1_solo_new, 288.62);
    audio_sound_loop_start(bgm_music_lake2_new, 111.16);
    audio_sound_loop_end(bgm_music_lake2_new, 222.325);
    audio_sound_loop_start(bgm_music_lake2_solo_new, 111.16);
    audio_sound_loop_end(bgm_music_lake2_solo_new, 222.325);
    audio_sound_loop_start(bgm_music_lake3_new, 94.995);
    audio_sound_loop_end(bgm_music_lake3_new, 186.521);
    audio_sound_loop_start(bgm_music_lake3_solo_new, 94.995);
    audio_sound_loop_end(bgm_music_lake3_solo_new, 186.521);
    audio_sound_loop_start(bgm_music_lake4_new, 21.14);
    audio_sound_loop_end(bgm_music_lake4_new, 115.515);
    audio_sound_loop_start(bgm_music_lake4_solo_new, 21.14);
    audio_sound_loop_end(bgm_music_lake4_solo_new, 115.515);
    audio_sound_loop_start(bgm_music_boss, 7.125);
    audio_sound_loop_end(bgm_music_boss, 117.745);
    audio_sound_loop_start(bgm_story, 12.79);
    audio_sound_loop_end(bgm_story, 50.94);
    if (global.music_on == true)
    {
        switch (arg0)
        {
            case 0:
                if (!audio_is_playing(global.bgm_mainmenu))
                {
                    global.bgm_mainmenu = audio_play_sound(bgm_music_mainmenu, 0, 1);
                    audio_sound_gain(global.bgm_mainmenu, 0, 0);
                    audio_sound_gain(global.bgm_mainmenu, max_music_volume, 300);
                }
                break;
            case 1:
                if (audio_is_playing(global.bgm_mainmenu))
                {
                    audio_sound_gain(global.bgm_mainmenu, 0, 4500);
                }
                break;
            case 2:
                switch (get_lake_type(global.current_lake))
                {
                    case 1:
                        if (!audio_is_playing(bgm_music_lake1_new))
                        {
                            global.bgm_levelmusic_1 = audio_play_sound(bgm_music_lake1_new, 0, 1);
                            global.bgm_levelmusic_1_solo = audio_play_sound(bgm_music_lake1_solo_new, 0, 1);
                            audio_sound_loop(global.bgm_levelmusic_1, true);
                            audio_sound_loop(global.bgm_levelmusic_1_solo, true);
                            audio_sound_gain(global.bgm_levelmusic_1, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_1_solo, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_1, max_music_volume, 3000);
                            global.main_track_active = true;
                        }
                        break;
                    case 2:
                        if (audio_is_playing(global.bgm_levelmusic_1))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (audio_is_playing(global.bgm_levelmusic_1_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1_solo, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (!audio_is_playing(bgm_music_lake2_new))
                        {
                            global.bgm_levelmusic_2 = audio_play_sound(bgm_music_lake2_new, 0, 1);
                            global.bgm_levelmusic_2_solo = audio_play_sound(bgm_music_lake2_solo_new, 0, 1);
                            audio_sound_loop(global.bgm_levelmusic_2, true);
                            audio_sound_loop(global.bgm_levelmusic_2_solo, true);
                            audio_sound_gain(global.bgm_levelmusic_2, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_2_solo, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_2, max_music_volume, 9000);
                            global.main_track_active = true;
                        }
                        break;
                    case 3:
                        if (audio_is_playing(global.bgm_levelmusic_2))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (audio_is_playing(global.bgm_levelmusic_2_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2_solo, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (!audio_is_playing(bgm_music_lake3_new))
                        {
                            global.bgm_levelmusic_3 = audio_play_sound(bgm_music_lake3_new, 0, 1);
                            global.bgm_levelmusic_3_solo = audio_play_sound(bgm_music_lake3_solo_new, 0, 1);
                            audio_sound_loop(global.bgm_levelmusic_3, true);
                            audio_sound_loop(global.bgm_levelmusic_3_solo, true);
                            audio_sound_gain(global.bgm_levelmusic_3, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_3_solo, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_3, max_music_volume, 6000);
                            global.main_track_active = true;
                        }
                        break;
                    case 4:
                        if (audio_is_playing(global.bgm_levelmusic_3))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (audio_is_playing(global.bgm_levelmusic_3_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3_solo, 0, 4000);
                            global.main_track_active = false;
                        }
                        if (!audio_is_playing(bgm_music_lake4_new))
                        {
                            global.bgm_levelmusic_4 = audio_play_sound(bgm_music_lake4_new, 0, 1);
                            global.bgm_levelmusic_4_solo = audio_play_sound(bgm_music_lake4_solo_new, 0, 1);
                            audio_sound_loop(global.bgm_levelmusic_4, true);
                            audio_sound_loop(global.bgm_levelmusic_4_solo, true);
                            audio_sound_gain(global.bgm_levelmusic_4, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_4_solo, 0, 0);
                            audio_sound_gain(global.bgm_levelmusic_4, max_music_volume, 6000);
                            global.main_track_active = true;
                        }
                        break;
                }
                break;
            case 3:
                global.solo_track_active = true;
                switch (get_lake_type(global.current_lake))
                {
                    case 1:
                        if (audio_is_playing(global.bgm_levelmusic_1_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1_solo, max_music_volume, 6000);
                        }
                        break;
                    case 2:
                        if (audio_is_playing(global.bgm_levelmusic_2_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2_solo, max_music_volume, 6000);
                        }
                        break;
                    case 3:
                        if (audio_is_playing(global.bgm_levelmusic_3_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3_solo, max_music_volume, 6000);
                        }
                        break;
                    case 4:
                        if (audio_is_playing(global.bgm_levelmusic_4_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_4_solo, max_music_volume, 6000);
                        }
                        break;
                }
                break;
            case 4:
                global.solo_track_active = false;
                switch (get_lake_type(global.current_lake))
                {
                    case 1:
                        if (audio_is_playing(global.bgm_levelmusic_1_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1_solo, 0, 3000);
                        }
                        break;
                    case 2:
                        if (audio_is_playing(global.bgm_levelmusic_2_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2_solo, 0, 3000);
                        }
                        break;
                    case 3:
                        if (audio_is_playing(global.bgm_levelmusic_3_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3_solo, 0, 3000);
                        }
                        break;
                    case 4:
                        if (audio_is_playing(global.bgm_levelmusic_4_solo))
                        {
                            audio_sound_gain(global.bgm_levelmusic_4_solo, 0, 3000);
                        }
                        break;
                }
                break;
            case 5:
                global.volume_music_multiplier_spd = 0;
                global.volume_music_multiplier = 0.5;
                break;
            case 6:
                global.volume_music_multiplier_spd = 0;
                global.volume_music_multiplier = 0.6;
                break;
            case 7:
                global.volume_music_multiplier_spd = 0;
                global.volume_music_multiplier = 0;
                break;
            case 8:
                if (!audio_is_playing(global.bgm_ambient))
                {
                    global.bgm_ambient = audio_play_sound(bgm_ambient, 0, 1);
                    audio_sound_gain(global.bgm_ambient, 0, 0);
                    audio_sound_gain(global.bgm_ambient, max_music_volume, 1000);
                }
                break;
            case 9:
                if (global.main_track_active == true)
                {
                    play_music(4);
                    switch (get_lake_type(global.current_lake))
                    {
                        case 1:
                            if (audio_is_playing(global.bgm_levelmusic_1))
                            {
                                audio_sound_gain(global.bgm_levelmusic_1, max_music_volume * 0.85, 1000);
                            }
                            break;
                        case 2:
                            if (audio_is_playing(global.bgm_levelmusic_2))
                            {
                                audio_sound_gain(global.bgm_levelmusic_2, max_music_volume * 0.85, 1000);
                            }
                            break;
                        case 3:
                            if (audio_is_playing(global.bgm_levelmusic_3))
                            {
                                audio_sound_gain(global.bgm_levelmusic_3, max_music_volume * 0.85, 1000);
                            }
                            break;
                        case 4:
                            if (audio_is_playing(global.bgm_levelmusic_4))
                            {
                                audio_sound_gain(global.bgm_levelmusic_4, max_music_volume * 0.85, 1000);
                            }
                            break;
                    }
                    global.main_track_active = false;
                }
                break;
            case 10:
                switch (get_lake_type(global.current_lake))
                {
                    case 1:
                        if (audio_is_playing(global.bgm_levelmusic_1))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1, max_music_volume, 1000);
                        }
                        break;
                    case 2:
                        if (audio_is_playing(global.bgm_levelmusic_2))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2, max_music_volume, 1000);
                        }
                        break;
                    case 3:
                        if (audio_is_playing(global.bgm_levelmusic_3))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3, max_music_volume, 1000);
                        }
                        break;
                    case 4:
                        if (audio_is_playing(global.bgm_levelmusic_4))
                        {
                            audio_sound_gain(global.bgm_levelmusic_4, max_music_volume, 1000);
                        }
                        break;
                }
                break;
            case 11:
                play_music(13);
                global.bgm_boss = audio_play_sound(bgm_music_boss, 0, true);
                audio_sound_loop(global.bgm_boss, true);
                break;
            case 12:
                audio_play_sound(bgm_music_boss_end, 0, false);
                if (audio_is_playing(bgm_music_boss))
                {
                    audio_stop_sound(bgm_music_boss);
                }
                break;
            case 13:
                if (global.main_track_active == true)
                {
                    play_music(4);
                    switch (get_lake_type(global.current_lake))
                    {
                        case 1:
                            if (audio_is_playing(global.bgm_levelmusic_1))
                            {
                                audio_sound_gain(global.bgm_levelmusic_1, 0, 4000);
                            }
                            break;
                        case 2:
                            if (audio_is_playing(global.bgm_levelmusic_2))
                            {
                                audio_sound_gain(global.bgm_levelmusic_2, 0, 4000);
                            }
                            break;
                        case 3:
                            if (audio_is_playing(global.bgm_levelmusic_3))
                            {
                                audio_sound_gain(global.bgm_levelmusic_3, 0, 4000);
                            }
                            break;
                        case 4:
                            if (audio_is_playing(global.bgm_levelmusic_4))
                            {
                                audio_sound_gain(global.bgm_levelmusic_4, 0, 4000);
                            }
                            break;
                    }
                    global.main_track_active = false;
                }
                break;
            case 14:
                if (audio_is_playing(global.bgm_story))
                {
                    audio_sound_gain(global.bgm_story, 0, 1200);
                }
                break;
            case 15:
                if (!audio_is_playing(global.bgm_story))
                {
                    global.bgm_story = audio_play_sound(bgm_story, 0, 1);
                    audio_sound_loop(global.bgm_story, true);
                    audio_sound_gain(global.bgm_story, 0, 0);
                    audio_sound_gain(global.bgm_story, max_music_volume, 4500);
                }
                else
                {
                    audio_sound_gain(global.bgm_story, max_music_volume, 1200);
                }
                break;
            case 16:
                play_music(4);
                switch (get_lake_type(global.current_lake))
                {
                    case 1:
                        if (audio_is_playing(global.bgm_levelmusic_1))
                        {
                            audio_sound_gain(global.bgm_levelmusic_1, 0, 4000);
                        }
                        break;
                    case 2:
                        if (audio_is_playing(global.bgm_levelmusic_2))
                        {
                            audio_sound_gain(global.bgm_levelmusic_2, 0, 4000);
                        }
                        break;
                    case 3:
                        if (audio_is_playing(global.bgm_levelmusic_3))
                        {
                            audio_sound_gain(global.bgm_levelmusic_3, 0, 4000);
                        }
                        break;
                    case 4:
                        if (audio_is_playing(global.bgm_levelmusic_4))
                        {
                            audio_sound_gain(global.bgm_levelmusic_4, 0, 4000);
                        }
                        break;
                }
                global.main_track_active = false;
                break;
            case 17:
                break;
        }
    }
}
