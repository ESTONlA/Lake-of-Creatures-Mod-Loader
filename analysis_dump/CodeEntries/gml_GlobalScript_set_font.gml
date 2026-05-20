function set_font()
{
    global.font_fish_rarity_yy = 0;
    global.font_currency_icon_xx = 0;
    global.font_unlock_total_number_xx = 0;
    global.font_slider_text_xx = 0;
    global.font_currency_text_xx = 0;
    global.font_newspaper_start_yy = 0;
    global.font_newspaper_yy = 0;
    global.tip_1_yy = 0;
    global.tip_3_yy = 0;
    global.font_option_1_xx = 0;
    global.font_option_2_xx = 0;
    global.font_stat_xx = 0;
    if (global.locale == UnknownEnum.Value_1)
    {
        global.font_current = font_chinese;
        global.font_fish_rarity_yy = 4;
        global.font_currency_icon_xx = -10;
        global.font_unlock_total_number_xx = 0;
        global.font_slider_text_xx = 6;
        global.font_currency_text_xx = -3;
        global.font_newspaper_start_yy = -17;
        global.font_newspaper_yy = 8;
        global.tip_1_yy = -6;
        global.tip_3_yy = 6;
    }
    else
    {
        global.font_current = font_hope_gold;
        if (global.locale == UnknownEnum.Value_3)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_2)
        {
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_5)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_6)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_7)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_8)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_9)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
        if (global.locale == UnknownEnum.Value_4)
        {
            global.font_option_1_xx = -15;
            global.font_option_2_xx = 25;
            global.font_stat_xx = 46;
            global.font_current = font_foreign;
        }
    }
}

enum UnknownEnum
{
    Value_1 = 1,
    Value_2,
    Value_3,
    Value_4,
    Value_5,
    Value_6,
    Value_7,
    Value_8,
    Value_9
}
