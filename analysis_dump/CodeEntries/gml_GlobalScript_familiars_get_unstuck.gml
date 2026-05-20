function familiars_get_unstuck()
{
    if (place_meeting(x, y, obj_item_rubber_duck))
    {
        get_unstuck(obj_item_rubber_duck);
    }
    if (place_meeting(x, y, obj_item_water_bucket))
    {
        get_unstuck(obj_item_water_bucket);
    }
    if (place_meeting(x, y, obj_item_sea_tumor))
    {
        get_unstuck(obj_item_sea_tumor);
    }
}
