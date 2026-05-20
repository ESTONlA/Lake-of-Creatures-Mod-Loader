function __input_binding_get_label(arg0, arg1, arg2)
{
    switch (arg0)
    {
        case "key":
            return __input_key_get_name(arg1);
            break;
        case "mouse button":
            switch (arg1)
            {
                case 1:
                    return "Left Click";
                    break;
                case 3:
                    return "Middle Click";
                    break;
                case 2:
                    return "Right Click";
                    break;
                case 4:
                    return "Side 1 Mouse Click";
                    break;
                case 5:
                    return "Side 2 Mouse Click";
                    break;
                default:
                    return "mouse button unknown";
                    break;
            }
            break;
        case "mouse wheel up":
            return "Wheel Up";
            break;
        case "mouse wheel down":
            return "Wheel Down";
            break;
        case "gamepad button":
        case "gamepad axis":
            switch (arg1)
            {
                case 32769:
                    return "A";
                    break;
                case 32770:
                    return "B";
                    break;
                case 32771:
                    return "X";
                    break;
                case 32772:
                    return "Y";
                    break;
                case 32773:
                    return "L1";
                    break;
                case 32774:
                    return "R1";
                    break;
                case 32775:
                    return "L2";
                    break;
                case 32776:
                    return "R2";
                    break;
                case 32777:
                    return "SELECT";
                    break;
                case 32778:
                    return "START";
                    break;
                case 32779:
                    return "L Stick Click";
                    break;
                case 32780:
                    return "R Stick Click";
                    break;
                case 32781:
                    return "DPad Up";
                    break;
                case 32782:
                    return "DPad Down";
                    break;
                case 32783:
                    return "DPad Left";
                    break;
                case 32784:
                    return "DPad Right";
                    break;
                case 32889:
                    return "gamepad guide";
                    break;
                case 32890:
                    return "gamepad misc 1";
                    break;
                case 32891:
                    return "gamepad touchpad click";
                    break;
                case 32892:
                    return "gamepad paddle 1";
                    break;
                case 32893:
                    return "gamepad paddle 2";
                    break;
                case 32894:
                    return "gamepad paddle 3";
                    break;
                case 32895:
                    return "gamepad paddle 4";
                    break;
                case 32785:
                    return arg2 ? "Left" : "Right";
                    break;
                case 32786:
                    return arg2 ? "Up" : "Down";
                    break;
                case 32787:
                    return arg2 ? "Left" : "Right";
                    break;
                case 32788:
                    return arg2 ? "Up" : "Down";
                    break;
                default:
                    return "gamepad input unknown";
                    break;
            }
            break;
        default:
            return "binding unknown";
            break;
    }
}
