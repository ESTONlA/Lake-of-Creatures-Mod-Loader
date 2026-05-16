# Test Mod - Estonia

This template ships with a working sample that adds a main-menu button and opens a custom tab called `Test Mod - Estonia`.

## Files That Matter

- `loclmMod.cs`: main entry point with `InstallMainMenuTab`
- `ModContext.cs`: asset loading, logging, and hook helpers
- `ModConfig.cs`: optional JSON config model
- `IncludedFiles/modinfo.json`: manifest copied beside your built DLL
- `assets/code/`: recursive GML hook/function assets
- `assets/data/mod-config.json`: optional config loaded at runtime
- `assets/sprites/`: PNG files for sprite/texture helpers
- `assets/sounds/`: WAV/OGG files for sound helpers
- `assets/included/`: files shipped with the mod for runtime use

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

## Resource Helpers

`ModContext.cs` includes helpers for common mod work:

```csharp
// Add a brand new sprite from assets/sprites/probe_icon.png.
UndertaleSprite icon = context.AddSpriteFromPng(
    "spr_my_mod_icon",
    "sprites/probe_icon.png",
    originX: 8,
    originY: 8);

// Replace frame 0 of an existing sprite. The replacement is fitted into the
// existing texture page item, so use the same size as the original sprite.
context.ReplaceSpriteTextureFromPng(
    "spr_existing_game_sprite",
    "sprites/replacement.png");

// Add a new embedded sound from assets/sounds/click.ogg.
UndertaleSound click = context.AddSoundFromFile(
    "snd_my_mod_click",
    "sounds/click.ogg");

// Replace an existing embedded data.win sound.
context.ReplaceSoundFromFile(
    "snd_existing_game_sound",
    "sounds/replacement.wav");

// Register a file shipped with the mod under assets/included/.
string gmlPath = context.GetIncludedFileGamePath("included/my_data.json");

// Safely patch strings. These throw if the expected match count is wrong.
context.ReplaceGameString("Old Text", "New Text");
context.ReplaceGameStringContains("Old", "New", expectedMatches: 1);
```

Notes:

- Sprite helpers currently support PNG files.
- Sound helpers currently support embedded `.wav` and `.ogg` files in the built-in audio group.
- Included files are shipped beside your mod under `assets/included/`; they are not injected into GameMaker's empty `DAFL` chunk.
- Token replacement used by `AppendCodeFromFile(..., replacements)` is strict now. If a token is missing, the build fails instead of silently creating broken GML.
