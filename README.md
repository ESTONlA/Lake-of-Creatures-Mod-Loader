# LOCLM

LOCLM is the Lake of Creatures mod loader. It injects through `version.dll`, rewrites the game's `data.win` with loaded mods, and then relaunches the game against the generated `LOCLM_CACHE_data.win`.

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

## Documentation

The docs site lives in [`docs`](docs) and uses Astro + Starlight.

```powershell
Set-Location docs
npm install
npm run dev
```

## Notes

- The C# loader looks for mods under `loclm/mods/`.
- Mods are ordered by `priority` from each mod's `modinfo.json`.
- Optional `blacklist.txt` and `whitelist.txt` files can live beside the LOCLM runtime inside the `loclm/` directory.
