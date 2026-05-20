function get_player_sprites()
{
    switch (global.playable_characters_selected)
    {
        case 0:
            default_sprite_index = spr_player;
            outline_sprite_index = spr_player;
            reflection_sprite_index = spr_player;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_idle;
            shoot_sprite_index_right = spr_player_shoot_right;
            shoot_sprite_index_left = spr_player_shoot_left;
            hurt_sprite_index = spr_player_hurt;
            dead_sprite_index = spr_player_dead;
            happy_sprite_index = spr_player_happy;
            break;
        case 1:
            default_sprite_index = spr_player_2;
            outline_sprite_index = spr_player_2;
            reflection_sprite_index = spr_player_2;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_2_idle;
            shoot_sprite_index_right = spr_player_2_shoot_right;
            shoot_sprite_index_left = spr_player_2_shoot_left;
            hurt_sprite_index = spr_player_2_hurt;
            dead_sprite_index = spr_player_2_dead;
            happy_sprite_index = spr_player_2_happy;
            break;
        case 2:
            default_sprite_index = spr_player_3;
            outline_sprite_index = spr_player_3;
            reflection_sprite_index = spr_player_3;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_3_idle;
            shoot_sprite_index_right = spr_player_3_shoot_right;
            shoot_sprite_index_left = spr_player_3_shoot_left;
            hurt_sprite_index = spr_player_3_hurt;
            dead_sprite_index = spr_player_3_dead;
            happy_sprite_index = spr_player_3_happy;
            break;
        case 3:
            default_sprite_index = spr_player_4;
            outline_sprite_index = spr_player_4;
            reflection_sprite_index = spr_player_4;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_4_idle;
            shoot_sprite_index_right = spr_player_4_shoot_right;
            shoot_sprite_index_left = spr_player_4_shoot_left;
            hurt_sprite_index = spr_player_4_hurt;
            dead_sprite_index = spr_player_4_dead;
            happy_sprite_index = spr_player_4_happy;
            break;
        case 4:
            default_sprite_index = spr_player_5;
            outline_sprite_index = spr_player_5;
            reflection_sprite_index = spr_player_5;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_5_idle;
            shoot_sprite_index_right = spr_player_5_shoot_right;
            shoot_sprite_index_left = spr_player_5_shoot_left;
            hurt_sprite_index = spr_player_5_hurt;
            dead_sprite_index = spr_player_5_dead;
            happy_sprite_index = spr_player_5_happy;
            break;
        case 5:
            default_sprite_index = spr_player_6;
            outline_sprite_index = spr_player_6;
            reflection_sprite_index = spr_player_6;
            reflection_image_index = 0;
            idle_sprite_index = spr_player_6_idle;
            shoot_sprite_index_right = spr_player_6_shoot_right;
            shoot_sprite_index_left = spr_player_6_shoot_left;
            hurt_sprite_index = spr_player_6_hurt;
            dead_sprite_index = spr_player_6_dead;
            happy_sprite_index = spr_player_6_happy;
            break;
    }
}
