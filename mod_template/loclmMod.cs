using UndertaleModLib;

namespace CreatureProbe;

public class CreatureProbe
{
    public void Load(int audiogroup, UndertaleData data)
    {
        if (audiogroup != 0)
        {
            return;
        }

        ModContext context = ModContext.Create(data);
        ModConfig config = context.LoadJson<ModConfig>("data/mod-config.json", required: false) ?? new ModConfig();

        context.Log("Booting mod scaffold...");
        context.Log($"Loaded manifest for {context.Manifest.modName}.");

        if (config.VerboseLogging)
        {
            context.Log($"Discovered {context.CodeFiles.Count} code asset file(s).");
        }

        BuildScene(context, config);
        ApplyHooks(context, config);
    }

    private static void BuildScene(ModContext context, ModConfig config)
    {
        if (config.VerboseLogging)
        {
            context.Log("BuildScene is empty. Add object creation and room injection here.");
        }

        // Example:
        // UndertaleGameObject controller = context.CreateObject("obj_mod_controller");
        // context.PlaceObjectInRoom("room_start", controller, "Instances");
    }

    private static void ApplyHooks(ModContext context, ModConfig config)
    {
        if (!config.EnableExampleHook)
        {
            context.Log("Example hook is disabled. Enable it in assets/data/mod-config.json once you target a real function.");
            return;
        }

        if (string.IsNullOrWhiteSpace(config.TargetFunction))
        {
            throw new InvalidOperationException("EnableExampleHook is true, but TargetFunction is empty.");
        }

        context.RequireFunction(config.TargetFunction);
        context.HookFunctionFromFile("hooks/example_hook.gml", config.TargetFunction);
        context.Log($"Installed example hook on {config.TargetFunction}.");
    }
}
