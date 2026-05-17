# LOCLM

LOCLM is the Lake of Creatures mod loader. It injects through `version.dll`, rewrites the game's `data.win` with loaded mods, and then relaunches the game against the generated `LOCLM_CACHE_data.win`.

## Links

- Steam store page: https://store.steampowered.com/app/1808320/Lake_of_Creatures/
- Steam community page: https://steamcommunity.com/app/1808320
- Discord: https://discord.com/invite/kQdXU3r2Dn
- Wiki for creating mods: https://estonla.github.io/LOCLm-modding-wiki/index.html


## Repository Layout

```text
.
+-- loclm-cxx/        Native proxy DLL loader (`version.dll`)
+-- loclm-csharp/     C# mod loading and `data.win` patching logic
+-- mod_template/     `dotnet new loclm` template for creating mods
\-- docs/             Astro/Starlight documentation site
```

## Build

The top-level CMake project fetches UndertaleModTool and builds both loader components.

```powershell
cmake -S . -B build
cmake --build build
```

Build output is written to `out/bin/`.

Expected runtime layout:

```text
out/bin/
+-- version.dll
\-- loclm/
    +-- loclm-csharp.exe
    +-- loclm-csharp.dll
    +-- mods/
    \-- runtimes/
```

To install the loader into a game folder, copy `out/bin/version.dll` and the `out/bin/loclm/` directory next to the game's executable and `data.win`.

Important: the current game build is `x64`, so `version.dll` must also be the `x64` build.

## Mod Template

The mod template lives in [`mod_template`](mod_template). To install it locally:

```powershell
dotnet new install .\mod_template
```

Then create a new mod with:

```powershell
dotnet new loclm
```

For the easy-mode template:

```powershell
dotnet new loclm -e
```

LOCLM is based on / inspired by GS2ML by OmegaMetor:
https://github.com/OmegaMetor/GS2ML

GS2ML is licensed under GPL-3.0, and this project keeps the same GPL-3.0 license.
