function get_cursor_hover()
{
    if (global.navigation_style == 1)
    {
        return collision_circle(mouse_x, mouse_y, 1, id, 0, 0);
    }
    if (global.navigation_style == 2)
    {
        if (instance_exists(obj_navigator))
        {
            return collision_circle(obj_navigator.x, obj_navigator.y, 1, id, 0, 0);
        }
        else
        {
        }
    }
}
