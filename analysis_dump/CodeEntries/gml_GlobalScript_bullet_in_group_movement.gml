function bullet_in_group_movement()
{
    if (in_group)
    {
        if (group_id != -4)
        {
            var my_x_in_group = group_id.x + lengthdir_x(group_id.bullet_offset_from_center, group_id.offset_direction + group_id.bullet_direction_in_group[my_id_in_group]);
            var my_y_in_group = group_id.y + lengthdir_y(group_id.bullet_offset_from_center, group_id.offset_direction + group_id.bullet_direction_in_group[my_id_in_group]);
            image_angle = point_direction(x, y, my_x_in_group, my_y_in_group);
            x += approach(x, my_x_in_group, 0.3);
            y += approach(y, my_y_in_group, 0.3);
        }
        else
        {
            in_group = false;
        }
    }
}
