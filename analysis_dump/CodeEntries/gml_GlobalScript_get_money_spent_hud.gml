function get_money_spent_hud(arg0, arg1)
{
    if (instance_exists(obj_spent_money_hud))
    {
        with (obj_spent_money_hud)
        {
            fadeout = false;
            alarm[0] = 180;
            yy = 3;
            image_alpha = 1;
            spent_amount += arg0;
            draw_color = 16777215;
            alarm[1] = 3;
            if (yy_ext != arg1)
            {
                spent_amount = arg0;
                yy_ext = arg1;
            }
        }
    }
    else
    {
        o = instance_create_depth(0, 0, -1100, obj_spent_money_hud);
        o.spent_amount = arg0;
        o.yy_ext = arg1;
    }
}
