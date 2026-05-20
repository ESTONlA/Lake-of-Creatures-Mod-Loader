function restart_game()
{
    with (all)
    {
        instance_destroy();
    }
    draw_texture_flush();
    audio_stop_all();
    room_goto(rm_menu_main);
    game_start_init();
}
