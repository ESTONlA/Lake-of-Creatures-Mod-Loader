function is_challenge_unlocked(arg0)
{
    var unlocked = false;
    switch (arg0)
    {
        case 1:
            if (global.unlocks_all[19] >= 2)
            {
                unlocked = true;
            }
            break;
        case 2:
            if (global.unlocks_all[20] >= 2)
            {
                unlocked = true;
            }
            break;
        case 3:
            if (global.unlocks_all[21] >= 2)
            {
                unlocked = true;
            }
            break;
        case 4:
            if (global.unlocks_all[22] >= 2)
            {
                unlocked = true;
            }
            break;
        case 5:
            if (global.unlocks_all[23] >= 2)
            {
                unlocked = true;
            }
            break;
        case 6:
            if (global.unlocks_all[24] >= 2)
            {
                unlocked = true;
            }
            break;
        case 7:
            if (global.unlocks_all[25] >= 2)
            {
                unlocked = true;
            }
            break;
    }
    return unlocked;
}
