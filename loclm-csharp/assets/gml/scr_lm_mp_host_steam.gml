function scr_lm_mp_host_steam()
{
    scr_lm_mp_init();
    if (global.lm_mp_host_requested == true)
    {
        return;
    }

    global.lm_mp_host_requested = true;
    global.lm_mp_lobby_ready = false;
    global.lm_mp_connected = false;
    global.lm_mp_lobby_id = "";
    global.lm_mp_panel_message = "Creating Steam lobby...";
    global.lm_mp_status = "Requesting Steam lobby...";
    if (!scr_lm_mp_send_packet(3, -1))
    {
        global.lm_mp_host_requested = false;
        global.lm_mp_status = "Waiting for LOCLM Steam bridge...";
        global.lm_mp_panel_message = "Waiting for local Steam bridge. The lobby will be requested automatically.";
    }
}
