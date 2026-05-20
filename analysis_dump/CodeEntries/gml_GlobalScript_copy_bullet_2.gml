function copy_bullet_2(arg0, arg1)
{
    b = -4;
    if (instance_exists(obj_player))
    {
        b = instance_create_depth(arg0, arg1, -1, obj_bullet);
        b.image_angle = random_range(-(global.weapon_spread * global.weapon_spread_multiplier), global.weapon_spread * global.weapon_spread_multiplier);
        b.direction = b.image_angle;
        b.image_xscale = random_range(1, 1.2);
        b.image_yscale = b.image_xscale;
        b.player_bullet = true;
        b.player_bullet_not_from_player = true;
        b.my_speed = (global.weapon_bullet_speed * global.bullet_speed_increase) + random_range(0, global.weapon_bullet_speed_offset);
        b.spd_decrease = global.weapon_bullet_speed_decrease;
        b.spd_decrease_offset = random_range(0, global.weapon_bullet_speed_decrease_offset);
        b.bullet_number = global.bullets_spawned_this_frame;
        b.dmg = (global.weapon_bullet_damage + global.bullet_damage_increase) * global.weapon_temporary_damage_multiplier * global.weapon_temporary_damage_multiplier_room;
        b.my_range = global.weapon_bullet_range;
        b.sprite_index = global.weapon_bullet_sprite;
        b.melee_attack = global.weapon_melee;
        b.my_spd_decrease = global.weapon_spd_decrease;
        b.my_knockback = global.weapon_knockback_enemy;
        b.from_player = true;
        global.bullets_spawned_this_frame += 1;
    }
    return b;
}
