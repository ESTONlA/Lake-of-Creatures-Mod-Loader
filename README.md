# Antenni Loader 1.0.0

Antenni Loader is a community GameMaker mod loader for:

- Lake of Creatures
- Ogre Chambers 2222

Version `1.0.0` is the first stable Antenni Loader release.

It injects through `version.dll`, loads C# mods, patches the selected game's `data.win`, and launches the game with a generated `ANTENNI_CACHE_data.win`. The original `data.win` is not replaced.

## Requirements

- Windows 10 or Windows 11, x64
- .NET 10 Desktop Runtime x64
- A supported Steam game installation

## Installation

Copy these items from `out/bin/` into the supported game's folder:

```text
version.dll
antenni/
```

The result must look like:

```text
Game Folder/
├─ version.dll
├─ data.win
├─ LakeOfCreatures.exe
│  or ogre chambers 2.exe
└─ antenni/
   ├─ antenni-loader.exe
   ├─ antenni-loader.dll
   ├─ mods/
   └─ Logs/
```

Launch the game normally through Steam.

## Installing Mods

Each mod needs its own folder:

```text
antenni/mods/ExampleMod/
├─ ExampleMod.dll
└─ modinfo.json
```

Mods should declare their supported game:

```json
{
  "modName": "Example Mod",
  "authors": ["Example Author"],
  "description": "Example Antenni mod.",
  "priority": 100,
  "supportedGames": ["lake-of-creatures"]
}
```

Valid game IDs:

- `lake-of-creatures`
- `ogre-chambers-2222`
- `*` for a genuinely game-independent mod

Legacy manifests without `supportedGames` remain compatible with Lake of Creatures. Antenni skips them on Ogre Chambers 2222 to prevent Lake-specific patches from corrupting Ogre.

## Game-Specific Behavior

Lake of Creatures currently supports the in-game Antenni menu.

Ogre Chambers 2222 supports proxy startup, mod loading, security scanning, conflict reporting, cache generation, and launching. Its in-game Antenni menu is intentionally disabled until a safe Ogre-specific UI integration is implemented.

## Build

```powershell
dotnet build loclm-csharp\loclm-csharp.csproj -c Release
cmake -S . -B build\x64 -A x64
cmake --build build\x64 --config Release --target antenni-proxy
```

Build output is written to:

```text
out/bin/version.dll
out/bin/antenni/
```

The source directories retain their historical `loclm-csharp` and `loclm-cxx` names to avoid breaking repository history and existing project references. Runtime branding and installation use Antenni Loader.

## Credits

Antenni Loader was originally developed as LOCLM for Lake of Creatures and is based on or inspired by GS2ML by OmegaMetor:

https://github.com/OmegaMetor/GS2ML
