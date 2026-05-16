using System.Security.Cryptography;
using System.Text;
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
    private readonly Dictionary<string, string> owners = new(StringComparer.OrdinalIgnoreCase);

    public void LogChanges(string modName, ResourceSnapshot before, ResourceSnapshot after, Action<string> info, Action<string> warn)
    {
        ResourceDelta delta = ResourceDelta.Create(before, after);
        if (!delta.HasChanges)
        {
            info($"Mod \"{modName}\" did not change tracked resources.");
            return;
        }

        info($"Mod \"{modName}\" changed {delta.TotalChangeCount} tracked resource(s).");
        foreach (string line in delta.Describe())
        {
            info($"  {line}");
        }

        foreach (string key in delta.TouchedKeys)
        {
            if (owners.TryGetValue(key, out string? previousOwner) &&
                !string.Equals(previousOwner, modName, StringComparison.OrdinalIgnoreCase))
            {
                warn($"Potential mod conflict: \"{modName}\" and \"{previousOwner}\" both changed {key}.");
            }
            else
            {
                owners[key] = modName;
            }
        }
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
        if (resources is null)
        {
            return result;
        }

        foreach (T resource in resources)
        {
            string name = resource.Name?.Content ?? "<unnamed resource>";
            result[name] = resource.GetType().Name;
        }

        return result;
    }

    private static Dictionary<string, string> CaptureStrings(IList<UndertaleString>? strings)
    {
        Dictionary<string, string> result = new(StringComparer.OrdinalIgnoreCase);
        if (strings is null)
        {
            return result;
        }

        foreach (UndertaleString str in strings)
        {
            string value = str.Content ?? "";
            result[value] = value.Length.ToString();
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

    public IEnumerable<string> TouchedKeys =>
        added.SelectMany(pair => pair.Value.Select(name => $"{pair.Key}:{name}"))
            .Concat(removed.SelectMany(pair => pair.Value.Select(name => $"{pair.Key}:{name}")))
            .Concat(changed.SelectMany(pair => pair.Value.Select(name => $"{pair.Key}:{name}")));

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
