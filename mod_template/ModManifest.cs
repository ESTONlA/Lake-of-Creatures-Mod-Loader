namespace CreatureProbe;

internal sealed class ModManifest
{
    public string modName { get; set; } = "CreatureProbe";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "A LOCLM mod.";
    public int priority { get; set; }
}
