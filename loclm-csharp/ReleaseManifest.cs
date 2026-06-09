public sealed class ReleaseManifest
{
    public string LoaderVersion { get; set; } = LoaderConstants.LoaderVersion;
    public string MenuInjectionVersion { get; set; } = LoaderConstants.MenuInjectionVersion;
    public string CreatedUtc { get; set; } = DateTime.UtcNow.ToString("O");
    public List<string> RequiredFiles { get; set; } = new()
    {
        "version.dll",
        "antenni/antenni-loader.exe",
        "antenni/antenni-loader.dll",
        "antenni/antenni-loader.runtimeconfig.json",
        "antenni/UndertaleModLib.dll",
        "antenni/supported_game_builds.json",
        "antenni/assets/gml/runtime_logger.gml"
    };
}
