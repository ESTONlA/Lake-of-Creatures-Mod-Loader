public sealed class GameProfile
{
    private GameProfile(string id, string displayName, string executableName, bool supportsInGameMenu)
    {
        Id = id;
        DisplayName = displayName;
        ExecutableName = executableName;
        SupportsInGameMenu = supportsInGameMenu;
    }

    public string Id { get; }
    public string DisplayName { get; }
    public string ExecutableName { get; }
    public bool SupportsInGameMenu { get; }

    public static GameProfile LakeOfCreatures { get; } =
        new("lake-of-creatures", "Lake of Creatures", "LakeOfCreatures.exe", supportsInGameMenu: true);

    public static GameProfile OgreChambers2222 { get; } =
        new("ogre-chambers-2222", "Ogre Chambers 2222", "ogre chambers 2.exe", supportsInGameMenu: false);

    public static IReadOnlyList<GameProfile> Supported { get; } =
        new[] { LakeOfCreatures, OgreChambers2222 };

    public static GameProfile? Detect(string executablePath)
    {
        string executableName = Path.GetFileName(executablePath);
        return Supported.FirstOrDefault(profile =>
            string.Equals(profile.ExecutableName, executableName, StringComparison.OrdinalIgnoreCase));
    }

    public static string SupportedExecutableList() =>
        string.Join(", ", Supported.Select(profile => profile.ExecutableName));
}
