using System.Diagnostics;
using System.Text;
using System.Text.Json;
using System.Text.RegularExpressions;

public sealed class SecurityAllowlist
{
    private readonly Dictionary<string, SecurityAllowlistEntry> entries;

    private SecurityAllowlist(IEnumerable<SecurityAllowlistEntry> entries)
    {
        this.entries = entries
            .Where(entry => !string.IsNullOrWhiteSpace(entry.Hash))
            .Select(entry =>
            {
                entry.Hash = entry.Hash.Trim().ToUpperInvariant();
                return entry;
            })
            .GroupBy(entry => entry.Hash, StringComparer.OrdinalIgnoreCase)
            .ToDictionary(group => group.Key, group => group.First(), StringComparer.OrdinalIgnoreCase);
    }

    public static SecurityAllowlist Empty { get; } = new(Array.Empty<SecurityAllowlistEntry>());

    public static SecurityAllowlist Load(string path, Action<string> warn)
    {
        if (!File.Exists(path))
        {
            return Empty;
        }

        try
        {
            using JsonDocument document = JsonDocument.Parse(File.ReadAllText(path));
            JsonElement root = document.RootElement;
            JsonElement hashArray;

            if (root.ValueKind == JsonValueKind.Array)
            {
                hashArray = root;
            }
            else if (!TryGetPropertyIgnoreCase(root, "allowedModHashes", out hashArray))
            {
                warn($"security_allowlist.json has no allowedModHashes array: {path}");
                return Empty;
            }

            if (hashArray.ValueKind != JsonValueKind.Array)
            {
                warn($"security_allowlist.json allowedModHashes must be an array: {path}");
                return Empty;
            }

            List<SecurityAllowlistEntry> entries = new();
            foreach (JsonElement item in hashArray.EnumerateArray())
            {
                if (item.ValueKind == JsonValueKind.String)
                {
                    entries.Add(new SecurityAllowlistEntry
                    {
                        Hash = item.GetString() ?? "",
                        Reason = "legacy string allowlist entry"
                    });
                }
                else if (item.ValueKind == JsonValueKind.Object)
                {
                    entries.Add(new SecurityAllowlistEntry
                    {
                        Hash = GetString(item, "hash"),
                        Reason = GetString(item, "reason"),
                        AddedBy = GetString(item, "addedBy"),
                        AddedUtc = GetString(item, "addedUtc")
                    });
                }
            }

            return new SecurityAllowlist(entries);
        }
        catch (Exception ex)
        {
            warn($"Could not read security_allowlist.json: {ex.Message}");
            return Empty;
        }
    }

    public bool Allows(string modHash) => entries.ContainsKey(NormalizeHash(modHash));

    public bool HasHash(string modHash) => Allows(modHash);

    public SecurityAllowlistEntry? GetEntry(string modHash) =>
        entries.TryGetValue(NormalizeHash(modHash), out SecurityAllowlistEntry? entry) ? entry : null;

    private static string NormalizeHash(string hash) => (hash ?? "").Trim().ToUpperInvariant();

    private static string GetString(JsonElement element, string name)
    {
        return TryGetPropertyIgnoreCase(element, name, out JsonElement value) && value.ValueKind == JsonValueKind.String
            ? value.GetString() ?? ""
            : "";
    }

    private static bool TryGetPropertyIgnoreCase(JsonElement element, string name, out JsonElement value)
    {
        foreach (JsonProperty property in element.EnumerateObject())
        {
            if (string.Equals(property.Name, name, StringComparison.OrdinalIgnoreCase))
            {
                value = property.Value;
                return true;
            }
        }

        value = default;
        return false;
    }
}

public sealed class SecurityAllowlistEntry
{
    public string Hash { get; set; } = "";
    public string Reason { get; set; } = "";
    public string AddedBy { get; set; } = "";
    public string AddedUtc { get; set; } = "";
}

public sealed class SecurityScanOptions
{
    public long MaxScanBytes { get; init; } = 16 * 1024 * 1024;
    public bool WarnOnlyDeveloperMode { get; init; }
}

public static class SecurityScanner
{
    private static readonly Regex DomainPattern = new(@"(?:https?://)?(?:[a-z0-9-]+\.)+[a-z]{2,}(?::\d+)?(?:/[^\s""'<>]*)?", RegexOptions.IgnoreCase | RegexOptions.Compiled);
    private static readonly Regex Base64Pattern = new(@"[A-Za-z0-9+/]{160,}={0,2}", RegexOptions.Compiled);

    private static readonly SuspiciousPattern[] SuspiciousPatterns =
    {
        new(
            "SEC-PROC-001",
            "critical",
            "process_spawn",
            "Starts external processes or shell commands.",
            "Mods normally should not start external programs. This is commonly abused by malware.",
            "System.Diagnostics.Process",
            "Process.Start",
            "Start-Process",
            "cmd.exe",
            "powershell",
            "pwsh.exe",
            "wscript.exe",
            "cscript.exe",
            "mshta.exe",
            "rundll32.exe",
            "regsvr32.exe"),
        new(
            "SEC-NATIVE-001",
            "high",
            "native_code",
            "Uses native process/memory APIs or P/Invoke.",
            "Native APIs can be legitimate, but they can also bypass managed safety checks.",
            "DllImport",
            "DllImportAttribute",
            "NativeLibrary.Load",
            "LoadLibrary",
            "GetProcAddress",
            "VirtualAlloc",
            "WriteProcessMemory",
            "CreateRemoteThread"),
        new(
            "SEC-NET-001",
            "high",
            "network_access",
            "Uses network clients or sockets.",
            "Network access can leak data or download additional payloads.",
            "System.Net.Http",
            "HttpClient",
            "WebClient",
            "TcpClient",
            "UdpClient",
            "System.Net.Sockets.Socket",
            "DownloadFile",
            "DownloadString"),
        new(
            "SEC-IO-001",
            "high",
            "destructive_io",
            "Deletes or overwrites files/directories.",
            "Mods should avoid destructive filesystem operations unless clearly documented.",
            "File.Delete",
            "Directory.Delete",
            "DeleteFile",
            "File.WriteAllBytes",
            "File.WriteAllText"),
        new(
            "SEC-IO-002",
            "medium",
            "write_outside_game_folder",
            "References paths commonly outside the game/mod folder.",
            "This may indicate a mod wants to write into user folders or system folders.",
            "Environment.GetFolderPath",
            "SpecialFolder",
            "%USERPROFILE%",
            "%APPDATA%",
            "AppData",
            "C:\\Users\\",
            "../",
            "..\\"),
        new(
            "SEC-REG-001",
            "medium",
            "registry_access",
            "Touches the Windows registry.",
            "Registry access is unusual for content mods and should be explained by the author.",
            "Microsoft.Win32.Registry",
            "RegistryKey"),
        new(
            "SEC-RUNTIME-001",
            "high",
            "runtime_code_loading",
            "Builds or loads code dynamically at runtime.",
            "Dynamic code loading can hide behavior from normal review.",
            "Assembly.Load",
            "Assembly.LoadFrom",
            "Reflection.Emit",
            "Convert.FromBase64String",
            "FromBase64String")
    };

    public static Dictionary<string, SecurityScanResult> ScanMods(
        IReadOnlyList<ModInfo> mods,
        string modsDirectory,
        SecurityAllowlist allowlist,
        FileHashCache? hashCache,
        SecurityScanOptions? options = null)
    {
        SecurityScanOptions scanOptions = options ?? new SecurityScanOptions();
        Dictionary<string, SecurityScanResult> results = new(StringComparer.OrdinalIgnoreCase);
        object lockObject = new();

        Parallel.ForEach(mods, mod =>
        {
            string modPath = Path.Combine(modsDirectory, Path.GetFileName(mod.modPath));
            string modFolderName = Path.GetFileName(mod.modPath);
            string dllPath = Path.Combine(modPath, modFolderName + ".dll");
            SecurityScanResult result = ScanMod(modPath, dllPath, allowlist, hashCache, scanOptions);
            lock (lockObject)
            {
                results[mod.folderName] = result;
            }
        });

        return results;
    }

    public static SecurityScanResult ScanMod(
        string modPath,
        string dllPath,
        SecurityAllowlist allowlist,
        FileHashCache? hashCache = null,
        SecurityScanOptions? options = null)
    {
        SecurityScanOptions scanOptions = options ?? new SecurityScanOptions();
        Stopwatch stopwatch = Stopwatch.StartNew();
        string modHash = ComputeModHash(modPath, hashCache);
        List<SecurityFinding> findings = new();
        List<string> skippedLargeFiles = new();
        List<string> suspiciousFiles = new();
        List<string> nativeDlls = new();
        HashSet<string> networkStrings = new(StringComparer.OrdinalIgnoreCase);
        long totalBytesScanned = 0;

        ScanFileForSuspiciousPatterns(dllPath, Path.GetFileName(dllPath), findings, skippedLargeFiles, suspiciousFiles, nativeDlls, networkStrings, scanOptions, ref totalBytesScanned);
        foreach (string filePath in EnumerateSecurityScanFiles(modPath, dllPath))
        {
            if (findings.Count >= SecurityScanResult.MaxFindings)
            {
                break;
            }

            string relativePath = Path.GetRelativePath(modPath, filePath).Replace('\\', '/');
            ScanFileForSuspiciousPatterns(filePath, relativePath, findings, skippedLargeFiles, suspiciousFiles, nativeDlls, networkStrings, scanOptions, ref totalBytesScanned);
        }

        stopwatch.Stop();
        bool isAllowlisted = findings.Count > 0 && allowlist.Allows(modHash);
        SecurityAllowlistEntry? allowlistEntry = allowlist.GetEntry(modHash);
        return new SecurityScanResult(
            modHash,
            findings,
            skippedLargeFiles,
            suspiciousFiles,
            nativeDlls,
            networkStrings.OrderBy(value => value, StringComparer.OrdinalIgnoreCase).Take(50).ToList(),
            isAllowlisted,
            allowlistEntry,
            scanOptions.WarnOnlyDeveloperMode,
            stopwatch.ElapsedMilliseconds,
            totalBytesScanned);
    }

    public static void WriteRuleDocumentation(string path)
    {
        var docs = GetRuleDocs();
        Directory.CreateDirectory(Path.GetDirectoryName(path) ?? AppContext.BaseDirectory);
        File.WriteAllText(path, JsonSerializer.Serialize(docs, JsonUtil.IndentedOptions));
    }

    public static IReadOnlyList<SecurityRuleDoc> GetRuleDocs()
    {
        List<SecurityRuleDoc> docs = SuspiciousPatterns
            .Select(pattern => new SecurityRuleDoc(pattern.RuleId, pattern.Id, pattern.Severity, pattern.Description, pattern.Documentation))
            .ToList();

        docs.AddRange(new[]
        {
            new SecurityRuleDoc("SEC-FILE-001", "script_file", "high", "Script file included in mod package.", "PowerShell, batch, VBScript, and JavaScript files are executable scripts and should be reviewed before loading the mod."),
            new SecurityRuleDoc("SEC-FILE-002", "suspicious_extension", "medium", "Suspicious executable-like file extension.", "Executable side files are unusual for LOCLM mods and can hide extra payloads."),
            new SecurityRuleDoc("SEC-NATIVE-002", "native_dll_dependency", "medium", "Native DLL dependency needs review.", "Non-loader DLL dependencies can be legitimate, but native DLLs should be reviewed because they run outside managed .NET checks."),
            new SecurityRuleDoc("SEC-OBF-001", "entropy_or_base64", "medium", "High entropy or long base64-like data detected.", "Packed or encoded data can be legitimate, but it is often used to hide behavior."),
            new SecurityRuleDoc("SEC-OBF-002", "obfuscated_name", "low", "Obfuscated-looking file name detected.", "Random-looking names can be harmless, but they make manual review harder."),
            new SecurityRuleDoc("SEC-NET-002", "network_domain_string", "low", "Network domain or URL string detected.", "Domain strings do not prove network access by themselves, but they are useful during mod review."),
            new SecurityRuleDoc("SEC-SCAN-001", "scan_size_limit", "medium", "File skipped because it exceeded the configured scan size limit.", "Huge files are not scanned to avoid excessive memory/time use. Review skipped files manually.")
        });

        return docs;
    }

    private static IEnumerable<string> EnumerateSecurityScanFiles(string modPath, string mainDllPath)
    {
        if (!Directory.Exists(modPath))
        {
            yield break;
        }

        string mainDllFullPath = Path.GetFullPath(mainDllPath);
        foreach (string filePath in Directory.GetFiles(modPath, "*", SearchOption.AllDirectories)
                     .OrderBy(path => Path.GetRelativePath(modPath, path), StringComparer.OrdinalIgnoreCase))
        {
            string fullPath = Path.GetFullPath(filePath);
            if (string.Equals(fullPath, mainDllFullPath, StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            string fileName = Path.GetFileName(filePath);
            if (IsKnownLoaderDependency(fileName))
            {
                continue;
            }

            string extension = Path.GetExtension(filePath).ToLowerInvariant();
            if (extension is ".dll" or ".exe" or ".gml" or ".cs" or ".json" or ".txt" or ".cfg" or ".ini" or ".ps1" or ".bat" or ".cmd" or ".vbs" or ".js" or ".scr" or ".pif" or ".com")
            {
                yield return filePath;
            }
        }
    }

    private static bool IsKnownLoaderDependency(string fileName) =>
        fileName.Equals("UndertaleModLib.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("Underanalyzer.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("System.Drawing.Common.dll", StringComparison.OrdinalIgnoreCase) ||
        fileName.Equals("ICSharpCode.SharpZipLib.dll", StringComparison.OrdinalIgnoreCase);

    private static void ScanFileForSuspiciousPatterns(
        string path,
        string displayPath,
        List<SecurityFinding> findings,
        List<string> skippedLargeFiles,
        List<string> suspiciousFiles,
        List<string> nativeDlls,
        HashSet<string> networkStrings,
        SecurityScanOptions options,
        ref long totalBytesScanned)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            return;
        }

        AddFileExtensionFindings(file, displayPath, findings, suspiciousFiles, nativeDlls);
        AddObfuscatedNameFinding(file.Name, displayPath, findings);

        if (file.Length > options.MaxScanBytes)
        {
            skippedLargeFiles.Add($"{displayPath} ({file.Length} bytes)");
            findings.Add(new SecurityFinding("SEC-SCAN-001", "scan_size_limit", "medium", displayPath, "File exceeded security scan size limit.", file.Length.ToString()));
            return;
        }

        byte[] bytes = File.ReadAllBytes(path);
        totalBytesScanned += bytes.Length;
        string asciiText = ExtractPrintableAscii(bytes);
        string utf16Text = Encoding.Unicode.GetString(bytes);

        foreach (Match match in DomainPattern.Matches(asciiText))
        {
            if (networkStrings.Add(match.Value) && findings.Count < SecurityScanResult.MaxFindings)
            {
                findings.Add(new SecurityFinding("SEC-NET-002", "network_domain_string", "low", displayPath, "Network domain or URL string detected.", match.Value));
            }
        }

        AddEntropyFindings(bytes, asciiText, displayPath, findings);

        foreach (SuspiciousPattern pattern in SuspiciousPatterns)
        {
            if (findings.Count >= SecurityScanResult.MaxFindings)
            {
                return;
            }

            foreach (string needle in pattern.Needles)
            {
                if (ContainsIgnoreCase(asciiText, needle) || ContainsIgnoreCase(utf16Text, needle))
                {
                    findings.Add(new SecurityFinding(pattern.RuleId, pattern.Id, pattern.Severity, displayPath, pattern.Description, needle));
                    break;
                }
            }
        }
    }

    private static void AddFileExtensionFindings(
        FileInfo file,
        string displayPath,
        List<SecurityFinding> findings,
        List<string> suspiciousFiles,
        List<string> nativeDlls)
    {
        string extension = file.Extension.ToLowerInvariant();
        if (extension is ".ps1" or ".bat" or ".cmd" or ".vbs" or ".js")
        {
            suspiciousFiles.Add(displayPath);
            findings.Add(new SecurityFinding("SEC-FILE-001", "script_file", "high", displayPath, "Script file included in mod package.", extension));
        }

        if (extension is ".exe" or ".scr" or ".pif" or ".com")
        {
            suspiciousFiles.Add(displayPath);
            findings.Add(new SecurityFinding("SEC-FILE-002", "suspicious_extension", "medium", displayPath, "Executable-like side file included in mod package.", extension));
        }

        if (extension == ".dll" && PortableExecutableInspector.GetArchitecture(file.FullName) is "x64" or "x86" or "arm64" or "native-unknown")
        {
            nativeDlls.Add(displayPath);
            findings.Add(new SecurityFinding("SEC-NATIVE-002", "native_dll_dependency", "medium", displayPath, "Native DLL dependency needs review.", extension));
        }
    }

    private static void AddObfuscatedNameFinding(string fileName, string displayPath, List<SecurityFinding> findings)
    {
        string name = Path.GetFileNameWithoutExtension(fileName);
        if (name.Length < 14)
        {
            return;
        }

        int digits = name.Count(char.IsDigit);
        int consonants = name.Count(ch => "bcdfghjklmnpqrstvwxyz".Contains(char.ToLowerInvariant(ch)));
        bool looksRandom = digits >= 6 || consonants > name.Length * 0.75;
        if (looksRandom)
        {
            findings.Add(new SecurityFinding("SEC-OBF-002", "obfuscated_name", "low", displayPath, "Obfuscated-looking file name detected.", fileName));
        }
    }

    private static void AddEntropyFindings(byte[] bytes, string asciiText, string displayPath, List<SecurityFinding> findings)
    {
        if (Base64Pattern.IsMatch(asciiText))
        {
            findings.Add(new SecurityFinding("SEC-OBF-001", "entropy_or_base64", "medium", displayPath, "Long base64-like string detected.", "base64-like string"));
            return;
        }

        if (bytes.Length < 4096)
        {
            return;
        }

        double entropy = CalculateEntropy(bytes.Take(Math.Min(bytes.Length, 1024 * 1024)).ToArray());
        if (entropy >= 7.65)
        {
            findings.Add(new SecurityFinding("SEC-OBF-001", "entropy_or_base64", "medium", displayPath, "High entropy data detected.", entropy.ToString("0.00")));
        }
    }

    private static string ComputeModHash(string modPath, FileHashCache? hashCache)
    {
        StringBuilder builder = new();
        string[] files = Directory.GetFiles(modPath, "*", SearchOption.AllDirectories)
            .OrderBy(path => Path.GetRelativePath(modPath, path), StringComparer.OrdinalIgnoreCase)
            .ToArray();
        string[] hashes = new string[files.Length];

        Parallel.For(0, files.Length, i =>
        {
            hashes[i] = HashUtil.ComputeFileSha256(files[i], hashCache);
        });

        for (int i = 0; i < files.Length; i++)
        {
            string filePath = files[i];
            string relativePath = Path.GetRelativePath(modPath, filePath).Replace('\\', '/');
            FileInfo file = new(filePath);
            builder.AppendLine(relativePath);
            builder.AppendLine(file.Length.ToString());
            builder.AppendLine(file.LastWriteTimeUtc.Ticks.ToString());
            builder.AppendLine(hashes[i]);
        }

        return HashUtil.ComputeStringSha256(builder.ToString());
    }

    private static string ExtractPrintableAscii(byte[] bytes)
    {
        char[] chars = new char[bytes.Length];
        for (int i = 0; i < bytes.Length; i++)
        {
            byte value = bytes[i];
            chars[i] = value >= 32 && value <= 126 ? (char)value : ' ';
        }

        return new string(chars);
    }

    private static double CalculateEntropy(byte[] bytes)
    {
        if (bytes.Length == 0)
        {
            return 0;
        }

        int[] counts = new int[256];
        foreach (byte value in bytes)
        {
            counts[value]++;
        }

        double entropy = 0;
        foreach (int count in counts.Where(count => count > 0))
        {
            double probability = count / (double)bytes.Length;
            entropy -= probability * Math.Log(probability, 2);
        }

        return entropy;
    }

    private static bool ContainsIgnoreCase(string haystack, string needle) =>
        haystack.Contains(needle, StringComparison.OrdinalIgnoreCase);
}

public sealed record SuspiciousPattern(string RuleId, string Severity, string Id, string Description, string Documentation, params string[] Needles);

public sealed record SecurityRuleDoc(string RuleId, string Name, string Severity, string Description, string Documentation);

public sealed record SecurityFinding(string RuleId, string Rule, string Severity, string File, string Description, string Evidence);

public sealed class SecurityScanResult
{
    public const int MaxFindings = 75;

    public SecurityScanResult(
        string modHash,
        IReadOnlyList<SecurityFinding> findings,
        IReadOnlyList<string> skippedLargeFiles,
        IReadOnlyList<string> suspiciousFiles,
        IReadOnlyList<string> nativeDlls,
        IReadOnlyList<string> networkStrings,
        bool isAllowedByAllowlist,
        SecurityAllowlistEntry? allowlistEntry,
        bool warnOnlyDeveloperMode,
        long scanDurationMs,
        long totalBytesScanned)
    {
        ModHash = modHash;
        Findings = findings;
        SkippedLargeFiles = skippedLargeFiles;
        SuspiciousFiles = suspiciousFiles;
        NativeDlls = nativeDlls;
        NetworkStrings = networkStrings;
        IsAllowedByAllowlist = isAllowedByAllowlist;
        AllowlistEntry = allowlistEntry;
        WarnOnlyDeveloperMode = warnOnlyDeveloperMode;
        ScanDurationMs = scanDurationMs;
        TotalBytesScanned = totalBytesScanned;
    }

    public string ModHash { get; }
    public IReadOnlyList<SecurityFinding> Findings { get; }
    public IReadOnlyList<string> SkippedLargeFiles { get; }
    public IReadOnlyList<string> SuspiciousFiles { get; }
    public IReadOnlyList<string> NativeDlls { get; }
    public IReadOnlyList<string> NetworkStrings { get; }
    public bool IsAllowedByAllowlist { get; }
    public SecurityAllowlistEntry? AllowlistEntry { get; }
    public bool WarnOnlyDeveloperMode { get; }
    public long ScanDurationMs { get; }
    public long TotalBytesScanned { get; }
    public bool IsBlocked => Findings.Count > 0 && !IsAllowedByAllowlist && !WarnOnlyDeveloperMode;
    public string HighestSeverity => SecuritySeverity.Highest(Findings.Select(finding => finding.Severity));

    public string Summary
    {
        get
        {
            if (Findings.Count == 0)
            {
                return "clean";
            }

            SecurityFinding first = Findings[0];
            string extra = Findings.Count > 1 ? $" (+{Findings.Count - 1} more)" : "";
            return $"{first.RuleId}/{first.Rule} [{first.Severity}] in {first.File}{extra}";
        }
    }
}

public static class SecuritySeverity
{
    private static readonly Dictionary<string, int> Rank = new(StringComparer.OrdinalIgnoreCase)
    {
        ["none"] = 0,
        ["low"] = 1,
        ["medium"] = 2,
        ["high"] = 3,
        ["critical"] = 4
    };

    public static string Highest(IEnumerable<string> severities)
    {
        string highest = "none";
        foreach (string severity in severities)
        {
            if (Rank.GetValueOrDefault(severity, 0) > Rank.GetValueOrDefault(highest, 0))
            {
                highest = severity;
            }
        }

        return highest;
    }
}
