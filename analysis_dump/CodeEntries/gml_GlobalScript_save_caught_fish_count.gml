function save_caught_fish_count()
{
    var total_fish = global.lake_array[global.current_lake].fishes_total_this_lake;
    global.fish_caught_in_lake[global.current_lake] = global.total_fish_caught_this_area;
    global.fish_exist_in_lake[global.current_lake] = total_fish;
}
