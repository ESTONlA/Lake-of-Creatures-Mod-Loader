public class ModInfo
{
    public string modPath = "";
    public string folderName = "";
    public string modName { get; set; } = "";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "";
    public int priority { get; set; }
    public bool enabled { get; set; } = true;
    public string minLoaderVersion { get; set; } = "";
    public string maxLoaderVersion { get; set; } = "";
    public string[] supportedGames { get; set; } = Array.Empty<string>();
    public string[] supportedGameVersions { get; set; } = Array.Empty<string>();
    public string[] testedOn { get; set; } = Array.Empty<string>();
    public string[] dependencies { get; set; } = Array.Empty<string>();
    public string[] optionalDependencies { get; set; } = Array.Empty<string>();
    public string[] incompatibleWith { get; set; } = Array.Empty<string>();
    public string[] loadAfter { get; set; } = Array.Empty<string>();
    public string[] loadBefore { get; set; } = Array.Empty<string>();
}

public sealed record ModManifestResult(ModInfo? ModInfo, string? Error)
{
    public bool Success => ModInfo is not null && Error is null;
}

public class CacheManifest
{
    public string loaderVersion { get; set; } = "";
    public string gameId { get; set; } = "";
    public string injectionVersion { get; set; } = "";
    public string fingerprint { get; set; } = "";
    public string createdUtc { get; set; } = "";
}
