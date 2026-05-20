function enemy_deal_damage(arg0)
{
    if (arg0.is_laser == false)
    {
        oth = arg0;
        bullet_premature_destroy();
    }
    draw_color = 255;
    alarm[1] = 4;
    if (arg0.scatter_bullet_child == false)
    {
        if (arg0.knockback_direction_offset == 0)
        {
            knockback_len = 0;
            knockback_movement_len = 0;
            if (arg0.my_knockback != 0)
            {
                knockback_len = offset_knockback_enabled * (arg0.my_knockback + random_range(0, 3));
                knockback_movement_len = weight;
            }
            knockback_dir = arg0.direction;
            knockback_movement_dir = arg0.direction;
        }
        else
        {
            knockback_len = arg0.my_knockback + random_range(0, 3);
            knockback_dir = arg0.direction + arg0.knockback_direction_offset;
            if (offset_knockback_disabled_true == 0)
            {
                knockback_movement_dir = arg0.direction + arg0.knockback_direction_offset;
                knockback_movement_len = (weight + arg0.my_knockback) * arg0.knockback_speed_multiplier;
            }
        }
    }
    var animation = instance_create_depth(arg0.x + lengthdir_x(10, arg0.image_angle), arg0.y + lengthdir_y(10, arg0.image_angle), -50, obj_animation);
    animation.sprite_index = spr_hit_2;
    animation.image_angle = random_range(0, 360);
    animation.spin_spd = 8;
    animation.image_xscale = random_range(2, 3);
    animation.image_yscale = animation.image_xscale;
    hp -= arg0.dmg;
    start_moving = true;
    if (is_boss == false)
    {
        if (arg0.melee_attack == false)
        {
        }
        else
        {
            spd *= 0.6;
        }
    }
    else if (boss_started_attack == false && alarm[4] > 120)
    {
        alarm[4] = 120;
        boss_started_attack = true;
    }
    if (arg0.melee_attack == false)
    {
        if (arg0.burning_shot == false)
        {
            play_sound(1, arg0);
        }
        else
        {
        }
    }
    else
    {
        play_sound(7);
    }
    if (blood_splatter_cooldown <= 0)
    {
        enemy_splatter_blood(7, 10, arg0.x, arg0.y);
        blood_splatter_cooldown = 5;
    }
    if (arg0.burning_shot == true)
    {
        set_enemy_on_fire(-4);
    }
    if (arg0.fire_shot == true)
    {
        set_enemy_on_fire(-4);
    }
    if (arg0.stun_bullet == true)
    {
        spd = 0;
        stunned = 15;
    }
    if (arg0.freeze_bullet == true)
    {
        spd = 0;
        stunned = 120;
    }
    if (arg0.melee_attack == true)
    {
        global.melee_attack_hits_total += 1;
    }
    if (global.item_wet_gunpowder == true)
    {
        if (floor(random(11)) == 0)
        {
            animation = instance_create_depth(x + lengthdir_x(knockback_len, knockback_dir), y + lengthdir_y(knockback_len, knockback_dir), id.depth - 5, obj_animation);
            animation.sprite_index = spr_explosion;
            animation.image_xscale = 0.6;
            animation.image_yscale = animation.image_xscale;
            animation.image_xscale = 0.9;
            animation.image_yscale = animation.image_xscale;
            animation.target_xscale = 1;
            animation.target_yscale = 1;
            animation.image_speed = 0.4;
            animation.image_index = 2;
            animation.dmg = 1;
            animation.small_explosion_sound = true;
        }
    }
    if (arg0.piercing_bullet == true)
    {
        ds_list_add(arg0.hit_list, id);
    }
    if (arg0.melee_attack == true)
    {
        hit_melee = 1;
    }
    else
    {
        hit_bullet = 1;
    }
    enemy_specific_taking_damage(arg0);
    arg0.damaged_enemy = true;
    task_add(41);
    task_add(42);
    if (arg0.melee_attack == true)
    {
        task_add(56);
        task_add(57);
        if (hp <= 0)
        {
            task_add(78);
            task_add(79);
        }
    }
    if (arg0.piercing_bullet == false)
    {
        instance_destroy(arg0);
    }
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
