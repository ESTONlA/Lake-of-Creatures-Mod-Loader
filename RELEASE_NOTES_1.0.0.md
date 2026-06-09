# Antenni Loader 1.0.0

The first stable Antenni Loader release is now available.

## Highlights

- Renamed LOCLM to Antenni Loader.
- Added support for Lake of Creatures and Ogre Chambers 2222.
- Added automatic game-profile detection.
- Added `supportedGames` mod manifest support.
- Added safe per-game mod compatibility checks.
- Kept the in-game Antenni menu for Lake of Creatures.
- Added safe core mod loading for Ogre Chambers 2222 without Lake-specific UI patches.
- Removed the experimental multiplayer implementation.
- Updated runtime files, logs, cache names, documentation, tests, and release packaging.

## Install

Place the following beside the supported game's executable:

```text
version.dll
antenni/
```

Supported executables:

```text
LakeOfCreatures.exe
ogre chambers 2.exe
```

Install mods into:

```text
antenni/mods/
```

## Mod Authors

Declare compatible games in `modinfo.json`:

```json
{
  "supportedGames": [
    "lake-of-creatures"
  ]
}
```

Available IDs:

```text
lake-of-creatures
ogre-chambers-2222
```

Use `"*"` only when the mod is truly compatible with every supported game.

## Important

- Remove old LOCLM files before installing Antenni Loader.
- Do not replace the original `data.win`.
- Ogre Chambers 2222 does not receive the Lake-specific in-game loader menu.
- Windows x64 and the .NET 10 Desktop Runtime are required.

See `PATCH_NOTES_1.0.0.md` for the complete change list.
