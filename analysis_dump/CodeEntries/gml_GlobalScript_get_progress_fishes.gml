function get_progress_fishes()
{
    var progress = 0;
    for (var i = 0; i < global.fish_species_total; i += 1)
    {
        if (global.fish_that_have_been_caught[i] > 0)
        {
            progress += 1;
        }
    }
    return progress;
}
