function __input_gamepad_set_type()
{
    switch (0)
    {
        case 21:
            switch (description)
            {
                case "Handheld":
                    raw_type = "SwitchHandheld";
                    break;
                case "Pro Controller":
                    raw_type = "SwitchProController";
                    break;
                case "Joy-Con (L)":
                    raw_type = "SwitchJoyConLeft";
                    break;
                case "Joy-Con (R)":
                    raw_type = "SwitchJoyConRight";
                    break;
                case "Joy-Con":
                default:
                    raw_type = "SwitchJoyConPair";
                    break;
            }
            guessed_type = false;
            break;
        case 14:
            raw_type = "PS4Controller";
            guessed_type = false;
            break;
        case 22:
            raw_type = "PS5Controller";
            guessed_type = false;
            break;
        case 15:
        case 23:
            raw_type = "XBoxOneController";
            guessed_type = false;
            break;
        case 24:
            if (description == "Pro Controller (")
            {
                raw_type = "SwitchProController";
                guessed_type = false;
            }
            else if (description == "Joy-Con L+R (STA")
            {
                raw_type = "SwitchJoyConPair";
                guessed_type = false;
            }
            else if (description == "Wireless Control")
            {
                raw_type = "CommunityPS4";
                guessed_type = true;
            }
            else if (description == "Xbox 360 Control")
            {
                raw_type = "CommunityLikeXBox";
                guessed_type = true;
            }
            if (raw_type != undefined)
            {
                break;
            }
        default:
            var _irregular_guid = (vendor + product) == "";
            if (xinput == true)
            {
                raw_type = "CommunityLikeXBox";
                guessed_type = true;
            }
            else if (variable_struct_exists(global.__input_raw_type_dictionary, vendor + product))
            {
                raw_type = variable_struct_get(global.__input_raw_type_dictionary, vendor + product);
                guessed_type = false;
            }
            else
            {
                guessed_type = true;
                if (_irregular_guid)
                {
                    __input_trace("Warning! VID+PID not found. Guessing controller type based on description = \"", description, "\"");
                }
                else
                {
                    __input_trace("Warning! VID+PID \"", vendor + product, "\" not found in raw type database. Guessing controller type based on description = \"", description, "\"");
                }
                var _desc = string_lower(description);
                if (__input_string_contains(_desc, "8bitdo"))
                {
                    raw_type = "Community8BitDo";
                }
                else if (__input_string_contains(_desc, "snes"))
                {
                    raw_type = "CommunitySNES";
                }
                else if (__input_string_contains(_desc, "saturn"))
                {
                    raw_type = "CommunitySaturn";
                }
                else if (__input_string_contains(_desc, "stadia"))
                {
                    raw_type = "CommunityStadia";
                }
                else if (__input_string_contains(_desc, "luna", "amazon game"))
                {
                    raw_type = "CommunityLuna";
                }
                else if (__input_string_contains(_desc, "ouya"))
                {
                    raw_type = "CommunityOuya";
                }
                else if (__input_string_contains(_desc, "steam"))
                {
                    raw_type = "SteamController";
                }
                else if (__input_string_contains(_desc, "ps5", "dualsense"))
                {
                    raw_type = "PS5Controller";
                }
                else if (__input_string_contains(_desc, "ps4", "dualshock 4", "sony interactive entertainment wireless controller"))
                {
                    raw_type = "CommunityPS4";
                }
                else if (__input_string_contains(_desc, "playstation", "ps1", "ps2", "ps3", "dualshock"))
                {
                    raw_type = "CommunityPSX";
                }
                else if (__input_string_contains(_desc, "for switch", "for nintendo switch", "switch controller", "switch pro controller", "lic pro controller"))
                {
                    raw_type = "CommunityLikeSwitch";
                }
                else if (__input_string_contains(_desc, "joy-con (l/r)"))
                {
                    raw_type = "SwitchJoyConPair";
                }
                else if (__input_string_contains(_desc, "joy-con (l)", "left joy-con"))
                {
                    raw_type = "SwitchJoyConLeft";
                }
                else if (__input_string_contains(_desc, "joy-con (r)", "right joy-con"))
                {
                    raw_type = "SwitchJoyConRight";
                }
                else if (__input_string_contains(_desc, "gamecube"))
                {
                    raw_type = "CommunityGameCube";
                }
                else if (__input_string_contains(_desc, "xbox elite", "xbox wireless", "xbox one", "xbox bluetooth"))
                {
                    raw_type = "CommunityXBoxOne";
                }
                else if (__input_string_contains(_desc, "xbox 360", "xbox360"))
                {
                    raw_type = "CommunityXBox360";
                }
                else if (__input_string_contains(_desc, "xbox"))
                {
                    raw_type = "CommunityLikeXBox";
                }
                else if (false || __input_string_contains(_desc, "nimbus", "horipad ultimate", "mfi"))
                {
                    raw_type = "AppleController";
                }
                else
                {
                    raw_type = "Unknown";
                }
            }
            if (vendor == "0d00" && product == "0000" && button_count == 15 && axis_count == 4 && hat_count == 0 && true)
            {
                __input_trace("Overriding gamepad type to MFi");
                description = "MFi Extended";
                raw_type = "AppleController";
                guessed_type = false;
            }
            if (vendor == "6325" && product == "7505")
            {
                if ((true && gamepad_get_description(index) == "USB ") || (false && gamepad_get_description(index) == "GHICCod USB Gamepad") || (false && guid == "03000000632500007505000000020000"))
                {
                    __input_trace("Overriding gamepad type to NeoGeo Mini");
                    description = "NeoGeo Mini";
                    raw_type = "CommunityNeoGeoMini";
                    guessed_type = false;
                }
                if ((true && gamepad_get_description(index) == "Controller (Dinput)") || (false && gamepad_get_description(index) == "SWITCH CO.,LTD. Controller (Dinput)"))
                {
                    __input_trace("Overriding gamepad type to N64");
                    description = "N64";
                    raw_type = "CommunityN64";
                    guessed_type = false;
                }
            }
            break;
    }
    if (variable_struct_exists(global.__input_simple_type_lookup, raw_type))
    {
        simple_type = variable_struct_get(global.__input_simple_type_lookup, raw_type);
    }
    else
    {
        simple_type = "unknown";
        __input_trace("Warning! Raw type \"", raw_type, "\" not found in lookup table, setting simple type to \"", simple_type, "\"");
    }
}
