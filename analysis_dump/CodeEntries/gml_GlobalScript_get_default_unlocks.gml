function get_default_unlocks()
{
    global.bottles = 0;
    for (var i = 0; i < global.fish_species_total; i += 1)
    {
        global.fishes_caught[i][0] = 0;
        global.fishes_caught[i][1] = 0;
    }
    for (var i = 0; i < global.unlocks_all_total; i += 1)
    {
        global.unlocks_all[i] = 0;
    }
    for (var i = 0; i < global.unlocks_total[0]; i += 1)
    {
        global.unlocks[0][i] = 2;
    }
    global.unlocks[0][0] = 0;
    global.unlocks[0][1] = 0;
    global.unlocks[0][9] = 0;
    global.unlocks[0][10] = 0;
    global.unlocks[0][11] = 0;
    global.unlocks[0][12] = 0;
    global.unlocks[0][13] = 0;
    global.unlocks[0][15] = 0;
    global.unlocks[0][16] = 0;
    global.unlocks[0][21] = 0;
    global.unlocks[0][22] = 0;
    global.unlocks[0][25] = 0;
    global.unlocks[0][27] = 0;
    global.unlocks[0][29] = 0;
    global.unlocks[0][30] = 0;
    global.unlocks[0][32] = 0;
    global.unlocks[0][34] = 0;
    global.unlocks[0][38] = 0;
    global.unlocks[0][41] = 0;
    global.unlocks[0][54] = 0;
    global.unlocks[0][57] = 0;
    global.unlocks[0][64] = 0;
    global.unlocks[0][76] = 0;
    global.unlocks[0][82] = 0;
    global.unlocks[0][87] = 0;
    global.unlocks[0][88] = 0;
    global.unlocks[0][94] = 0;
    global.unlocks[0][95] = 0;
    global.unlocks[0][96] = 0;
    global.unlocks[0][107] = 0;
}
