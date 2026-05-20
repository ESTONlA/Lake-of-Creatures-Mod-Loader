function enemy_deal_damage_from_player(arg0)
{
    draw_color = 255;
    alarm[1] = 4;
    animation = instance_create_depth(x + lengthdir_x(10, image_angle), y + lengthdir_y(10, image_angle), -50, obj_animation);
    animation.sprite_index = spr_hit_2;
    animation.image_angle = random_range(0, 360);
    animation.spin_spd = 8;
    animation.image_xscale = random_range(2, 3);
    animation.image_yscale = animation.image_xscale;
    hp -= arg0;
    start_moving = true;
    hurt_timer = 60;
    enemy_splatter_blood(7, 10, x, y);
    if (interacted == 0)
    {
        interacted = 1;
        switch (img_angle_alter_when_hurt)
        {
            case 0:
                shake_intensivity = random_range(0.8, 1.2);
                break;
            case 1:
                img_angle = random_range(-15, 15);
                shake_intensivity = random_range(0.8, 1.2);
                break;
            case 2:
                img_angle = random_range(0, 360);
                shake_intensivity = random_range(0.8, 1.2);
                break;
            case 3:
                img_angle += choose(-70, -60, 60, 70);
                shake_intensivity = random_range(1.8, 2);
                break;
        }
        alarm[0] = 30;
    }
}
