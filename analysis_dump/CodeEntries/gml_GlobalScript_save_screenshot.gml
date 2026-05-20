function save_screenshot(arg0)
{
    var now = date_current_datetime();
    var year = date_get_year(now);
    var month = date_get_month(now);
    var day = date_get_day(now);
    var hour = date_get_hour(now);
    var minute = date_get_minute(now);
    var second = date_get_second(now);
    var filename = string(year) + "-" + string(month, "00") + "-" + string(day, "00") + "_" + string(hour, "00") + "-" + string(minute, "00") + "-" + string(second, "00") + "-" + string(arg0) + ".png";
    var screenshot = screen_save(working_directory + "screenshots/" + filename);
}
