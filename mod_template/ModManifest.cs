namespace CreatureProbe;

internal sealed class ModManifest
{
    public string modName { get; set; } = "Test Mod - Estonia";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "A LOCLM sample mod that adds a custom main menu tab.";
    public int priority { get; set; }
}
