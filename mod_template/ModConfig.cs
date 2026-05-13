namespace CreatureProbe;

public sealed class ModConfig
{
    public bool VerboseLogging { get; set; } = true;
    public bool EnableExampleHook { get; set; }
    public string TargetFunction { get; set; } = "scr_replace_me";
}
