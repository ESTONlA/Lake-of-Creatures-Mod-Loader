using System.Text.Json;

public static class ModMetadataValidator
{
    public static ModManifestResult Load(string modPath)
    {
        string folderName = Path.GetFileName(modPath);
        if (string.IsNullOrWhiteSpace(folderName))
        {
            return Invalid("mod folder name is empty.");
        }

        string manifestPath = Path.Combine(modPath, "modinfo.json");
        if (!File.Exists(manifestPath))
        {
            return Invalid("missing modinfo.json.");
        }

        ModInfo? info;
        try
        {
            info = JsonSerializer.Deserialize<ModInfo>(File.ReadAllText(manifestPath), JsonUtil.CaseInsensitiveOptions);
        }
        catch (JsonException ex)
        {
            return Invalid("invalid modinfo.json: " + ex.Message);
        }

        if (info is null)
        {
            return Invalid("modinfo.json is empty.");
        }

        info.modPath = modPath;
        info.folderName = folderName;
        info.modName = info.modName?.Trim() ?? "";
        info.description = info.description?.Trim() ?? "";
        info.authors = info.authors?
            .Where(author => !string.IsNullOrWhiteSpace(author))
            .Select(author => author.Trim())
            .ToArray() ?? Array.Empty<string>();
        info.minLoaderVersion = info.minLoaderVersion?.Trim() ?? "";
        info.maxLoaderVersion = info.maxLoaderVersion?.Trim() ?? "";
        info.supportedGames = CleanStringArray(info.supportedGames);
        info.supportedGameVersions = CleanStringArray(info.supportedGameVersions);
        info.testedOn = CleanStringArray(info.testedOn);
        info.dependencies = CleanStringArray(info.dependencies);
        info.optionalDependencies = CleanStringArray(info.optionalDependencies);
        info.incompatibleWith = CleanStringArray(info.incompatibleWith);
        info.loadAfter = CleanStringArray(info.loadAfter);
        info.loadBefore = CleanStringArray(info.loadBefore);

        if (string.IsNullOrWhiteSpace(info.modName))
        {
            return Invalid("modName is required.");
        }

        if (info.modName.Length > 80)
        {
            return Invalid("modName must be 80 characters or less.");
        }

        if (info.authors.Length == 0)
        {
            return Invalid("authors must contain at least one name.");
        }

        if (info.authors.Any(author => author.Length > 60))
        {
            return Invalid("author names must be 60 characters or less.");
        }

        if (info.description.Length > 500)
        {
            return Invalid("description must be 500 characters or less.");
        }

        if (info.priority < -100000 || info.priority > 100000)
        {
            return Invalid("priority must be between -100000 and 100000.");
        }

        string expectedDllPath = Path.Combine(modPath, folderName + ".dll");
        if (!File.Exists(expectedDllPath))
        {
            return Invalid($"missing DLL. Expected {folderName}.dll.");
        }

        return new ModManifestResult(info, null);
    }

    private static string[] CleanStringArray(string[]? values) =>
        values?
            .Where(value => !string.IsNullOrWhiteSpace(value))
            .Select(value => value.Trim())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray() ?? Array.Empty<string>();

    private static ModManifestResult Invalid(string error) => new(null, error);
}

public static class ModManifestValidator
{
    public static ModManifestResult Load(string modPath) => ModMetadataValidator.Load(modPath);
}
