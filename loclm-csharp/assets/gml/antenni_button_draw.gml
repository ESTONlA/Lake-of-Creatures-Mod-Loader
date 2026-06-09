if (variable_global_exists("antenni_menu_open") && global.antenni_menu_open == true && button_index == 91)
{
    var panel_x = 20;
    var panel_y = 16;
    var panel_w = room_width - 40;
    var panel_h = room_height - 82;
    var text_x = panel_x + 18;
    var text_y = panel_y + 14;
    var left_x = text_x;
    var right_x = panel_x + 242;
    var section_y = text_y + 82;

    draw_set_alpha(0.78);
    draw_set_color(c_black);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, false);
    draw_set_alpha(0.9);
    draw_set_color(global.color_outline);
    draw_rectangle(panel_x, panel_y, panel_x + panel_w, panel_y + panel_h, true);
    draw_set_alpha(1);

    draw_set_font(global.font_current);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_color(global.color_yellow);
    draw_text_outline_b2x(text_x, text_y, "Antenni Loader");
    draw_set_color(c_white);
    draw_text(text_x, text_y + 25, "Community-built loader for Lake of Creatures");
    draw_set_color(12632256);
    draw_text(text_x, text_y + 45, "Made by Estonia, for love of the game.");

    draw_set_color(global.color_yellow);
    draw_text(left_x, section_y, "Loader Version");
    draw_set_color(c_white);
    draw_text(left_x + 18, section_y + 22, __LOADER_VERSION__);

    draw_set_color(global.color_yellow);
    draw_text(right_x, section_y, "Loaded Mods");
    draw_set_color(c_white);
    var loaded_visible = 4;
    var loaded_count = global.antenni_loaded_mod_count;
    if (loaded_count <= 0)
    {
        draw_text(right_x + 18, section_y + 22, "None");
    }
    else
    {
        var loaded_start = global.antenni_loaded_scroll;
        var loaded_end = min(loaded_count, loaded_start + loaded_visible);
        for (var i = loaded_start; i < loaded_end; i += 1)
        {
            var mod_name = string(global.antenni_loaded_mods[i]);
            if (string_length(mod_name) > 35)
            {
                mod_name = string_copy(mod_name, 1, 32) + "...";
            }
            draw_text(right_x + 18, section_y + 22 + ((i - loaded_start) * 20), "- " + mod_name);
        }
        if (loaded_count > loaded_visible)
        {
            draw_set_color(8421504);
            draw_text(right_x + 112, section_y, string(loaded_start + 1) + "-" + string(loaded_end) + "/" + string(loaded_count));
            draw_text(right_x + 18, section_y + 106, "Scroll: wheel / Up / Down");
        }
    }

    var conflict_y = section_y + 142;
    draw_set_color(global.color_yellow);
    draw_text(right_x, conflict_y, "Possible Conflicts");
    draw_set_color(c_white);
    if (!variable_global_exists("antenni_mod_conflict_count") || global.antenni_mod_conflict_count <= 0)
    {
        draw_text(right_x + 18, conflict_y + 22, "None");
    }
    else
    {
        var conflict_visible = min(global.antenni_mod_conflict_count, 4);
        for (var c = 0; c < conflict_visible; c += 1)
        {
            var conflict_text = string(global.antenni_mod_conflicts[c]);
            if (string_length(conflict_text) > 43)
            {
                conflict_text = string_copy(conflict_text, 1, 40) + "...";
            }
            draw_text(right_x + 18, conflict_y + 22 + (c * 20), "- " + conflict_text);
        }
        if (global.antenni_mod_conflict_count > conflict_visible)
        {
            draw_set_color(8421504);
            draw_text(right_x + 18, conflict_y + 106, "+" + string(global.antenni_mod_conflict_count - conflict_visible) + " more in Logs/mod_conflicts.json");
        }
    }

    if (variable_global_exists("antenni_folder_copied_timer") && global.antenni_folder_copied_timer > 0)
    {
        draw_set_color(global.color_yellow);
        draw_text(panel_x + panel_w - 138, panel_y + panel_h - 24, "Path copied.");
    }
}
event_inherited();
