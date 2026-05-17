using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;
using UndertaleModLib;
using UndertaleModLib.Models;

public static class LoaderLogger
{
    private static readonly object LockObject = new();
    private static string? logPath;

    public static void Initialize(string path, string loaderVersion)
    {
        logPath = path;
        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        WriteRaw("");
        WriteRaw("==================================================");
        WriteRaw($"LOCLM session started {DateTime.Now:yyyy-MM-dd HH:mm:ss}");
        WriteRaw($"Loader version: {loaderVersion}");
        WriteRaw($"Machine: {Environment.MachineName}");
        WriteRaw($"OS: {Environment.OSVersion}");
        WriteRaw($".NET: {Environment.Version}");
        WriteRaw("==================================================");
    }

    public static void WriteRaw(string message)
    {
        if (string.IsNullOrWhiteSpace(logPath))
        {
            return;
        }

        lock (LockObject)
        {
            File.AppendAllText(logPath, $"[{DateTime.Now:HH:mm:ss}] {message}{Environment.NewLine}");
        }
    }
}

public sealed class ResourceChangeTracker
{
    private readonly Dictionary<string, ResourceOwner> owners = new(StringComparer.OrdinalIgnoreCase);
    private readonly Dictionary<string, string> globalVariableOwners = new(StringComparer.OrdinalIgnoreCase);
    private readonly Dictionary<int, string> buttonIndexOwners = new();
    private readonly Dictionary<int, string> menuIdOwners = new();
    private readonly List<ModConflict> conflicts = new();

    public IReadOnlyList<ModConflict> Conflicts => conflicts;

    public ResourceDelta LogChanges(
        string modName,
        ResourceSnapshot before,
        ResourceSnapshot after,
        UndertaleData data,
        Action<string> info,
        Action<string> warn)
    {
        ResourceDelta delta = ResourceDelta.Create(before, after);
        if (!delta.HasChanges)
        {
            info($"Mod \"{modName}\" did not change tracked resources.");
            return delta;
        }

        info($"Mod \"{modName}\" changed {delta.TotalChangeCount} tracked resource(s).");
        foreach (string line in delta.Describe())
        {
            info($"  {line}");
        }

        foreach (ResourceTouch touch in delta.TouchedResources)
        {
            string key = touch.Key;
            if (owners.TryGetValue(key, out ResourceOwner? previousOwner) &&
                !string.Equals(previousOwner.ModName, modName, StringComparison.OrdinalIgnoreCase))
            {
                ModConflict conflict = ModConflict.ForResource(modName, previousOwner, touch);
                AddConflict(conflict, warn);
            }
            else
            {
                owners[key] = new ResourceOwner(modName, touch.ChangeKind);
            }
        }

        CodeUsage usage = CodeUsage.Extract(data, delta.ChangedCodeNames);
        foreach (string globalVariable in usage.GlobalVariables)
        {
            TrackNamedUsage(globalVariableOwners, globalVariable, modName, "global_variable", "Soft", warn);
        }

        foreach (int buttonIndex in usage.ButtonIndexes)
        {
            TrackNumberUsage(buttonIndexOwners, buttonIndex, modName, "button_index", "High", warn);
        }

        foreach (int menuId in usage.MenuIds)
        {
            TrackNumberUsage(menuIdOwners, menuId, modName, "menu_id", "Medium", warn);
        }

        return delta;
    }

    public IReadOnlyList<string> BuildMenuSummaries(int maxItems = 8) =>
        conflicts
            .OrderByDescending(conflict => conflict.SeverityRank)
            .ThenBy(conflict => conflict.Resource, StringComparer.OrdinalIgnoreCase)
            .Take(maxItems)
            .Select(conflict => $"{conflict.Severity}: {conflict.Resource} ({conflict.FirstMod} / {conflict.SecondMod})")
            .ToArray();

    public void WriteReport(string path)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        ConflictReport report = new()
        {
            generatedUtc = DateTime.UtcNow.ToString("O"),
            conflictCount = conflicts.Count,
            conflicts = conflicts.OrderByDescending(conflict => conflict.SeverityRank)
                .ThenBy(conflict => conflict.Resource, StringComparer.OrdinalIgnoreCase)
                .ToList()
        };

        JsonSerializerOptions options = new() { WriteIndented = true };
        File.WriteAllText(path, JsonSerializer.Serialize(report, options));
    }

    private void TrackNamedUsage(
        Dictionary<string, string> usageOwners,
        string resource,
        string modName,
        string type,
        string severity,
        Action<string> warn)
    {
        if (usageOwners.TryGetValue(resource, out string? previousOwner) &&
            !string.Equals(previousOwner, modName, StringComparison.OrdinalIgnoreCase))
        {
            AddConflict(ModConflict.ForSharedUsage(type, severity, resource, previousOwner, modName), warn);
            return;
        }

        usageOwners[resource] = modName;
    }

    private void TrackNumberUsage(
        Dictionary<int, string> usageOwners,
        int resource,
        string modName,
        string type,
        string severity,
        Action<string> warn)
    {
        if (usageOwners.TryGetValue(resource, out string? previousOwner) &&
            !string.Equals(previousOwner, modName, StringComparison.OrdinalIgnoreCase))
        {
            AddConflict(ModConflict.ForSharedUsage(type, severity, resource.ToString(), previousOwner, modName), warn);
            return;
        }

        usageOwners[resource] = modName;
    }

    private void AddConflict(ModConflict conflict, Action<string> warn)
    {
        if (conflicts.Any(existing => existing.ConflictKey == conflict.ConflictKey))
        {
            return;
        }

        conflicts.Add(conflict);
        warn($"{conflict.Severity} mod conflict: {conflict.Message} {conflict.HarmlessNote}");
        warn($"Suggested fix: {conflict.SuggestedFix}");
    }
}

public sealed class ResourceSnapshot
{
    public ResourceSnapshot(Dictionary<string, Dictionary<string, string>> resources)
    {
        Resources = resources;
    }

    public Dictionary<string, Dictionary<string, string>> Resources { get; }

    public static ResourceSnapshot Capture(UndertaleData data)
    {
        Dictionary<string, Dictionary<string, string>> resources = new(StringComparer.OrdinalIgnoreCase)
        {
            ["Code"] = CaptureCode(data.Code),
            ["Sprites"] = CaptureNames(data.Sprites),
            ["Sounds"] = CaptureNames(data.Sounds),
            ["GameObjects"] = CaptureNames(data.GameObjects),
            ["Scripts"] = CaptureNames(data.Scripts),
            ["Rooms"] = CaptureNames(data.Rooms),
            ["Functions"] = CaptureNames(data.Functions),
            ["Variables"] = CaptureNames(data.Variables),
            ["Strings"] = CaptureStrings(data.Strings)
        };

        return new ResourceSnapshot(resources);
    }

    private static Dictionary<string, string> CaptureCode(IList<UndertaleCode>? codes)
    {
        Dictionary<string, string> result = new(StringComparer.OrdinalIgnoreCase);
        if (codes is null)
        {
            return result;
        }

        foreach (UndertaleCode code in codes)
        {
            string name = code.Name?.Content ?? "<unnamed code>";
            result[name] = FingerprintCode(code);
        }

        return result;
    }

    private static Dictionary<string, string> CaptureNames<T>(IList<T>? resources)
        where T : UndertaleNamedResource
    {
        Dictionary<string, string> result = new(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, int> counts = new(StringComparer.OrdinalIgnoreCase);
        if (resources is null)
        {
            return result;
        }

        foreach (T resource in resources)
        {
            string name = resource.Name?.Content ?? "<unnamed resource>";
            counts.TryGetValue(name, out int count);
            count++;
            counts[name] = count;
            result[name] = $"{resource.GetType().Name}|count={count}";
        }

        return result;
    }

    private static Dictionary<string, string> CaptureStrings(IList<UndertaleString>? strings)
    {
        Dictionary<string, string> result = new(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, int> counts = new(StringComparer.OrdinalIgnoreCase);
        if (strings is null)
        {
            return result;
        }

        foreach (UndertaleString str in strings)
        {
            string value = str.Content ?? "";
            counts.TryGetValue(value, out int count);
            count++;
            counts[value] = count;
            result[value] = $"length={value.Length}|count={count}";
        }

        return result;
    }

    private static string FingerprintCode(UndertaleCode code)
    {
        StringBuilder builder = new();
        builder.AppendLine(code.Name?.Content ?? "");
        builder.AppendLine(code.Length.ToString());
        builder.AppendLine(code.LocalsCount.ToString());
        builder.AppendLine(code.ArgumentsCount.ToString());
        builder.AppendLine(code.Offset.ToString());
        builder.AppendLine(code.Instructions.Count.ToString());
        foreach (UndertaleInstruction instruction in code.Instructions)
        {
            builder.AppendLine(instruction.ToString());
        }

        return Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(builder.ToString())));
    }
}

public sealed class ResourceDelta
{
    private readonly Dictionary<string, List<string>> added = new(StringComparer.OrdinalIgnoreCase);
    private readonly Dictionary<string, List<string>> removed = new(StringComparer.OrdinalIgnoreCase);
    private readonly Dictionary<string, List<string>> changed = new(StringComparer.OrdinalIgnoreCase);

    public IEnumerable<ResourceTouch> TouchedResources =>
        added.SelectMany(pair => pair.Value.Select(name => new ResourceTouch(pair.Key, name, "added")))
            .Concat(removed.SelectMany(pair => pair.Value.Select(name => new ResourceTouch(pair.Key, name, "removed"))))
            .Concat(changed.SelectMany(pair => pair.Value.Select(name => new ResourceTouch(pair.Key, name, "changed"))));

    public IEnumerable<string> ChangedCodeNames =>
        changed.TryGetValue("Code", out List<string>? names)
            ? names
            : Array.Empty<string>();

    public int TotalChangeCount =>
        added.Values.Sum(list => list.Count) +
        removed.Values.Sum(list => list.Count) +
        changed.Values.Sum(list => list.Count);

    public bool HasChanges => TotalChangeCount > 0;

    public static ResourceDelta Create(ResourceSnapshot before, ResourceSnapshot after)
    {
        ResourceDelta delta = new();
        foreach ((string category, Dictionary<string, string> afterResources) in after.Resources)
        {
            before.Resources.TryGetValue(category, out Dictionary<string, string>? beforeResources);
            beforeResources ??= new Dictionary<string, string>(StringComparer.OrdinalIgnoreCase);

            List<string> addedNames = afterResources.Keys.Except(beforeResources.Keys, StringComparer.OrdinalIgnoreCase).OrderBy(name => name).ToList();
            List<string> removedNames = beforeResources.Keys.Except(afterResources.Keys, StringComparer.OrdinalIgnoreCase).OrderBy(name => name).ToList();
            List<string> changedNames = afterResources
                .Where(pair => beforeResources.TryGetValue(pair.Key, out string? previousHash) && previousHash != pair.Value)
                .Select(pair => pair.Key)
                .OrderBy(name => name)
                .ToList();

            if (addedNames.Count > 0)
            {
                delta.added[category] = addedNames;
            }

            if (removedNames.Count > 0)
            {
                delta.removed[category] = removedNames;
            }

            if (changedNames.Count > 0)
            {
                delta.changed[category] = changedNames;
            }
        }

        return delta;
    }

    public IEnumerable<string> Describe()
    {
        foreach (string line in DescribeGroup("added", added))
        {
            yield return line;
        }

        foreach (string line in DescribeGroup("removed", removed))
        {
            yield return line;
        }

        foreach (string line in DescribeGroup("changed", changed))
        {
            yield return line;
        }
    }

    private static IEnumerable<string> DescribeGroup(string label, Dictionary<string, List<string>> group)
    {
        foreach ((string category, List<string> names) in group.OrderBy(pair => pair.Key))
        {
            foreach (string chunk in ChunkNames(names))
            {
                yield return $"{category} {label}: {chunk}";
            }
        }
    }

    private static IEnumerable<string> ChunkNames(List<string> names)
    {
        const int maxNames = 8;
        for (int i = 0; i < names.Count; i += maxNames)
        {
            IEnumerable<string> chunk = names.Skip(i).Take(maxNames);
            string suffix = i + maxNames < names.Count ? " ..." : "";
            yield return string.Join(", ", chunk) + suffix;
        }
    }
}

public sealed record ResourceTouch(string Category, string Name, string ChangeKind)
{
    public string Key => $"{Category}:{Name}";
}

public sealed record ResourceOwner(string ModName, string ChangeKind);

public sealed class ModConflict
{
    public string Type { get; set; } = "";
    public string Severity { get; set; } = "";
    public int SeverityRank { get; set; }
    public string Resource { get; set; } = "";
    public string FirstMod { get; set; } = "";
    public string SecondMod { get; set; } = "";
    public string Message { get; set; } = "";
    public string SuggestedFix { get; set; } = "";
    public bool MayBeHarmless { get; set; }
    public string HarmlessNote => MayBeHarmless ? "This may be harmless if both mods intentionally cooperate." : "";
    public string ConflictKey => $"{Type}|{Resource}|{FirstMod}|{SecondMod}";

    public static ModConflict ForResource(string modName, ResourceOwner previousOwner, ResourceTouch touch)
    {
        string type = ClassifyResourceType(touch);
        string severity = ClassifySeverity(touch);
        return new ModConflict
        {
            Type = type,
            Severity = severity,
            SeverityRank = SeverityToRank(severity),
            Resource = touch.Key,
            FirstMod = previousOwner.ModName,
            SecondMod = modName,
            Message = $"\"{previousOwner.ModName}\" and \"{modName}\" both touched {touch.Key}.",
            SuggestedFix = BuildSuggestedFix(touch.Key, previousOwner.ModName, modName, severity),
            MayBeHarmless = severity == "Soft" || severity == "Medium"
        };
    }

    public static ModConflict ForSharedUsage(string type, string severity, string resource, string firstMod, string secondMod)
    {
        string resourceLabel = $"{type}:{resource}";
        return new ModConflict
        {
            Type = type,
            Severity = severity,
            SeverityRank = SeverityToRank(severity),
            Resource = resourceLabel,
            FirstMod = firstMod,
            SecondMod = secondMod,
            Message = $"\"{firstMod}\" and \"{secondMod}\" both use {resourceLabel}.",
            SuggestedFix = BuildSuggestedFix(resourceLabel, firstMod, secondMod, severity),
            MayBeHarmless = severity != "High"
        };
    }

    private static string ClassifyResourceType(ResourceTouch touch)
    {
        if (touch.Category == "Code" && touch.ChangeKind == "changed")
        {
            return "script_patch";
        }

        if (touch.Category == "Sounds")
        {
            return touch.ChangeKind == "added" ? "sound_create" : "sound_replace";
        }

        if (touch.Category == "Sprites")
        {
            return touch.ChangeKind == "added" ? "sprite_create" : "sprite_replace";
        }

        return touch.ChangeKind == "added" ? "resource_create" : "resource_touch";
    }

    private static string ClassifySeverity(ResourceTouch touch)
    {
        if (touch.Category == "Code" && touch.ChangeKind == "changed")
        {
            return "High";
        }

        if (touch.Category is "Sprites" or "Sounds" && touch.ChangeKind == "changed")
        {
            return "High";
        }

        if (touch.ChangeKind == "added")
        {
            return "Medium";
        }

        return "Soft";
    }

    private static int SeverityToRank(string severity) =>
        severity switch
        {
            "High" => 3,
            "Medium" => 2,
            _ => 1
        };

    private static string BuildSuggestedFix(string resource, string firstMod, string secondMod, string severity)
    {
        if (severity == "High")
        {
            return $"Try disabling one mod, or ask the authors to coordinate patches for {resource}. Load order may decide which mod wins.";
        }

        return $"Check whether {firstMod} and {secondMod} intentionally share {resource}. If not, change the resource name, button index, menu ID, or load order.";
    }
}

public sealed class ConflictReport
{
    public string generatedUtc { get; set; } = "";
    public int conflictCount { get; set; }
    public List<ModConflict> conflicts { get; set; } = new();
}

public sealed class CodeUsage
{
    private static readonly Regex GlobalVariableRegex = new(@"global\.([A-Za-z_][A-Za-z0-9_]*)", RegexOptions.Compiled);
    private static readonly Regex NumberRegex = new(@"-?\d+", RegexOptions.Compiled);

    public HashSet<string> GlobalVariables { get; } = new(StringComparer.OrdinalIgnoreCase);
    public HashSet<int> ButtonIndexes { get; } = new();
    public HashSet<int> MenuIds { get; } = new();

    public static CodeUsage Extract(UndertaleData data, IEnumerable<string> changedCodeNames)
    {
        CodeUsage usage = new();
        foreach (string codeName in changedCodeNames)
        {
            UndertaleCode? code = data.Code.FirstOrDefault(candidate =>
                string.Equals(candidate.Name?.Content, codeName, StringComparison.OrdinalIgnoreCase));
            if (code is null)
            {
                continue;
            }

            List<string> lines = code.Instructions.Select(instruction => instruction.ToString()).ToList();
            ExtractGlobalVariables(lines, usage.GlobalVariables);
            ExtractNearbyNumbers(lines, "button_index", usage.ButtonIndexes);
            ExtractNearbyNumbers(lines, "current_menu", usage.MenuIds);
            ExtractNearbyNumbers(lines, "menu", usage.MenuIds);
        }

        return usage;
    }

    private static void ExtractGlobalVariables(IEnumerable<string> lines, HashSet<string> globals)
    {
        foreach (string line in lines)
        {
            foreach (Match match in GlobalVariableRegex.Matches(line))
            {
                globals.Add(match.Groups[1].Value);
            }
        }
    }

    private static void ExtractNearbyNumbers(IReadOnlyList<string> lines, string needle, HashSet<int> values)
    {
        for (int i = 0; i < lines.Count; i++)
        {
            if (!lines[i].Contains(needle, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            int start = Math.Max(0, i - 3);
            int end = Math.Min(lines.Count - 1, i + 3);
            for (int j = start; j <= end; j++)
            {
                foreach (Match match in NumberRegex.Matches(lines[j]))
                {
                    if (int.TryParse(match.Value, out int value) && value >= 0 && value <= 999)
                    {
                        values.Add(value);
                    }
                }
            }
        }
    }
}
