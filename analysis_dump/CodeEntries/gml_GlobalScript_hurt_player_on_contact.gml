function hurt_player_on_contact()
{
    if (place_meeting(x, y, obj_player))
    {
        player_hurt(dmg_to_deal);
        if (global.item_thorn_vest == true && visible == true && can_take_damage == true && hurt_timer <= 0)
        {
            enemy_deal_damage_from_player(6 + global.bullet_damage_increase);
            if (global.item_pull_shot == true)
            {
                if (instance_exists(obj_player))
                {
                    var pull_dir = point_direction(x, y, obj_player.x, obj_player.y);
                    knockback_len = 5;
                    knockback_dir = pull_dir;
                    knockback_movement_dir = pull_dir;
                    knockback_movement_len = 5;
                }
            }
        }
    }
}
