function shopkeeper_bought_animation()
{
    if (instance_exists(obj_shopkeeper_new))
    {
        with (obj_shopkeeper_new)
        {
            xscale_ext = -0.4;
            yscale_ext = 0.4;
            hand_visible = true;
            hand_index = 1;
            hand_yy = -7;
            alarm[1] = 60;
            laughing = true;
            alarm[2] = random_range(15, 30);
            alarm[3] = random_range(180, 220);
            image_speed = 0;
            sprite_index = spr_shopkeeper_laugh;
            image_index = choose(0, 1, 2);
            stuff_has_been_bought = true;
        }
    }
}
