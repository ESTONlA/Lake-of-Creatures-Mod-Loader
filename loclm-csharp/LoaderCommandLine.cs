public sealed class LoaderCommandLine
{
    private readonly HashSet<string> flags;

    private LoaderCommandLine(HashSet<string> flags, Dictionary<string, List<string>> values, string[] gameArgs)
    {
        this.flags = flags;
        Values = values;
        GameArgs = gameArgs;
    }

    public string[] GameArgs { get; }
    public IReadOnlyDictionary<string, List<string>> Values { get; }
    public bool Diagnose => Has("--diagnose");
    public bool ClearCache => Has("--clear-cache");
    public bool ListMods => Has("--list-mods");
    public bool ValidateMods => Has("--validate-mods");
    public bool SafeMode => Has("--safe-mode");
    public bool DisableMenu => Has("--disable-menu");
    public bool Verbose => Has("--verbose");
    public bool Quiet => Has("--quiet");
    public bool Repair => Has("--repair");
    public bool RollbackCache => Has("--rollback-cache");
    public bool StrictMode => Has("--strict");
    public bool RelaxedMode => Has("--relaxed");
    public bool HasEnableOrDisableMod => GetValues("--enable-mod").Count > 0 || GetValues("--disable-mod").Count > 0;
    public bool HasUnquarantine => GetValues("--unquarantine").Count > 0;
    public bool UtilityMode => Diagnose || ClearCache || ListMods || ValidateMods || Repair || RollbackCache || HasEnableOrDisableMod || HasUnquarantine;
    public IReadOnlyList<string> EnableMods => GetValues("--enable-mod");
    public IReadOnlyList<string> DisableMods => GetValues("--disable-mod");
    public IReadOnlyList<string> UnquarantineMods => GetValues("--unquarantine");

    public static LoaderCommandLine Parse(string[] args)
    {
        string[] loaderFlags =
        {
            "--diagnose",
            "--clear-cache",
            "--list-mods",
            "--validate-mods",
            "--safe-mode",
            "--disable-menu",
            "--verbose",
            "--quiet",
            "--repair",
            "--rollback-cache",
            "--strict",
            "--relaxed"
        };
        string[] valueFlags =
        {
            "--enable-mod",
            "--disable-mod",
            "--unquarantine"
        };

        HashSet<string> known = loaderFlags.ToHashSet(StringComparer.OrdinalIgnoreCase);
        HashSet<string> knownValues = valueFlags.ToHashSet(StringComparer.OrdinalIgnoreCase);
        HashSet<string> flags = new(StringComparer.OrdinalIgnoreCase);
        Dictionary<string, List<string>> values = new(StringComparer.OrdinalIgnoreCase);
        List<string> gameArgs = new();
        string[] remaining = args.Skip(2).ToArray();
        for (int i = 0; i < remaining.Length; i++)
        {
            string arg = remaining[i];
            string flag = arg;
            string? value = null;
            int equals = arg.IndexOf('=');
            if (equals > 0)
            {
                flag = arg[..equals];
                value = arg[(equals + 1)..];
            }

            if (known.Contains(arg))
            {
                flags.Add(arg);
            }
            else if (knownValues.Contains(flag))
            {
                if (value is null && i + 1 < remaining.Length)
                {
                    value = remaining[++i];
                }

                if (!string.IsNullOrWhiteSpace(value))
                {
                    if (!values.TryGetValue(flag, out List<string>? list))
                    {
                        list = new List<string>();
                        values[flag] = list;
                    }

                    list.Add(value.Trim());
                }
            }
            else
            {
                gameArgs.Add(arg);
            }
        }

        return new LoaderCommandLine(flags, values, gameArgs.ToArray());
    }

    private bool Has(string flag) => flags.Contains(flag);
    private IReadOnlyList<string> GetValues(string flag) =>
        Values.TryGetValue(flag, out List<string>? values) ? values : Array.Empty<string>();
}
