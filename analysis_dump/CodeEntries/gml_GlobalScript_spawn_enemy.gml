function spawn_enemy(arg0, arg1)
{
    switch (arg1)
    {
        case 1:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_test_dummy;
            obj.image_xscale = choose(-1, 1);
            obj.natural_spawn = arg0;
            obj.enemy_index = 0;
            break;
        case 2:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_crocodile;
            obj.natural_spawn = arg0;
            obj.enemy_index = 1;
            break;
        case 3:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_test_dummy;
            obj.image_xscale = choose(-1, 1);
            obj.natural_spawn = arg0;
            obj.enemy_index = 2;
            break;
        case 4:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider;
            obj.natural_spawn = arg0;
            obj.enemy_index = 3;
            break;
        case 5:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_big;
            obj.natural_spawn = arg0;
            obj.enemy_index = 4;
            break;
        case 6:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_nest;
            obj.natural_spawn = arg0;
            obj.enemy_index = 5;
            break;
        case 7:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_dove_idle;
            obj.natural_spawn = arg0;
            obj.enemy_index = 6;
            break;
        case 8:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_turtle_idle;
            obj.natural_spawn = arg0;
            obj.enemy_index = 7;
            break;
        case 9:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 8;
            break;
        case 10:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_slug;
            obj.natural_spawn = arg0;
            obj.enemy_index = 9;
            break;
        case 11:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_boss_toad;
            obj.natural_spawn = arg0;
            obj.enemy_index = 10;
            break;
        case 12:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_tentacle;
            obj.natural_spawn = arg0;
            obj.enemy_index = 11;
            break;
        case 13:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_maggot;
            obj.natural_spawn = arg0;
            obj.enemy_index = 12;
            break;
        case 14:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_raven_idle;
            obj.natural_spawn = arg0;
            obj.enemy_index = 13;
            break;
        case 15:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_mushroom;
            obj.natural_spawn = arg0;
            obj.enemy_index = 14;
            break;
        case 16:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_beetle;
            obj.natural_spawn = arg0;
            obj.enemy_index = 15;
            break;
        case 17:
            instance_create_depth(random_range(0, 480), random_range(0, 270), 0, obj_skull);
            break;
        case 18:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_boss_alligator;
            obj.natural_spawn = arg0;
            obj.enemy_index = 16;
            break;
        case 19:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 17;
            break;
        case 20:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 18;
            break;
        case 21:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 19;
            break;
        case 22:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 20;
            break;
        case 23:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 21;
            break;
        case 24:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 22;
            break;
        case 25:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider;
            obj.natural_spawn = arg0;
            obj.enemy_index = 23;
            break;
        case 26:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_frog_1;
            obj.natural_spawn = arg0;
            obj.enemy_index = 24;
            break;
        case 27:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider;
            obj.natural_spawn = arg0;
            obj.enemy_index = 25;
            break;
        case 28:
            break;
        case 29:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_beak;
            obj.natural_spawn = arg0;
            obj.enemy_index = 27;
            break;
        case 30:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_boss_monster_body;
            obj.natural_spawn = arg0;
            obj.enemy_index = 29;
            break;
        case 31:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_starfish;
            obj.natural_spawn = arg0;
            obj.enemy_index = 33;
            break;
        case 32:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 34;
            break;
        case 33:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_boss_eye;
            obj.natural_spawn = arg0;
            obj.enemy_index = 35;
            break;
        case 34:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_fourleg;
            obj.natural_spawn = arg0;
            obj.enemy_index = 37;
            break;
        case 35:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 38;
            break;
            break;
        case 36:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 39;
            break;
            break;
        case 37:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 40;
            break;
            break;
        case 38:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 41;
            break;
        case 39:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 42;
            break;
        case 40:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 43;
            break;
        case 41:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 44;
            break;
        case 42:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 28;
            break;
        case 43:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 45;
            break;
        case 44:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_enemy_waterspider_green;
            obj.natural_spawn = arg0;
            obj.enemy_index = 46;
            break;
        case 45:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 47;
            break;
        case 46:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 48;
            break;
        case 47:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 49;
            break;
        case 48:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 50;
            break;
        case 49:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 51;
            break;
        case 50:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.sprite_index = spr_npc_mayor;
            obj.natural_spawn = arg0;
            obj.enemy_index = 52;
            break;
        case 51:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 54;
            break;
        case 52:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 55;
            break;
        case 53:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 56;
            break;
        case 54:
            obj = instance_create_layer(mouse_x, mouse_y, "Instances", obj_enemy);
            obj.natural_spawn = arg0;
            obj.enemy_index = 57;
            break;
    }
}
