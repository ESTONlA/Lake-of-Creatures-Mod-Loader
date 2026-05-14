using System.Text.Json;

public class ModInfo
{
    public string modPath = "";
    public string modName { get; set; } = "";
    public string[] authors { get; set; } = Array.Empty<string>();
    public string description { get; set; } = "";
    public int priority { get; set; }
}

public sealed record ModManifestResult(ModInfo? ModInfo, string? Error)
{
    public bool Success => ModInfo is not null && Error is null;
}

public static class ModManifestValidator
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
            JsonSerializerOptions options = new() { PropertyNameCaseInsensitive = true };
            info = JsonSerializer.Deserialize<ModInfo>(File.ReadAllText(manifestPath), options);
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
        info.modName = info.modName?.Trim() ?? "";
        info.description = info.description?.Trim() ?? "";
        info.authors = info.authors?
            .Where(author => !string.IsNullOrWhiteSpace(author))
            .Select(author => author.Trim())
            .ToArray() ?? Array.Empty<string>();

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

    private static ModManifestResult Invalid(string error) => new(null, error);
}

public class CacheManifest
{
    public string loaderVersion { get; set; } = "";
    public string fingerprint { get; set; } = "";
    public string createdUtc { get; set; } = "";
}
