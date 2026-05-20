function main_menu_spawn_buttons()
{
    btn_yy = 4;
    if (global.start_tutorial_completion == 0)
    {
        var button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 5 + btn_yy, -999, obj_button_menu);
        button.button_index = 52;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 25 + btn_yy, -999, obj_button_menu);
        button.button_index = 2;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 45 + btn_yy, -999, obj_button_menu);
        button.button_index = 44;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 65 + btn_yy, -999, obj_button_menu);
        button.button_index = 3;
    }
    else
    {
        var button = instance_create_depth(room_width / 2, (((room_height / 2) + 15) - 15) + btn_yy, -999, obj_button_menu);
        button.button_index = 1;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 5 + btn_yy, -999, obj_button_menu);
        button.button_index = 53;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 25 + btn_yy, -999, obj_button_menu);
        button.button_index = 19;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 45 + btn_yy, -999, obj_button_menu);
        button.button_index = 2;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 65 + btn_yy, -999, obj_button_menu);
        button.button_index = 44;
        button = instance_create_depth(room_width / 2, (room_height / 2) + 15 + 85 + btn_yy, -999, obj_button_menu);
        button.button_index = 3;
    }
}
