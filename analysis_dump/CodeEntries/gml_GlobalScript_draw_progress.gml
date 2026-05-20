function draw_progress()
{
    with (obj_ctrl_unlocks_menu)
    {
        if (menu_index == 4)
        {
            var total_badges = global.playable_characters_total * 8;
            if (global.area4_visited == true)
            {
                total_badges = global.playable_characters_total * 10;
            }
            var draw_x = room_width / 2;
            var draw_y = ((room_height / 2) + other.my_yy) - 20;
            draw_set_halign(fa_left);
            draw_set_valign(fa_middle);
            draw_set_font(global.font_current);
            draw_set_alpha(1);
            draw_set_color(global.color_outline);
            draw_text_outline_b2x(draw_x - 100, draw_y - 40, txt("unlocks_treasures_found"));
            draw_text_outline_b2x(draw_x - 100, draw_y - 20, txt("unlocks_treasures_unlocked"));
            draw_text_outline_b2x(draw_x - 100, draw_y - 0, txt("unlocks_fishes"));
            draw_text_outline_b2x(draw_x - 100, draw_y + 20, txt("unlocks_characters_unlocked"));
            draw_text_outline_b2x(draw_x - 100, draw_y + 40, txt("unlocks_features_unlocked"));
            draw_text_outline_b2x(draw_x - 100, draw_y + 60, txt("unlocks_badges"));
            draw_text_outline_b2x(draw_x - 100, draw_y + 80, txt("unlocks_quests"));
            draw_text_outline_b2x(draw_x - 100, draw_y + 100, txt("unlocks_progress"));
            draw_set_halign(fa_center);
            draw_text_outline_b2x(draw_x + 50, draw_y - 40, string(progress_treasures_found));
            draw_text_outline_b2x(draw_x + 50, draw_y - 20, string(progress_treasures_unlocked - global.pre_unlocked_treasured));
            draw_text_outline_b2x(draw_x + 50, draw_y - 0, string(progress_fishes));
            draw_text_outline_b2x(draw_x + 50, draw_y + 20, string(progress_characters));
            draw_text_outline_b2x(draw_x + 50, draw_y + 40, string(progress_features));
            draw_text_outline_b2x(draw_x + 50, draw_y + 60, string(progress_badges));
            draw_text_outline_b2x(draw_x + 50, draw_y + 80, string(global.tasks_completed));
            draw_text_outline_b2x(draw_x + 50, draw_y + 100, string(progress_percentage) + " %");
            draw_set_halign(fa_left);
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 40, "/ " + string(global.unlocks_total[0]));
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 20, "/ " + string(global.unlocks_total[0] - global.pre_unlocked_treasured));
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 0, "/ " + string(global.fish_species_total));
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 20, "/ " + string(global.playable_characters_total - 1));
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 40, "/ " + string(global.feature_unlocks_total));
            draw_text_outline_b2x(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 60, "/ " + string(total_badges));
            draw_set_halign(fa_left);
            draw_set_color(c_white);
            draw_text(draw_x - 100, draw_y - 40, txt("unlocks_treasures_found"));
            draw_text(draw_x - 100, draw_y - 20, txt("unlocks_treasures_unlocked"));
            draw_text(draw_x - 100, draw_y - 0, txt("unlocks_fishes"));
            draw_text(draw_x - 100, draw_y + 20, txt("unlocks_characters_unlocked"));
            draw_text(draw_x - 100, draw_y + 40, txt("unlocks_features_unlocked"));
            draw_text(draw_x - 100, draw_y + 60, txt("unlocks_badges"));
            draw_text(draw_x - 100, draw_y + 80, txt("unlocks_quests"));
            draw_set_color(global.color_yellow);
            draw_text(draw_x - 100, draw_y + 100, txt("unlocks_progress"));
            draw_set_halign(fa_center);
            draw_set_color(c_white);
            draw_text(draw_x + 50, draw_y - 40, string(progress_treasures_found));
            draw_text(draw_x + 50, draw_y - 20, string(progress_treasures_unlocked - global.pre_unlocked_treasured));
            draw_text(draw_x + 50, draw_y - 0, string(progress_fishes));
            draw_text(draw_x + 50, draw_y + 20, string(progress_characters));
            draw_text(draw_x + 50, draw_y + 40, string(progress_features));
            draw_text(draw_x + 50, draw_y + 60, string(progress_badges));
            draw_text(draw_x + 50, draw_y + 80, string(global.tasks_completed));
            draw_set_color(global.color_yellow);
            draw_text(draw_x + 50, draw_y + 100, string(progress_percentage) + " %");
            draw_set_halign(fa_left);
            draw_set_color(c_gray);
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 40, "/ " + string(global.unlocks_total[0]));
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 20, "/ " + string(global.unlocks_total[0] - global.pre_unlocked_treasured));
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y - 0, "/ " + string(global.fish_species_total));
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 20, "/ " + string(global.playable_characters_total - 1));
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 40, "/ " + string(global.feature_unlocks_total));
            draw_text(draw_x + 80 + global.font_unlock_total_number_xx, draw_y + 60, "/ " + string(total_badges));
            draw_set_alpha(1);
            draw_set_color(c_white);
        }
    }
}
