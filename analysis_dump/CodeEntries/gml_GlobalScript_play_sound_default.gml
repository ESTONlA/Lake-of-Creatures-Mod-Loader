function play_sound_default(arg0, arg1, arg2, arg3)
{
    var snd = audio_play_sound(arg0, 0, 0);
    audio_sound_gain(snd, global.volume_sound_final * arg1, arg3);
    audio_sound_pitch(snd, arg2);
    return snd;
}
