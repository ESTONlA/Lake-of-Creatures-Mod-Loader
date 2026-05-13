# Test Mod - Estonia

This template ships with a working sample that adds a main-menu button and opens a custom tab called `Test Mod - Estonia`.

## Files That Matter

- `loclmMod.cs`: main entry point with `InstallMainMenuTab`
- `ModContext.cs`: asset loading, logging, and hook helpers
- `ModConfig.cs`: optional JSON config model
- `IncludedFiles/modinfo.json`: manifest copied beside your built DLL
- `assets/code/`: recursive GML hook/function assets
- `assets/data/mod-config.json`: optional config loaded at runtime

## First Pass

1. Update `IncludedFiles/modinfo.json`.
2. Put your actual patch logic into `InstallMainMenuTab` or split it into your own helpers.
3. If you installed the template with `-e`, tweak `mainMenuButtonLabel`, `menuTabTitle`, `menuTabBody`, `mainMenuButtonIndex`, and `backButtonIndex` in `assets/data/mod-config.json`.
4. Build with `dotnet build`.

## Asset Paths

Code assets are loaded recursively and referenced by relative path. Example:

The sample hook files under `assets/code/hooks/` show how to append into real menu code, including:

- `main_menu_spawn_buttons.gml`
- `obj_button_menu_Alarm_0.gml`
- `obj_button_menu_Alarm_2.gml`
- `obj_ctrl_main_menu_Draw_0.gml`
- `obj_ctrl_main_menu_Step_0.gml`
- `obj_ctrl_main_menu_Alarm_2.gml`
