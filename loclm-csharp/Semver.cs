using System.Text.RegularExpressions;

public sealed record Semver(int Major, int Minor, int Patch, string Prerelease) : IComparable<Semver>
{
    private static readonly Regex Pattern = new(
        @"^(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<pre>[0-9A-Za-z.-]+))?(?:\+[0-9A-Za-z.-]+)?$",
        RegexOptions.Compiled);

    public static bool TryParse(string value, out Semver semver)
    {
        semver = new Semver(0, 0, 0, "");
        Match match = Pattern.Match((value ?? "").Trim());
        if (!match.Success)
        {
            return false;
        }

        semver = new Semver(
            int.Parse(match.Groups["major"].Value),
            int.Parse(match.Groups["minor"].Value),
            int.Parse(match.Groups["patch"].Value),
            match.Groups["pre"].Value);
        return true;
    }

    public int CompareTo(Semver? other)
    {
        if (other is null)
        {
            return 1;
        }

        int major = Major.CompareTo(other.Major);
        if (major != 0)
        {
            return major;
        }

        int minor = Minor.CompareTo(other.Minor);
        if (minor != 0)
        {
            return minor;
        }

        int patch = Patch.CompareTo(other.Patch);
        if (patch != 0)
        {
            return patch;
        }

        if (Prerelease.Length == 0 && other.Prerelease.Length > 0)
        {
            return 1;
        }
        if (Prerelease.Length > 0 && other.Prerelease.Length == 0)
        {
            return -1;
        }

        return string.Compare(Prerelease, other.Prerelease, StringComparison.OrdinalIgnoreCase);
    }
}

public static class VersionConstraint
{
    private static readonly string[] Operators = { ">=", "<=", "!=", ">", "<", "=" };

    public static bool IsValid(string constraint)
    {
        if (string.IsNullOrWhiteSpace(constraint))
        {
            return true;
        }

        return constraint
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .All(part => TryParsePart(part, out _, out _));
    }

    public static bool SatisfiedBy(string version, string constraint)
    {
        if (string.IsNullOrWhiteSpace(constraint))
        {
            return true;
        }

        if (!Semver.TryParse(version, out Semver actual))
        {
            return false;
        }

        foreach (string part in constraint.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
        {
            if (!TryParsePart(part, out string op, out Semver expected))
            {
                return false;
            }

            int compare = actual.CompareTo(expected);
            bool ok = op switch
            {
                ">" => compare > 0,
                ">=" => compare >= 0,
                "<" => compare < 0,
                "<=" => compare <= 0,
                "!=" => compare != 0,
                "=" => compare == 0,
                _ => compare == 0
            };

            if (!ok)
            {
                return false;
            }
        }

        return true;
    }

    private static bool TryParsePart(string part, out string op, out Semver version)
    {
        op = "=";
        string versionText = part.Trim();
        foreach (string candidate in Operators)
        {
            if (versionText.StartsWith(candidate, StringComparison.Ordinal))
            {
                op = candidate;
                versionText = versionText[candidate.Length..].Trim();
                break;
            }
        }

        return Semver.TryParse(versionText, out version);
    }
}
