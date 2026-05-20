function get_free_direction()
{
    var closest_free_direction = 1000;
    var new_direction = direction;
    for (var i = 0; i < 8; i += 1)
    {
        var test_dir = 0 + (i * 45);
        var x_to_test = x + lengthdir_x(20, test_dir);
        var y_to_test = y + lengthdir_y(20, test_dir);
        if (!place_meeting(x_to_test, y_to_test, obj_solid) && !place_meeting(x_to_test, y_to_test, obj_solid_environment) && !place_meeting(x_to_test, y_to_test, obj_solid_half))
        {
            var distance_to_test_dir = point_distance(x, y, x_to_test, y_to_test);
            if (distance_to_test_dir < closest_free_direction)
            {
                closest_free_direction = distance_to_test_dir;
                new_direction = test_dir;
            }
        }
    }
    return new_direction;
}
