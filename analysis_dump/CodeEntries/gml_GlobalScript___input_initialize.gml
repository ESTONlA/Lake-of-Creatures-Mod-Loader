__input_initialize();

function __input_initialize()
{
    if (variable_global_exists("__input_initialization_phase"))
    {
        return false;
    }
    global.__input_initialization_phase = "Pending";
    global.__input_debug_log = "input___" + string_replace_all(string_replace_all(date_datetime_string(date_current_datetime()), ":", "-"), " ", "___") + ".txt";
    __input_trace("Welcome to Input by @jujuadams and @offalynne! This is version ", "5.2.0 beta 3", ", ", "2022-09-28");
    try
    {
        global.__input_time_source = time_source_create(time_source_global, 1, time_source_units_frames, function()
        {
            __input_system_tick();
        }, [], -1);
        time_source_start(global.__input_time_source);
    }
    catch (_error)
    {
        try
        {
            global.__input_time_source = time_source_create(time_source_global, 1, time_source_units_frames, function()
            {
                __input_system_tick();
            }, -1);
            time_source_start(global.__input_time_source);
        }
        catch (_error)
        {
            global.__input_time_source = undefined;
            __input_trace("Warning! Running on a GM runtime earlier than 2022.5");
        }
    }
    global.__input_frame = 0;
    global.__input_current_time = current_time;
    global.__input_previous_current_time = current_time;
    global.__input_cleared = false;
    global.__input_window_focus = true;
    global.__input_toggle_momentary_dict = {};
    global.__input_toggle_momentary_state = false;
    global.__input_cooldown_dict = {};
    global.__input_cooldown_state = false;
    global.__input_tap_presses = 0;
    global.__input_tap_releases = 0;
    global.__input_tap_click = false;
    global.__input_pointer_index = 0;
    global.__input_pointer_pressed = false;
    global.__input_pointer_released = false;
    global.__input_pointer_pressed_index = undefined;
    global.__input_pointer_durations = array_create(11, 0);
    global.__input_pointer_coord_space = UnknownEnum.Value_0;
    global.__input_pointer_x = array_create(UnknownEnum.Value_3, 0);
    global.__input_pointer_y = array_create(UnknownEnum.Value_3, 0);
    global.__input_pointer_dx = array_create(UnknownEnum.Value_3, 0);
    global.__input_pointer_dy = array_create(UnknownEnum.Value_3, 0);
    global.__input_pointer_moved = false;
    global.__input_mouse_capture = false;
    global.__input_mouse_capture_sensitivity = false;
    global.__input_mouse_capture_frame = 0;
    global.__input_strict_binding_check = false;
    global.__input_any_keyboard_binding_defined = false;
    global.__input_any_mouse_binding_defined = false;
    global.__input_any_gamepad_binding_defined = false;
    global.__input_keyboard_allowed = true;
    global.__input_mouse_allowed_on_platform = 1;
    global.__input_vibration_allowed_on_platform = true;
    global.__input_window_focus_block_mouse = false;
    global.__input_cursor_verbs_valid = false;
    global.__input_swap_ab = false;
    global.__input_all_verb_dict = {};
    global.__input_all_verb_array = [];
    global.__input_basic_verb_dict = {};
    global.__input_basic_verb_array = [];
    global.__input_chord_verb_dict = {};
    global.__input_chord_verb_array = [];
    global.__input_combo_verb_dict = {};
    global.__input_combo_verb_array = [];
    global.__input_key_name_dict = {};
    global.__input_ignore_key_dict = {};
    global.__input_ignore_gamepad_types = {};
    global.__input_players_status = 
    {
        any_changed: false,
        new_connections: [],
        new_disconnections: [],
        players: array_create(4, UnknownEnum.Value_0)
    };
    global.__input_gamepads_status = 
    {
        any_changed: false,
        new_connections: [],
        new_disconnections: [],
        gamepads: array_create(12, UnknownEnum.Value_0)
    };
    global.__input_default_player = new __input_class_player();
    global.__input_players = array_create(4, undefined);
    var _p = 0;
    repeat (4)
    {
        with (new __input_class_player())
        {
            array_set(global.__input_players, _p, self);
            __index = _p;
        }
        _p++;
    }
    global.__input_source_mode = undefined;
    global.__input_previous_source_mode = UnknownEnum.Value_2;
    global.__input_multiplayer_min = 1;
    global.__input_multiplayer_max = 4;
    global.__input_multiplayer_drop_down = true;
    global.__input_multiplayer_allow_abort = true;
    global.__input_gamepads = array_create(12, undefined);
    global.__input_sdl2_database = 
    {
        by_guid: {},
        by_vendor_product: {}
    };
    global.__input_sdl2_look_up_table = 
    {
        a: 32769,
        b: 32770,
        x: 32771,
        y: 32772,
        dpup: 32781,
        dpdown: 32782,
        dpleft: 32783,
        dpright: 32784,
        leftx: 32785,
        lefty: 32786,
        rightx: 32787,
        righty: 32788,
        leftshoulder: 32773,
        rightshoulder: 32774,
        lefttrigger: 32775,
        righttrigger: 32776,
        leftstick: 32779,
        rightstick: 32780,
        start: 32778,
        back: 32777
    };
    global.__input_sdl2_look_up_table.guide = 32889;
    global.__input_sdl2_look_up_table.misc1 = 32890;
    global.__input_sdl2_look_up_table.touchpad = 32891;
    global.__input_sdl2_look_up_table.paddle1 = 32892;
    global.__input_sdl2_look_up_table.paddle2 = 32893;
    global.__input_sdl2_look_up_table.paddle3 = 32894;
    global.__input_sdl2_look_up_table.paddle4 = 32895;
    if (file_exists("sdl2.txt"))
    {
        __input_load_sdl2_from_file("sdl2.txt");
    }
    else
    {
        __input_trace("Warning! \"", "sdl2.txt", "\" not found in Included Files");
    }
    var _default_xbox_type = "xbox one";
    global.__input_simple_type_lookup = 
    {
        CommunityLikeXBox: _default_xbox_type,
        XBoxOneController: "xbox one",
        CommunityXBoxOne: "xbox one",
        SteamControllerV2: "xbox one",
        CommunityDeck: "xbox one",
        CommunityLuna: "xbox one",
        CommunityStadia: "xbox one",
        AppleController: "xbox one",
        XBox360Controller: "xbox 360",
        CommunityXBox360: "xbox 360",
        CommunityDreamcast: "xbox 360",
        SteamController: "xbox 360",
        MobileTouch: "xbox 360",
        PS5Controller: "ps5",
        PS4Controller: "ps4",
        XInputPS4Controller: "ps4",
        CommunityPS4: "ps4",
        PS3Controller: "psx",
        CommunityPSX: "psx",
        SwitchHandheld: "switch",
        SwitchJoyConPair: "switch",
        SwitchProController: "switch",
        XInputSwitchController: "switch",
        SwitchInputOnlyController: "switch",
        CommunityLikeSwitch: "switch",
        Community8BitDo: "switch",
        HIDWiiClassic: "switch",
        SwitchJoyConLeft: "switch joycon left",
        HIDJoyConLeft: "switch joycon left",
        SwitchJoyConRight: "switch joycon right",
        HIDJoyConRight: "switch joycon right",
        CommunityGameCube: "gamecube",
        CommunityN64: "n64",
        CommunitySaturn: "saturn",
        CommunitySNES: "snes",
        CommunitySuperFamicom: "snes",
        Unknown: "unknown",
        unknown: "unknown",
        UnknownNonSteamController: "unknown",
        CommunityUnknown: "unknown",
        CommunitySteam: "unknown"
    };
    global.__input_raw_type_dictionary = {};
    global.__input_raw_type_dictionary.none = _default_xbox_type;
    if (file_exists("controllertypes.csv"))
    {
        __input_load_type_csv("controllertypes.csv");
    }
    else
    {
        __input_trace("Warning! \"", "controllertypes.csv", "\" not found in Included Files");
    }
    global.__input_blacklist_dictionary = {};
    if (file_exists("controllerblacklist.csv"))
    {
        __input_load_blacklist_csv("controllerblacklist.csv");
    }
    else
    {
        __input_trace("Warning! \"", "controllerblacklist.csv", "\" not found in Included Files");
    }
    __input_key_name_set(192, "`");
    __input_key_name_set(189, "-");
    __input_key_name_set(187, "=");
    __input_key_name_set(186, ";");
    __input_key_name_set(222, "'");
    __input_key_name_set(188, ",");
    __input_key_name_set(190, ".");
    __input_key_name_set(221, "]");
    __input_key_name_set(219, "[");
    __input_key_name_set(191, "/");
    __input_key_name_set(220, "\\");
    __input_key_name_set(145, "SCROLL LOCK");
    __input_key_name_set(20, "CAPS LOCK");
    __input_key_name_set(144, "NUM LOCK");
    __input_key_name_set(91, "LEFT META");
    __input_key_name_set(92, "RIGHT META");
    __input_key_name_set(12, "CLEAR");
    __input_key_name_set(93, "MENU");
    __input_key_name_set(44, "PRINT SCREEN");
    __input_key_name_set(19, "PAUSE BREAK");
    __input_key_name_set(27, "ESCAPE");
    __input_key_name_set(8, "BACKSPACE");
    __input_key_name_set(32, "SPACE");
    __input_key_name_set(13, "ENTER");
    __input_key_name_set(38, "Up");
    __input_key_name_set(40, "Down");
    __input_key_name_set(37, "Left");
    __input_key_name_set(39, "Right");
    __input_key_name_set(9, "TAB");
    __input_key_name_set(165, "RIGHT ALT");
    __input_key_name_set(164, "LEFT ALT");
    __input_key_name_set(18, "ALT");
    __input_key_name_set(161, "RIGHT SHIFT");
    __input_key_name_set(160, "LEFT SHIFT");
    __input_key_name_set(16, "SHIFT");
    __input_key_name_set(163, "RIGHT CTRL");
    __input_key_name_set(162, "LEFT CTRL");
    __input_key_name_set(17, "CTRL");
    __input_key_name_set(112, "F1");
    __input_key_name_set(113, "F2");
    __input_key_name_set(114, "F3");
    __input_key_name_set(115, "F4");
    __input_key_name_set(116, "F5");
    __input_key_name_set(117, "F6");
    __input_key_name_set(118, "F7");
    __input_key_name_set(119, "F8");
    __input_key_name_set(120, "F9");
    __input_key_name_set(121, "F10");
    __input_key_name_set(122, "F11");
    __input_key_name_set(123, "F12");
    __input_key_name_set(111, "NUMPAD /");
    __input_key_name_set(106, "NUMPAD *");
    __input_key_name_set(109, "NUMPAD -");
    __input_key_name_set(107, "NUMPAD +");
    __input_key_name_set(110, "NUMPAD .");
    __input_key_name_set(96, "NUMPAD 0");
    __input_key_name_set(97, "NUMPAD 1");
    __input_key_name_set(98, "NUMPAD 2");
    __input_key_name_set(99, "NUMPAD 3");
    __input_key_name_set(100, "NUMPAD 4");
    __input_key_name_set(101, "NUMPAD 5");
    __input_key_name_set(102, "NUMPAD 6");
    __input_key_name_set(103, "NUMPAD 7");
    __input_key_name_set(104, "NUMPAD 8");
    __input_key_name_set(105, "NUMPAD 9");
    __input_key_name_set(46, "DELETE");
    __input_key_name_set(45, "INSERT");
    __input_key_name_set(36, "HOME");
    __input_key_name_set(33, "PAGE UP");
    __input_key_name_set(34, "PAGE DOWN");
    __input_key_name_set(35, "END");
    __input_key_name_set(10, variable_struct_get(global.__input_key_name_dict, 13));
    for (var _i = 124; _i < 144; _i++)
    {
        __input_key_name_set(_i, "f" + string(_i));
    }
    input_ignore_key_add(18);
    input_ignore_key_add(165);
    input_ignore_key_add(164);
    input_ignore_key_add(91);
    input_ignore_key_add(92);
    input_ignore_key_add(255);
    input_ignore_key_add(144);
    input_ignore_key_add(145);
    input_ignore_key_add(21);
    input_ignore_key_add(22);
    input_ignore_key_add(23);
    input_ignore_key_add(24);
    input_ignore_key_add(25);
    input_ignore_key_add(26);
    input_ignore_key_add(28);
    input_ignore_key_add(29);
    input_ignore_key_add(30);
    input_ignore_key_add(31);
    input_ignore_key_add(229);
    input_ignore_key_add(166);
    input_ignore_key_add(167);
    input_ignore_key_add(168);
    input_ignore_key_add(169);
    input_ignore_key_add(170);
    input_ignore_key_add(171);
    input_ignore_key_add(172);
    input_ignore_key_add(173);
    input_ignore_key_add(174);
    input_ignore_key_add(175);
    input_ignore_key_add(176);
    input_ignore_key_add(177);
    input_ignore_key_add(178);
    input_ignore_key_add(179);
    input_ignore_key_add(180);
    input_ignore_key_add(181);
    input_ignore_key_add(182);
    input_ignore_key_add(183);
    input_ignore_key_add(251);
    global.__input_on_steam_deck = false;
    if (false && !global.__input_on_steam_deck)
    {
        var _os = "linux";
        var _id = "03000000de280000ff11000001000000";
        var _blacklist_os = is_struct(global.__input_blacklist_dictionary) ? variable_struct_get(global.__input_blacklist_dictionary, _os) : undefined;
        var _blacklist_id = is_struct(_blacklist_os) ? struct_get_from_hash(_blacklist_os, variable_get_hash("guid")) : undefined;
        if (is_struct(_blacklist_os) && _blacklist_id == undefined)
        {
            _blacklist_os.guid = {};
            _blacklist_id = is_struct(_blacklist_os) ? struct_get_from_hash(_blacklist_os, variable_get_hash("guid")) : undefined;
        }
        if (is_struct(_blacklist_id))
        {
            variable_struct_set(_blacklist_id, _id, true);
        }
    }
    var _locale = os_get_language() + "-" + os_get_region();
    switch (_locale)
    {
        case "en-US":
        case "en-":
        case "en-GB":
        case "-":
            global.__input_keyboard_locale = "QWERTY";
            break;
        case "ar-DZ":
        case "ar-MA":
        case "ar-TN":
        case "fr-BE":
        case "fr-FR":
        case "fr-MC":
        case "co-FR":
        case "oc-FR":
        case "ff-SN":
        case "wo-SN":
        case "gsw-FR":
        case "nl-BE":
        case "tzm-DZ":
            global.__input_keyboard_locale = "AZERTY";
            break;
        case "cs-CZ":
        case "de-AT":
        case "de-CH":
        case "de-DE":
        case "de-LI":
        case "de-LU":
        case "fr-CH":
        case "fr-LU":
        case "sq-AL":
        case "hr-BA":
        case "hr-HR":
        case "hu-HU":
        case "lb-LU":
        case "rm-CH":
        case "sk-SK":
        case "sl-SI":
        case "dsb-DE":
        case "sr-BA":
        case "hsb-DE":
            global.__input_keyboard_locale = "QWERTZ";
            break;
        default:
            global.__input_keyboard_locale = "QWERTY";
            break;
    }
    global.__input_keyboard_type = "keyboard";
    device_mouse_dbclick_enable(false);
    global.__input_profile_array = undefined;
    global.__input_profile_dict = undefined;
    global.__input_default_profile_dict = undefined;
    global.__input_verb_to_group_dict = {};
    global.__input_group_to_verbs_dict = {};
    global.__input_verb_group_array = [];
    global.__input_null_binding = input_binding_empty();
    global.__input_icons = {};
    global.__input_source_keyboard = new __input_class_source(UnknownEnum.Value_0);
    global.__input_source_mouse = global.__input_source_keyboard;
    global.__input_source_gamepad = array_create(12, undefined);
    var _g = 0;
    repeat (12)
    {
        array_set(global.__input_source_gamepad, _g, new __input_class_source(UnknownEnum.Value_2, _g));
        _g++;
    }
    global.__input_initialization_phase = "__input_finalize_default_profiles";
    __input_config_profiles_and_default_bindings();
    global.__input_initialization_phase = "__input_finalize_verb_groups";
    __input_config_verbs();
    input_source_mode_set(UnknownEnum.Value_2);
    __input_validate_macros();
    global.__input_initialization_phase = "Complete";
    return true;
}

enum UnknownEnum
{
    Value_0,
    Value_2 = 2,
    Value_3
}
