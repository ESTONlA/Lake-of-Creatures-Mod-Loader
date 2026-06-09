namespace CreatureProbe;

internal sealed class ModManifest
{
    public string modName { get; set; } = "Test Mod - Estonia";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "An Antenni Loader sample mod that adds a custom main menu tab.";
    public string[] supportedGames { get; set; } = new[] { "lake-of-creatures" };
    public int priority { get; set; }
}
