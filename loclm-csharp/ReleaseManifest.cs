public sealed class ReleaseManifest
{
    public string LoaderVersion { get; set; } = LoaderConstants.LoaderVersion;
    public string MenuInjectionVersion { get; set; } = LoaderConstants.MenuInjectionVersion;
    public string CreatedUtc { get; set; } = DateTime.UtcNow.ToString("O");
    public List<string> RequiredFiles { get; set; } = new()
    {
        "version.dll",
        "loclm/loclm-csharp.exe",
        "loclm/loclm-csharp.dll",
        "loclm/loclm-csharp.runtimeconfig.json",
        "loclm/config.json",
        "loclm/config/steam_mp.json",
        "loclm/UndertaleModLib.dll",
        "loclm/supported_game_builds.json",
        "loclm/assets/gml/runtime_logger.gml"
    };
}
