function shopkeeper_dialogue(arg0)
{
    if (instance_exists(obj_shopkeeper_new))
    {
        with (obj_shopkeeper_new)
        {
            switch (arg0)
            {
                case 0:
                    var text = choose(txt("shopkeeper_dialogue_hello_1"), txt("shopkeeper_dialogue_hello_2"), txt("shopkeeper_dialogue_hello_3"), txt("shopkeeper_dialogue_hello_4"));
                    text_popup_pinned(string(text), "", id);
                    alarm[1] = 1;
                    laughing = true;
                    alarm[2] = random_range(15, 30);
                    alarm[3] = random_range(40, 80);
                    image_speed = 0;
                    image_index = choose(0, 1, 2);
                    sprite_index = spr_shopkeeper_mock;
                    play_sound(105);
                    break;
                case 1:
                    if (stuff_has_been_bought == true)
                    {
                        var text = choose(txt("shopkeeper_dialogue_bye_1"), txt("shopkeeper_dialogue_sale_1"), txt("shopkeeper_dialogue_sale_2"), txt("shopkeeper_dialogue_sale_3"));
                        text_popup_pinned(string(text), "", id);
                        laughing = true;
                        alarm[2] = random_range(15, 30);
                        alarm[3] = random_range(90, 140);
                        image_speed = 0;
                        image_index = choose(0, 1, 2);
                        sprite_index = spr_shopkeeper_laugh;
                        play_sound(105);
                    }
                    else
                    {
                        var text = choose(txt("shopkeeper_dialogue_bye_2"), txt("shopkeeper_dialogue_bye_3"), txt("shopkeeper_dialogue_bye_4"));
                        text_popup_pinned(string(text), "", id);
                        laughing = true;
                        alarm[2] = random_range(15, 30);
                        alarm[3] = random_range(40, 80);
                        image_speed = 0;
                        image_index = choose(0, 1, 2);
                        sprite_index = spr_shopkeeper_mock;
                        achievement_get("NO_BUY");
                        play_sound(105);
                    }
                    break;
            }
        }
    }
}
