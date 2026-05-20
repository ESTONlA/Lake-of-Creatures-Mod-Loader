using System.Text.Json;
using System.Text.RegularExpressions;

public static class ModMetadataValidator
{
    private static readonly Regex IdPattern = new("^[a-z0-9][a-z0-9_.-]{1,79}$", RegexOptions.IgnoreCase | RegexOptions.Compiled);

    private static readonly HashSet<string> KnownFields = new(StringComparer.OrdinalIgnoreCase)
    {
        "id",
        "version",
        "modName",
        "authors",
        "description",
        "website",
        "repository",
        "license",
        "tags",
        "priority",
        "enabled",
        "minLoaderVersion",
        "maxLoaderVersion",
        "supportedGameVersions",
        "testedOn",
        "dependencies",
        "optionalDependencies",
        "incompatibleWith",
        "loadAfter",
        "loadBefore"
    };

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

        JsonDocument document;
        try
        {
            document = JsonDocument.Parse(File.ReadAllText(manifestPath), new JsonDocumentOptions
            {
                AllowTrailingCommas = true,
                CommentHandling = JsonCommentHandling.Skip
            });
        }
        catch (JsonException ex)
        {
            return Invalid("invalid modinfo.json: " + ex.Message);
        }

        using (document)
        {
            JsonElement root = document.RootElement;
            if (root.ValueKind != JsonValueKind.Object)
            {
                return Invalid("modinfo.json must be a JSON object.");
            }

            List<string> warnings = new();
            foreach (JsonProperty property in root.EnumerateObject())
            {
                if (!KnownFields.Contains(property.Name))
                {
                    warnings.Add($"Unknown modinfo.json field '{property.Name}'.");
                }
            }

            ModInfo info = new()
            {
                modPath = modPath,
                folderName = folderName,
                id = GetString(root, "id"),
                version = GetString(root, "version"),
                modName = GetString(root, "modName"),
                authors = GetStringArray(root, "authors"),
                description = GetString(root, "description"),
                website = GetString(root, "website"),
                repository = GetString(root, "repository"),
                license = GetString(root, "license"),
                tags = CleanStringArray(GetStringArray(root, "tags")),
                priority = GetInt(root, "priority", 0),
                enabled = GetBool(root, "enabled", true),
                minLoaderVersion = GetString(root, "minLoaderVersion"),
                maxLoaderVersion = GetString(root, "maxLoaderVersion"),
                supportedGameVersions = CleanStringArray(GetStringArray(root, "supportedGameVersions")),
                testedOn = CleanStringArray(GetStringArray(root, "testedOn")),
                loadAfter = CleanStringArray(GetStringArray(root, "loadAfter")),
                loadBefore = CleanStringArray(GetStringArray(root, "loadBefore"))
            };

            info.dependencyRules = ParseDependencyRules(root, "dependencies", warnings);
            info.optionalDependencyRules = ParseDependencyRules(root, "optionalDependencies", warnings);
            info.incompatibleRules = ParseDependencyRules(root, "incompatibleWith", warnings);
            info.dependencies = CleanStringArray(info.dependencyRules.Select(rule => rule.id).ToArray());
            info.optionalDependencies = CleanStringArray(info.optionalDependencyRules.Select(rule => rule.id).ToArray());
            info.incompatibleWith = CleanStringArray(info.incompatibleRules.Select(rule => rule.id).ToArray());

            if (string.IsNullOrWhiteSpace(info.id))
            {
                info.id = folderName;
                warnings.Add("Recommended field 'id' is missing. Falling back to the mod folder name.");
            }
            else if (!IdPattern.IsMatch(info.id))
            {
                return Invalid("id must use only letters, numbers, dot, dash, or underscore and be 2-80 characters.");
            }

            if (string.IsNullOrWhiteSpace(info.version))
            {
                info.version = "0.0.0";
                warnings.Add("Recommended field 'version' is missing. Falling back to 0.0.0.");
            }
            else if (!Semver.TryParse(info.version, out _))
            {
                return Invalid("version must be valid semver, for example 1.0.0 or 1.0.0-beta.");
            }

            if (!string.IsNullOrWhiteSpace(info.minLoaderVersion) && !Semver.TryParse(info.minLoaderVersion, out _))
            {
                warnings.Add("minLoaderVersion should be semver.");
            }

            if (!string.IsNullOrWhiteSpace(info.maxLoaderVersion) && !Semver.TryParse(info.maxLoaderVersion, out _))
            {
                warnings.Add("maxLoaderVersion should be semver.");
            }

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

            WarnIfMissingRecommended(info, warnings);

            string expectedDllPath = Path.Combine(modPath, folderName + ".dll");
            if (!File.Exists(expectedDllPath))
            {
                return Invalid($"missing DLL. Expected {folderName}.dll.");
            }

            info.manifestWarnings = warnings.Distinct(StringComparer.OrdinalIgnoreCase).ToArray();
            return new ModManifestResult(info, null, info.manifestWarnings);
        }
    }

    private static void WarnIfMissingRecommended(ModInfo info, List<string> warnings)
    {
        if (string.IsNullOrWhiteSpace(info.description))
        {
            warnings.Add("Recommended field 'description' is missing.");
        }
        if (string.IsNullOrWhiteSpace(info.license))
        {
            warnings.Add("Recommended field 'license' is missing.");
        }
        if (string.IsNullOrWhiteSpace(info.repository) && string.IsNullOrWhiteSpace(info.website))
        {
            warnings.Add("Recommended field 'repository' or 'website' is missing.");
        }
        if (info.tags.Length == 0)
        {
            warnings.Add("Recommended field 'tags' is missing.");
        }
    }

    private static ModDependency[] ParseDependencyRules(JsonElement root, string propertyName, List<string> warnings)
    {
        if (!root.TryGetProperty(propertyName, out JsonElement element) || element.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<ModDependency>();
        }

        List<ModDependency> rules = new();
        foreach (JsonElement item in element.EnumerateArray())
        {
            if (item.ValueKind == JsonValueKind.String)
            {
                string dependencyId = (item.GetString() ?? "").Trim();
                if (!string.IsNullOrWhiteSpace(dependencyId))
                {
                    rules.Add(new ModDependency { id = dependencyId });
                }

                continue;
            }

            if (item.ValueKind != JsonValueKind.Object)
            {
                warnings.Add($"{propertyName} entries should be strings or objects.");
                continue;
            }

            string id = GetString(item, "id");
            string version = GetString(item, "version");
            if (string.IsNullOrWhiteSpace(id))
            {
                warnings.Add($"{propertyName} entry is missing id.");
                continue;
            }

            if (!string.IsNullOrWhiteSpace(version) && !VersionConstraint.IsValid(version))
            {
                warnings.Add($"{propertyName} constraint for '{id}' is not valid: {version}");
            }

            rules.Add(new ModDependency { id = id, version = version });
        }

        return rules
            .GroupBy(rule => rule.id, StringComparer.OrdinalIgnoreCase)
            .Select(group => group.First())
            .ToArray();
    }

    private static string GetString(JsonElement root, string propertyName)
    {
        if (!root.TryGetProperty(propertyName, out JsonElement element) || element.ValueKind != JsonValueKind.String)
        {
            return "";
        }

        return (element.GetString() ?? "").Trim();
    }

    private static bool GetBool(JsonElement root, string propertyName, bool fallback)
    {
        if (!root.TryGetProperty(propertyName, out JsonElement element))
        {
            return fallback;
        }

        return element.ValueKind switch
        {
            JsonValueKind.True => true,
            JsonValueKind.False => false,
            _ => fallback
        };
    }

    private static int GetInt(JsonElement root, string propertyName, int fallback)
    {
        if (!root.TryGetProperty(propertyName, out JsonElement element) || element.ValueKind != JsonValueKind.Number)
        {
            return fallback;
        }

        return element.TryGetInt32(out int value) ? value : fallback;
    }

    private static string[] GetStringArray(JsonElement root, string propertyName)
    {
        if (!root.TryGetProperty(propertyName, out JsonElement element) || element.ValueKind != JsonValueKind.Array)
        {
            return Array.Empty<string>();
        }

        return element.EnumerateArray()
            .Where(item => item.ValueKind == JsonValueKind.String)
            .Select(item => item.GetString() ?? "")
            .ToArray();
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
