namespace CreatureProbe;

public sealed class ModConfig
{
    public bool VerboseLogging { get; set; } = true;
    public bool EnableMenuTab { get; set; } = true;
    public string MainMenuButtonLabel { get; set; } = "Test Mod - Estonia";
    public int MainMenuButtonIndex { get; set; } = 68;
    public string MenuTabTitle { get; set; } = "Test Mod - Estonia";
    public string MenuTabBody { get; set; } = "A real template tab hooked into the main menu.";
    public int BackButtonIndex { get; set; } = 69;
    public string BackButtonLabel { get; set; } = "Back";
}
