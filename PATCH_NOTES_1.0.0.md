# Antenni Loader 1.0.0 Patch Notes

Antenni Loader 1.0.0 is the first stable release of the renamed, multi-game loader.

This release replaces the previous LOCLM branding, removes the experimental multiplayer work, and supports both Lake of Creatures and Ogre Chambers 2222.

## Supported Games

- Lake of Creatures
- Ogre Chambers 2222

Antenni Loader detects the game from its executable:

```text
LakeOfCreatures.exe
ogre chambers 2.exe
```

Unknown executables are rejected instead of being patched as the wrong game.

## Antenni Loader Rename

- Renamed the user-facing loader from LOCLM to Antenni Loader.
- Renamed the runtime folder from `loclm/` to `antenni/`.
- Renamed the managed loader to `antenni-loader.exe`.
- Renamed loader logs, summaries, cache files, and injected resources.
- Updated the native `version.dll` proxy to launch Antenni Loader.
- Updated documentation, build scripts, release validation, and the mod template.
- Kept the historical `loclm-csharp/` and `loclm-cxx/` source directory names to avoid unnecessary project-path breakage.

## Multi-Game Support

- Added a dedicated game-profile system.
- Added the `lake-of-creatures` game profile.
- Added the `ogre-chambers-2222` game profile.
- Added profile-specific executable validation.
- Added the active game ID to cache manifests and compatibility data.
- Added profile-aware resource baselines.
- Added profile-aware cache fingerprints.
- Added profile-aware diagnostics and install warnings.
- Prevented one supported game from being mistaken for an update to another supported game.

## Mod Compatibility

- Added `supportedGames` support to `modinfo.json`.
- Mods can target one game, both games, or every supported game.
- Supported game IDs:

```json
{
  "supportedGames": [
    "lake-of-creatures",
    "ogre-chambers-2222"
  ]
}
```

- Use `"*"` or `"any"` only for a genuinely game-independent mod.
- Legacy manifests without `supportedGames` remain compatible with Lake of Creatures.
- Legacy manifests are skipped on Ogre Chambers 2222 for safety.
- Lake-only mods are skipped on Ogre Chambers 2222 with a clear compatibility message.
- The CreatureProbe template now explicitly targets Lake of Creatures.

## Lake Of Creatures

- Rebranded the in-game loader button and panel to Antenni Loader.
- Updated the displayed loader version to `1.0.0`.
- Renamed injected objects, functions, globals, and GML assets with the `antenni_` prefix.
- Kept loaded-mod information, conflict information, security warnings, and runtime logging.
- Isolated Lake-specific menu injection from other supported games.

## Ogre Chambers 2222

- Added support for reading and writing the game's `data.win`.
- Added mod discovery, manifest validation, security scanning, conflict reporting, and cache generation.
- Added automatic launch through the shared `version.dll` proxy.
- Disabled Lake-specific in-game menu injection on Ogre Chambers 2222.

The in-game Antenni menu is intentionally unavailable in Ogre Chambers 2222 in 1.0.0. This prevents Lake-specific resource patches from breaking Ogre while preserving the core mod-loading system.

## Cache And Runtime Files

- Cache file: `ANTENNI_CACHE_data.win`
- Cache manifest: `antenni/Logs/ANTENNI_CACHE_manifest.json`
- Main loader log: `antenni/Logs/ANTENNI.log`
- Native proxy log: `antenni/Logs/ANTENNI_proxy.log`
- Runtime summary: `antenni/Logs/ANTENNI_summary.txt`
- Cache regeneration accounts for the loader version, game profile, original game files, mods, configuration, and menu injection version.

## Multiplayer Removal

- Removed the experimental Steam multiplayer bridge from the active loader.
- Removed multiplayer GML injection and runtime hooks.
- Removed multiplayer lobby and player synchronization behavior.
- Focused the stable release on local mod loading and safe game patching.

## Build And Release

- Updated CMake project and native target branding.
- Updated the release output to:

```text
out/bin/
|-- version.dll
`-- antenni/
    |-- antenni-loader.exe
    |-- antenni-loader.dll
    |-- mods/
    |-- Logs/
    |-- disabled_mods/
    `-- quarantine/
```

- Added managed assembly, file, package, and informational version metadata for `1.0.0`.
- Updated release ZIP validation for the Antenni runtime layout.
- Release builds remain Windows x64.

## Verification

- Built the managed loader in Release mode.
- Built the native x64 `version.dll` proxy.
- Built the CreatureProbe template.
- Passed all automated loader tests.
- Validated Lake of Creatures against its installed `data.win`.
- Validated Ogre Chambers 2222 against its installed `data.win`.
- Both real-game validation runs completed with zero loader errors.

## Installation

Copy these items into the selected supported game's folder:

```text
version.dll
antenni/
```

The files must be beside either `LakeOfCreatures.exe` or `ogre chambers 2.exe`.

Place mods in:

```text
antenni/mods/
```

Each mod should remain inside its own folder.

## Upgrade Notes

This release uses new Antenni runtime and cache names. Remove old LOCLM installation files before installing 1.0.0 to avoid loading stale files.

Do not replace the game's original `data.win`.
