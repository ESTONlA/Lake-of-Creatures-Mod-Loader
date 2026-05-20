function music_volume_finalize()
{
    global.volume_music_multiplier_spd += ((0.02 - global.volume_music_multiplier_spd) * 0.1);
    global.volume_music_multiplier += ((1 - global.volume_music_multiplier) * global.volume_music_multiplier_spd);
    var final_music_volume = global.volume_music_final * global.volume_music_multiplier;
    audio_group_set_gain(bgm_ambient_intestines, final_music_volume, 0);
}
