function perform_secondary_attack()
{
    switch (global.secondary_attack_array[global.secondary_attack_current])
    {
        case 0:
            var point_d = point_direction(x, y, mouse_x, mouse_y);
            torpedo = instance_create_depth(x + lengthdir_x(10, point_d), y + lengthdir_y(10, point_d), depth, obj_torpedo);
            torpedo.direction = point_d;
            torpedo.image_angle = point_d;
            torpedo.my_dmg = 15 + global.bullet_damage_increase;
            break;
        case 1:
            var point_d = point_direction(x, y, mouse_x, mouse_y);
            harpoon = instance_create_depth(x + lengthdir_x(10, point_d), y + lengthdir_y(10, point_d), depth, obj_harpoon);
            harpoon.direction = point_d;
            harpoon.image_angle = point_d;
            rope = instance_create_depth(x + lengthdir_x(10, point_d), y + lengthdir_y(10, point_d), -50, obj_common_rope_holder);
            rope.rope_index = 0;
            break;
    }
    global.secondary_attack_current += 1;
}
