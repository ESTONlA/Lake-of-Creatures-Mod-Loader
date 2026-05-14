# Contributing to LOCLM

Thanks for wanting to contribute to LOCLM.
LOCLM is a community made mod loader for Lake of Creatures. Contributions are welcome, but changes should be useful, maintainable, and tested before being submitted.

## Ways To Contribute

You can help by:
- Fixing bugs
- Improving the loader
- Improving the mod template
- Improving documentation or wiki pages
- Reporting issues with clear details
- Suggesting useful features
- Testing releases on different Windows setups

## Before You Start

Before making a large change, please open an issue or discussion first.
This helps avoid duplicate work and makes sure the change fits the project.
Small fixes, documentation updates, and cleanup changes can usually go straight to a pull request.

## Development Requirements

To build LOCLM, you need:
- Windows 10 or Windows 11
- .NET SDK 10.0
- CMake
- Visual Studio 2022 with C++ desktop development tools
- Git

Players only need the .NET Desktop Runtime. Contributors need the SDK.

## Project Structure

```
loclm-cxx/       Native proxy DLL loader
loclm-csharp/    Main C# loader
mod_template/    Example mod template
out/             Local build output, not committed
```

## Build

Build the C# loader:

```powershell
dotnet build loclm-csharp\loclm-csharp.csproj -c Release
```

Build the proxy DLL:

```powershell
cmake --build build\x64 --config Release --target loclm-cxx
```

## Pull Request Rules

Please follow these rules:
- Keep changes focused.
- Do not mix unrelated changes in one pull request.
- Do not commit local build output from `out/`.
- Do not commit generated cache files like `LOCLM_CACHE_data.win`.
- Do not commit personal paths, usernames, or machine specific files.
- Test your changes before opening a pull request.
- Explain what changed and why.
- Include screenshots or logs if the change affects UI or startup behavior.

## Pull Request Titles

Use a short, clear pull request title that explains the change.

Good title format:
```text
type: short description
```

Recommended types:
- `fix`: bug fix
- `feat`: new feature
- `refactor`: code cleanup or restructuring
- `docs`: documentation or wiki changes
- `build`: build, release, or workflow changes
- `template`: mod template changes
- `security`: security scan or allowlist changes

Examples:

```text
fix: improve proxy startup logging
feat: add mod security allowlist
docs: update installation guide
template: add sprite helper example
build: trim release package output
```

Avoid vague titles like:

```text
update stuff
fixed things
changes
work
```

## Pull Request Description

Every pull request should include a short changelog.
Use this format:

```md
## Summary

- What changed?
- Why was this change needed?

## Changes

- Added/changed/removed something specific.
- Added/changed/removed something specific.

## Testing

- Explain how you tested it.
- Include build commands, game testing, or screenshots if useful.

## Notes

- Mention risks, known issues, or follow-up work.
```
If the pull request fixes an issue, link it in the description:

```md
Fixes #123
```

If the change affects users, include clear release-note style wording.

Example:

```md
## Summary

- Improves proxy DLL startup reliability.
- Adds earlier `LOCLM_proxy.log` output so launch issues are easier to debug.

## Changes

- Replaced C++ stream logging with WinAPI file logging.
- Removed risky thread suspend/resume behavior.
- Built `version.dll` with static MSVC runtime.

## Testing

- Built C# loader in Release.
- Built proxy DLL in Release.
- Confirmed `out/bin/version.dll` and `out/bin/loclm/` were generated.

## Notes

- Users still need .NET Desktop Runtime 10.0 x64.
```

## Code Style

General rules:
- Prefer simple, readable code.
- Avoid large rewrites unless they are needed.
- Keep error messages useful for normal users.
- Keep logs clear enough for bug reports.
- Do not hide failures silently.
- Avoid adding new dependencies unless there is a good reason.

## Security Scan Changes

LOCLM includes a basic security scan for mods.
If you change security scan behavior:
- Explain what patterns were added or removed.
- Avoid blocking harmless mods without a clear reason.
- Remember false positives can happen.
- Do not market the scanner as a full antivirus.

## Mod Template Changes

If you change the mod template:
- Make sure it still builds.
- Keep the example easy to understand.
- Avoid making the template depend on private tools.
- Update the wiki if the install or build flow changes.

## Documentation Changes

Documentation should be clear for new users.

When updating docs, explain:
- What the user needs
- Where files should go
- What to do if something breaks
- What is Windows-only or unsupported

## Bug Reports

Good bug reports include:
- LOCLM version
- Game version if known
- Windows version
- What you expected to happen
- What actually happened
- `LOCLM_proxy.log` if it exists
- Loader console output if possible
- Installed mods list
- Steps to reproduce the issue

## Feature Requests

Good feature requests include:
- What you want added
- Why it would be useful
- Who it helps
- Any examples or mockups if available

## Credits

LOCLM is maintained by Estonia and the community.
LOCLM is based on / inspired by GS2ML by OmegaMetor.
