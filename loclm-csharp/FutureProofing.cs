using System.Text;
using System.Text.Json;
using UndertaleModLib;
using UndertaleModLib.Models;

public static class FutureProofing
{
    private const string ResourceMapVersion = "antenni-resource-map-v1";

    private static readonly string[] RequiredMenuResources =
    {
        "obj_button_menu",
        "obj_ctrl_main_menu",
        "gml_GlobalScript_main_menu_spawn_buttons",
        "gml_Object_obj_ctrl_main_menu_Draw_0",
        "gml_Object_obj_ctrl_main_menu_Step_0"
    };

    private static readonly string[] MenuInjectionTargets =
    {
        "gml_GlobalScript_main_menu_spawn_buttons",
        "gml_Object_obj_ctrl_main_menu_Draw_0",
        "gml_Object_obj_ctrl_main_menu_Step_0"
    };

    public static FutureProofingReport Run(
        UndertaleData data,
        GameCompatibilityInfo gameCompatibility,
        string logsDirectory,
        string loaderDirectory,
        GameProfile gameProfile,
        string loaderVersion,
        Action<string> info,
        Action<string> warn)
    {
        Directory.CreateDirectory(logsDirectory);
        string baselinePath = Path.Combine(logsDirectory, "game_resource_baseline.json");
        string reportPath = Path.Combine(logsDirectory, "game_compatibility_report.json");
        ResourceMap current = ResourceMap.Capture(data, gameCompatibility, gameProfile, loaderVersion);
        ResourceMap? previous = LoadResourceMap(baselinePath, warn);
        if (previous is not null &&
            !string.Equals(previous.GameId, gameProfile.Id, StringComparison.OrdinalIgnoreCase))
        {
            previous = null;
        }
        SupportedGameBuildList supportedBuilds = SupportedGameBuildList.Load(Path.Combine(loaderDirectory, "supported_game_builds.json"), warn);
        BuildCompatibility buildCompatibility = supportedBuilds.Match(gameCompatibility);

        FutureProofingReport report = new()
        {
            GeneratedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = loaderVersion,
            DataWinSha256 = gameCompatibility.DataWinSha256,
            GameExecutableSha256 = gameCompatibility.GameExecutableSha256,
            KnownGameBuild = buildCompatibility.IsKnown,
            GameBuildName = buildCompatibility.Name,
            SupportedBuildListPath = supportedBuilds.SourcePath,
            PreviousBaselineDataWinSha256 = previous?.DataWinSha256 ?? "",
            RequiredResources = gameProfile.SupportsInGameMenu ? CheckRequiredResources(current) : new List<ResourceCheck>(),
            ChangedMenuTargets = gameProfile.SupportsInGameMenu ? CompareMenuTargets(previous, current) : new List<ChangedMenuTarget>()
        };

        if (!buildCompatibility.IsKnown)
        {
            string message = supportedBuilds.Builds.Count == 0
                ? "Unknown game build: supported_game_builds.json has no known builds yet."
                : "Unknown game build: current data.win/exe hash is not in supported_game_builds.json.";
            report.Warnings.Add(message);
            warn(message);
        }
        else
        {
            info($"Known game build: {buildCompatibility.Name}");
        }

        foreach (ResourceCheck check in report.RequiredResources.Where(check => !check.Exists))
        {
            string message = $"Required game resource is missing after update: {check.Name}. Antenni menu injection or mods may break.";
            report.Warnings.Add(message);
            warn(message);
        }

        foreach (ChangedMenuTarget changed in report.ChangedMenuTargets)
        {
            string message = changed.IsInjectionTarget
                ? $"Antenni menu injection target changed since previous baseline: {changed.Name}."
                : $"Required menu script changed since previous baseline: {changed.Name}.";
            report.Warnings.Add(message);
            warn(message);
        }

        SaveJson(reportPath, report);
        SaveJson(baselinePath, current);
        info($"Wrote game compatibility report: {reportPath}");
        info($"Wrote resource map baseline: {baselinePath}");
        return report;
    }

    private static List<ResourceCheck> CheckRequiredResources(ResourceMap map) =>
        RequiredMenuResources
            .Select(name => new ResourceCheck
            {
                Name = name,
                Exists = map.ContainsResource(name)
            })
            .ToList();

    private static List<ChangedMenuTarget> CompareMenuTargets(ResourceMap? previous, ResourceMap current)
    {
        List<ChangedMenuTarget> changed = new();
        if (previous is null || string.Equals(previous.DataWinSha256, current.DataWinSha256, StringComparison.OrdinalIgnoreCase))
        {
            return changed;
        }

        foreach (string name in RequiredMenuResources)
        {
            string previousFingerprint = previous.GetFingerprint(name);
            string currentFingerprint = current.GetFingerprint(name);
            if (previousFingerprint.Length == 0 || currentFingerprint.Length == 0)
            {
                continue;
            }

            if (!string.Equals(previousFingerprint, currentFingerprint, StringComparison.OrdinalIgnoreCase))
            {
                changed.Add(new ChangedMenuTarget
                {
                    Name = name,
                    PreviousFingerprint = previousFingerprint,
                    CurrentFingerprint = currentFingerprint,
                    IsInjectionTarget = MenuInjectionTargets.Contains(name, StringComparer.OrdinalIgnoreCase)
                });
            }
        }

        return changed;
    }

    private static ResourceMap? LoadResourceMap(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return null;
        }

        try
        {
            return JsonSerializer.Deserialize<ResourceMap>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions);
        }
        catch (Exception ex)
        {
            warn("Could not read previous resource baseline: " + ex.Message);
            return null;
        }
    }

    private static void SaveJson<T>(string path, T value)
    {
        File.WriteAllText(path, JsonSerializer.Serialize(value, JsonUtil.IndentedOptions));
    }
}

public sealed class FutureProofingReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public string DataWinSha256 { get; set; } = "";
    public string GameExecutableSha256 { get; set; } = "";
    public bool KnownGameBuild { get; set; }
    public string GameBuildName { get; set; } = "";
    public string SupportedBuildListPath { get; set; } = "";
    public string PreviousBaselineDataWinSha256 { get; set; } = "";
    public List<ResourceCheck> RequiredResources { get; set; } = new();
    public List<ChangedMenuTarget> ChangedMenuTargets { get; set; } = new();
    public List<string> Warnings { get; set; } = new();
}

public sealed class ResourceCheck
{
    public string Name { get; set; } = "";
    public bool Exists { get; set; }
}

public sealed class ChangedMenuTarget
{
    public string Name { get; set; } = "";
    public string PreviousFingerprint { get; set; } = "";
    public string CurrentFingerprint { get; set; } = "";
    public bool IsInjectionTarget { get; set; }
}

public sealed class ResourceMap
{
    public string ResourceMapVersion { get; set; } = "";
    public string CapturedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public string GameId { get; set; } = "";
    public string DataWinSha256 { get; set; } = "";
    public string GameExecutableSha256 { get; set; } = "";
    public Dictionary<string, List<ResourceMapEntry>> Resources { get; set; } = new(StringComparer.OrdinalIgnoreCase);

    public static ResourceMap Capture(
        UndertaleData data,
        GameCompatibilityInfo compatibility,
        GameProfile gameProfile,
        string loaderVersion) =>
        new()
        {
            ResourceMapVersion = "antenni-resource-map-v1",
            CapturedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = loaderVersion,
            GameId = gameProfile.Id,
            DataWinSha256 = compatibility.DataWinSha256,
            GameExecutableSha256 = compatibility.GameExecutableSha256,
            Resources = new Dictionary<string, List<ResourceMapEntry>>(StringComparer.OrdinalIgnoreCase)
            {
                ["Code"] = data.Code.Select(code => ResourceMapEntry.From(code.Name?.Content ?? "", FingerprintCode(code))).ToList(),
                ["GameObjects"] = data.GameObjects.Select(obj => ResourceMapEntry.From(obj.Name?.Content ?? "", "object")).ToList(),
                ["Sprites"] = data.Sprites.Select(sprite => ResourceMapEntry.From(sprite.Name?.Content ?? "", "sprite")).ToList(),
                ["Sounds"] = data.Sounds.Select(sound => ResourceMapEntry.From(sound.Name?.Content ?? "", "sound")).ToList(),
                ["Rooms"] = data.Rooms.Select(room => ResourceMapEntry.From(room.Name?.Content ?? "", "room")).ToList(),
                ["Scripts"] = data.Scripts.Select(script => ResourceMapEntry.From(script.Name?.Content ?? "", "script")).ToList(),
                ["Functions"] = data.Functions.Select(function => ResourceMapEntry.From(function.Name?.Content ?? "", "function")).ToList(),
                ["Variables"] = data.Variables.Select(variable => ResourceMapEntry.From(variable.Name?.Content ?? "", "variable")).ToList()
            }
        };

    public bool ContainsResource(string name) =>
        Resources.Values.Any(entries => entries.Any(entry => string.Equals(entry.Name, name, StringComparison.OrdinalIgnoreCase)));

    public string GetFingerprint(string name)
    {
        foreach (List<ResourceMapEntry> entries in Resources.Values)
        {
            ResourceMapEntry? entry = entries.FirstOrDefault(candidate =>
                string.Equals(candidate.Name, name, StringComparison.OrdinalIgnoreCase));
            if (entry is not null)
            {
                return entry.Fingerprint;
            }
        }

        return "";
    }

    private static string FingerprintCode(UndertaleCode code)
    {
        StringBuilder builder = new();
        builder.AppendLine(code.Name?.Content ?? "");
        builder.AppendLine(code.Length.ToString());
        builder.AppendLine(code.LocalsCount.ToString());
        builder.AppendLine(code.ArgumentsCount.ToString());
        builder.AppendLine(code.Instructions.Count.ToString());
        foreach (UndertaleInstruction instruction in code.Instructions)
        {
            builder.AppendLine(instruction.ToString());
        }

        return HashUtil.ComputeStringSha256(builder.ToString());
    }
}

public sealed class ResourceMapEntry
{
    public string Name { get; set; } = "";
    public string Fingerprint { get; set; } = "";

    public static ResourceMapEntry From(string name, string fingerprint) =>
        new()
        {
            Name = name,
            Fingerprint = fingerprint
        };
}

public sealed class SupportedGameBuildList
{
    public string SourcePath { get; set; } = "";
    public List<SupportedGameBuild> Builds { get; set; } = new();

    public static SupportedGameBuildList Load(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return new SupportedGameBuildList { SourcePath = path };
        }

        try
        {
            SupportedGameBuildList? list = JsonSerializer.Deserialize<SupportedGameBuildList>(File.ReadAllText(path), JsonUtil.CaseInsensitiveOptions);
            list ??= new SupportedGameBuildList();
            list.SourcePath = path;
            return list;
        }
        catch (Exception ex)
        {
            warn("Could not read supported_game_builds.json: " + ex.Message);
            return new SupportedGameBuildList { SourcePath = path };
        }
    }

    public BuildCompatibility Match(GameCompatibilityInfo compatibility)
    {
        foreach (SupportedGameBuild build in Builds)
        {
            bool dataMatches = string.IsNullOrWhiteSpace(build.DataWinSha256) ||
                compatibility.DataWinSha256.StartsWith(build.DataWinSha256, StringComparison.OrdinalIgnoreCase);
            bool exeMatches = string.IsNullOrWhiteSpace(build.GameExecutableSha256) ||
                compatibility.GameExecutableSha256.StartsWith(build.GameExecutableSha256, StringComparison.OrdinalIgnoreCase);
            if (dataMatches && exeMatches)
            {
                return new BuildCompatibility(true, build.Name);
            }
        }

        return new BuildCompatibility(false, "");
    }
}

public sealed class SupportedGameBuild
{
    public string Name { get; set; } = "";
    public string DataWinSha256 { get; set; } = "";
    public string GameExecutableSha256 { get; set; } = "";
    public string Notes { get; set; } = "";
}

public sealed record BuildCompatibility(bool IsKnown, string Name);
