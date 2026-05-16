# LOCLM 0.5.0-beta Patch Notes

This update focuses on making LOCLM safer, easier to debug, easier to package, and better for mod developers.

## New

- Added real loader logging to `loclm/LOCLM.log`.
- Added runtime/in-game logging support through `LOCLM_runtime.log`.
- Added proxy startup logging through `LOCLM_proxy.log`.
- Added mod hash logging when mods are loaded.
- Added security scan support for suspicious mod files.
- Added security allowlist support for trusted mod hashes.
- Added blocked-mod warning support for suspicious mods.
- Added automatic cache invalidation.
- Added cache rebuild checks for loader changes, mod changes, config changes, removed mods, and original `data.win` changes.
- Added cleaner in-game LOCLM menu data for loaded mods, loader version, and mods folder path.
- Added `0.4.0-beta` loader version display in the in-game menu.
- Added runtime breadcrumbs for LOCLM menu open/close and related actions.

## Mod Template Improvements

- Added `AddSpriteFromPng` helper for adding new PNG sprites.
- Added `ReplaceSpriteTextureFromPng` helper for replacing existing sprite textures.
- Added `AddSoundFromFile` helper for adding embedded `.wav` and `.ogg` sounds.
- Added `ReplaceSoundFromFile` helper for replacing embedded game sounds.
- Added included-file helpers for files shipped under `assets/included/`.
- Added safe text replacement helpers:
  - `ReplaceTextOnce`
  - `ReplaceTextExact`
  - `ReplaceGameString`
  - `ReplaceGameStringContains`
- Added strict token replacement for GML templates.
- Added new template asset folders:
  - `assets/sprites/`
  - `assets/sounds/`
  - `assets/included/`
- Updated the mod template README with examples for sprites, sounds, included files, and text replacement.
- Cleaned the template build output so assets stay under `assets/` instead of duplicating into root folders.

## Security

- Moved security scanning into its own source file instead of keeping it inside the main loader file.
- Added mod hash reporting so users can identify exactly what DLL was scanned.
- Added allowlist behavior for known safe hashes.
- Added clearer warning behavior when a mod looks suspicious.
- Added safer path validation in the mod template asset loader.

## Logging And Debugging

- LOCLM now records more useful startup diagnostics.
- Logs now include important paths, cache information, mod load status, and errors.
- Failed mods and blocked mods are easier to identify.
- Runtime logs make it easier to see what happened inside the patched game.
- Proxy logs help diagnose cases where `version.dll` does not appear to start.

## Packaging

- Release builds are smaller.
- Removed unnecessary language folders from release output.
- Removed unnecessary debug symbols from release output.
- Removed unnecessary XML documentation from release output.
- Removed accidental self-contained build folders from release output.
- Release package is framework-dependent, so users should install the .NET Desktop Runtime instead of shipping the full runtime with LOCLM.

## Requirements

- Windows
- Lake of Creatures installed through Steam
- .NET 10 Desktop Runtime x64

## Notes

- LOCLM is still beta software.
- Security scanning is a safety layer, not a real antivirus.
- A blocked mod can be a false positive, but users should not ignore warnings unless they trust the mod source.
- Mods can still conflict if they patch the same GameMaker code/resources.
- If something behaves strangely, check `LOCLM.log`, `LOCLM_proxy.log`, and `LOCLM_runtime.log`.
