function save_gif()
{
    var gif_length = 300;
    var now = date_current_datetime();
    var year = date_get_year(now);
    var month = date_get_month(now);
    var day = date_get_day(now);
    var hour = date_get_hour(now);
    var minute = date_get_minute(now);
    var second = date_get_second(now);
    var filename = string(year) + "-" + string(month, "00") + "-" + string(day, "00") + "_" + string(hour, "00") + "-" + string(minute, "00") + "-" + string(second, "00") + "-";
    if (count == 0)
    {
        gif_image = gif_open(room_width - 32, room_height - 32);
    }
    else if (count < gif_length)
    {
        gif_add_surface(gif_image, application_surface, 2, 0, 0, 2);
    }
    else
    {
        gif_save(gif_image, working_directory + "gifs/" + string(filename) + ".gif");
        count = 0;
        instance_destroy();
    }
    count += 1;
}
