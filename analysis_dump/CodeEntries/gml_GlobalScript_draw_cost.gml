function draw_cost()
{
    var obj_name = object_get_name(object_index);
    var icon = spr_currency;
    var icon_index = 0;
    var y_offset = -28;
    var x_offset = 0;
    var disable_display = false;
    var cost_color = 16777215;
    switch (obj_name)
    {
        case "obj_item_pickup":
            if (cost == 1 || cost == 2)
            {
                icon_index = 3;
            }
            else
            {
                icon_index = 0;
            }
            x_offset = -6;
            break;
        case "obj_chest":
            if (cost >= 1 && cost < 20)
            {
                icon_index = 1;
            }
            if (cost >= 20)
            {
                icon_index = 0;
            }
            if (opened == true)
            {
                disable_display = true;
            }
            break;
        case "obj_pickup_item_pickup":
            icon_index = 0;
            x_offset = -6;
            switch (sprite_index)
            {
                case spr_coin_pickup_bloody:
                    icon_index = 2;
                    break;
                case spr_pickup_key_bloody:
                    icon_index = 2;
                    break;
            }
            if (costs_crickets == true)
            {
                icon_index = 4;
            }
            break;
        case "obj_stone":
            if (cost == 1)
            {
                icon_index = 2;
            }
            x_offset = -6;
            break;
        case "obj_overworld_cauldron":
            icon_index = 5;
            if (global.bottles < global.magic_run_cost)
            {
                cost_color = global.color_red;
            }
            disable_display = true;
            break;
        case "obj_npc_new":
            icon_index = 5;
            if (global.bottles < 5)
            {
                cost_color = global.color_red;
            }
            break;
        case "obj_overworld_challenges_sign":
            icon_index = 5;
            if (global.bottles < global.challenge_run_cost)
            {
                cost_color = global.color_red;
            }
            y_offset = -35;
            break;
    }
    if (instance_exists(obj_player))
    {
        if (cost != 0 && disable_display == false)
        {
            if (collision_circle(x, y, 40, obj_player, false, false))
            {
                draw_sprite(icon, icon_index, (x - 3) + x_offset, y + y_offset + cost_yy);
                draw_set_halign(fa_left);
                draw_set_color(global.color_outline);
                draw_text_outline_2x(x + 3 + x_offset, y + y_offset + cost_yy, "-" + string(cost));
                draw_set_color(cost_color);
                draw_text(x + 3 + x_offset, y + y_offset + cost_yy, "-" + string(cost));
                draw_set_halign(fa_center);
                cost_yy += ((0 - cost_yy) * 0.2);
            }
            else
            {
                cost_yy = 4;
            }
        }
    }
}
