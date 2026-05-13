# CreatureProbe

This project is scaffolded for LOCLM and starts with a small runtime helper layer instead of a single giant file.

## Files That Matter

- `CreatureProbe.cs`: main entry point with `BuildScene` and `ApplyHooks`
- `ModContext.cs`: asset loading, logging, hook helpers, object helpers
- `ModConfig.cs`: optional JSON config model
- `IncludedFiles/modinfo.json`: manifest copied beside your built DLL
- `assets/code/`: recursive GML hook/function assets
- `assets/data/mod-config.json`: optional config loaded at runtime

## First Pass

1. Update `IncludedFiles/modinfo.json`.
2. Put your actual patch logic into `BuildScene` and `ApplyHooks`.
3. If you installed the template with `-e`, set `TargetFunction` and `EnableExampleHook` in `assets/data/mod-config.json`.
4. Build with `dotnet build`.

## Asset Paths

Code assets are loaded recursively and referenced by relative path. Example:

```csharp
context.HookFunctionFromFile("hooks/example_hook.gml", "scr_real_target");
```
