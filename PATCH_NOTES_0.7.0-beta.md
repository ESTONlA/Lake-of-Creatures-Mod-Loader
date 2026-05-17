# LOCLM 0.7.0-beta Patch Notes

This update focuses on future-proofing LOCLM against game updates, safer in-game menu injection, better compatibility reporting, cleaner troubleshooting data, and a large internal code cleanup.

## Future-Proofing

- Added automatic game resource baseline generation.
- Added `loclm/Logs/game_resource_baseline.json`.
- Added game compatibility reporting.
- Added `loclm/Logs/game_compatibility_report.json`.
- Added checks for required menu-related game resources.
- Added warnings when required menu scripts or objects are missing after a game update.
- Added detection for changed LOCLM menu injection targets.
- Added unknown game build warnings.
- Added `supported_game_builds.json` support.
- Added release output support for `loclm/supported_game_builds.json`.

## Safer LOCLM Menu Injection

- LOCLM now fails gracefully if the in-game menu cannot be installed.
- If menu injection fails, the loader can still continue building and launching the patched cache.
- Added clearer warning text when menu injection targets may have changed after a game update.
- Added already-injected `obj_loclm_button` detection.
- Added a menu injection version value to the cache manifest.
- Cache now invalidates when the LOCLM menu injection version changes.
- Cache now invalidates when `supported_game_builds.json` changes.

## Runtime Safety

- Added runtime guard initialization for LOCLM menu globals.
- Added safer defaults for:
  - `global.loclm_loaded_mods`
  - `global.loclm_loaded_mod_count`
  - `global.loclm_failed_mods`
  - `global.loclm_failed_mod_count`
  - `global.loclm_mod_conflicts`
  - `global.loclm_mod_conflict_count`
  - `global.loclm_loaded_scroll`
  - `global.loclm_folder_copied_timer`
- This reduces crashes from missing LOCLM globals if the menu state changes unexpectedly.

## Mod Manifest Changes

- Added `testedOn` support to `modinfo.json`.
- Mods can now list game builds they have been tested on.
- LOCLM warns when a mod has `testedOn` values but the current game build is not listed.
- `testedOn` warnings are included in mod status reports.

Example:

```json
{
  "modName": "Example Mod",
  "authors": ["Example Author"],
  "description": "Example LOCLM mod.",
  "priority": 100,
  "testedOn": [
    "PUT_DATA_WIN_OR_EXE_HASH_PREFIX_HERE"
  ]
}
```

## Logs And Reports

- Added `game_compatibility_report.json`.
- Added `game_resource_baseline.json`.
- Added menu injection version to `LOCLM_summary.txt`.
- Added troubleshooting next steps for unknown game builds.
- Added troubleshooting next steps for changed menu injection targets.
- Improved warnings when the game may have updated.

## Release Packaging

- Release builds now copy `supported_game_builds.json`.
- Release zip validation now checks for `loclm/supported_game_builds.json`.
- `out/bin/loclm/supported_game_builds.json` is now part of the generated release output.

## Code Quality Refactor

- Split major loader responsibilities out of `CSMAIN.cs`.
- Added `Program.cs` as the small startup entry point.
- Added `LoaderConfig.cs` for startup paths and loader folder layout.
- Added `CacheManager.cs` for cache fingerprints and cache manifest handling.
- Added `ModLoader.cs` for mod loading, security scan handling, load timing, failure handling, and quarantine marker creation.
- Added `ModScanner.cs` for mod folder discovery.
- Added `ModMetadataValidator.cs` for `modinfo.json` validation.
- Added `GamePatcher.cs` for reading and writing `data.win`.
- Added `GameLauncher.cs` for launching the game and keeping the console open when needed.
- Added `InstallValidator.cs` for basic install layout validation.
- Added `ConsoleTheme.cs` for consistent colored console output.
- Added `GmlAssetLoader.cs` for injected GML asset loading and token replacement.
- Added `InGameMenuInstaller.cs` for LOCLM menu installation logic.
- Added `ReleaseManifest.cs` for release-required file tracking.
- Kept `SecurityScanner.cs` split out and continued that pattern for new loader systems.

## Shared Utilities

- Added `LoaderResult.cs` for safer result-style error handling.
- Added centralized user-facing error codes through `LoaderError`.
- Added `HashUtil.cs` for shared SHA256 helpers.
- Added `JsonUtil.cs` for shared JSON serializer options.
- Added `PathUtil.cs` for shared path helpers.
- Replaced several duplicated hash and JSON helper blocks with the shared utilities.
- Added `.editorconfig`.
- Kept nullable reference types enabled for the loader project.

## Tests

- Added a lightweight `loclm-csharp.Tests` project.
- Added metadata validation tests.
- Added cache fingerprinting tests.
- Added security allowlist parsing tests.
- Added dependency detection tests.
- Added install layout detection tests.
- Added release packaging script checks.

## Notes For Players

- If LOCLM says the game build is unknown, it does not always mean the loader is broken.
- It means the current game hash is not listed in `supported_game_builds.json` yet.
- Mods may still work, but game updates can break patches.
- If the LOCLM in-game menu does not appear but mods still load, check `loclm/Logs/game_compatibility_report.json`.

## Notes For Mod Developers

- Use `testedOn` in `modinfo.json` to show which game builds your mod was tested on.
- Keep patches small and targeted.
- Prefer unique `loclm_` or mod prefixed globals.
- Avoid relying on fragile menu script edits when a cloned object or isolated hook is possible.
- If a game update changes menu scripts, check `game_resource_baseline.json` and `game_compatibility_report.json`.
- If a mod fails to load, check `loclm/Logs/mod_status.json`, `failed_mods.json`, and `security_report.json`.