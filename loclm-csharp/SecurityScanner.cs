using System.Text;
using System.Text.Json;

public sealed class SecurityAllowlist
{
    private readonly HashSet<string> allowedModHashes;

    private SecurityAllowlist(IEnumerable<string> allowedModHashes)
    {
        this.allowedModHashes = new HashSet<string>(
            allowedModHashes
                .Where(hash => !string.IsNullOrWhiteSpace(hash))
                .Select(hash => hash.Trim().ToUpperInvariant()),
            StringComparer.OrdinalIgnoreCase);
    }

    public static SecurityAllowlist Empty { get; } = new(Array.Empty<string>());

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

            List<string> hashes = new();
            foreach (JsonElement item in hashArray.EnumerateArray())
            {
                if (item.ValueKind == JsonValueKind.String)
                {
                    hashes.Add(item.GetString() ?? "");
                }
            }

            return new SecurityAllowlist(hashes);
        }
        catch (Exception ex)
        {
            warn($"Could not read security_allowlist.json: {ex.Message}");
            return Empty;
        }
    }

    public bool Allows(string modHash) => allowedModHashes.Contains(modHash);

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

public static class SecurityScanner
{
    private static readonly SuspiciousPattern[] SuspiciousPatterns =
    {
        new(
            "process_spawn",
            "Starts external processes or shell commands.",
            "System.Diagnostics.Process",
            "Process.Start",
            "Start-Process",
            "cmd.exe",
            "powershell",
            "wscript.exe",
            "cscript.exe",
            "mshta.exe",
            "rundll32.exe",
            "regsvr32.exe"),
        new(
            "native_code",
            "Uses native process/memory APIs or P/Invoke.",
            "DllImport",
            "DllImportAttribute",
            "NativeLibrary.Load",
            "LoadLibrary",
            "GetProcAddress",
            "VirtualAlloc",
            "WriteProcessMemory",
            "CreateRemoteThread"),
        new(
            "network_access",
            "Uses network clients or sockets.",
            "System.Net.Http",
            "HttpClient",
            "WebClient",
            "TcpClient",
            "UdpClient",
            "System.Net.Sockets.Socket",
            "DownloadFile",
            "DownloadString"),
        new(
            "destructive_io",
            "Deletes or overwrites files/directories.",
            "File.Delete",
            "Directory.Delete",
            "DeleteFile",
            "File.WriteAllBytes",
            "File.WriteAllText"),
        new(
            "registry_access",
            "Touches the Windows registry.",
            "Microsoft.Win32.Registry",
            "RegistryKey"),
        new(
            "runtime_code_loading",
            "Builds or loads code dynamically at runtime.",
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
        FileHashCache? hashCache)
    {
        Dictionary<string, SecurityScanResult> results = new(StringComparer.OrdinalIgnoreCase);
        object lockObject = new();

        Parallel.ForEach(mods, mod =>
        {
            string modPath = Path.Combine(modsDirectory, Path.GetFileName(mod.modPath));
            string modFolderName = Path.GetFileName(mod.modPath);
            string dllPath = Path.Combine(modPath, modFolderName + ".dll");
            SecurityScanResult result = ScanMod(modPath, dllPath, allowlist, hashCache);
            lock (lockObject)
            {
                results[mod.folderName] = result;
            }
        });

        return results;
    }

    public static SecurityScanResult ScanMod(string modPath, string dllPath, SecurityAllowlist allowlist, FileHashCache? hashCache = null)
    {
        string modHash = ComputeModHash(modPath, hashCache);
        List<SecurityFinding> findings = new();
        List<string> skippedLargeFiles = new();

        ScanFileForSuspiciousPatterns(dllPath, Path.GetFileName(dllPath), findings, skippedLargeFiles);
        foreach (string filePath in EnumerateSecurityScanFiles(modPath, dllPath))
        {
            if (findings.Count >= SecurityScanResult.MaxFindings)
            {
                break;
            }

            string relativePath = Path.GetRelativePath(modPath, filePath).Replace('\\', '/');
            ScanFileForSuspiciousPatterns(filePath, relativePath, findings, skippedLargeFiles);
        }

        bool isAllowlisted = findings.Count > 0 && allowlist.Allows(modHash);
        return new SecurityScanResult(modHash, findings, skippedLargeFiles, isAllowlisted);
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
            if (extension is ".dll" or ".exe" or ".gml" or ".cs" or ".json" or ".txt" or ".cfg" or ".ini")
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
        List<string> skippedLargeFiles)
    {
        const long maxScanBytes = 16 * 1024 * 1024;
        FileInfo file = new(path);
        if (!file.Exists)
        {
            return;
        }

        if (file.Length > maxScanBytes)
        {
            skippedLargeFiles.Add(displayPath);
            return;
        }

        byte[] bytes = File.ReadAllBytes(path);
        string asciiText = ExtractPrintableAscii(bytes);
        string utf16Text = Encoding.Unicode.GetString(bytes);
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
                    findings.Add(new SecurityFinding(pattern.Id, displayPath, pattern.Description));
                    break;
                }
            }
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

    private static bool ContainsIgnoreCase(string haystack, string needle) =>
        haystack.Contains(needle, StringComparison.OrdinalIgnoreCase);
}

public sealed record SuspiciousPattern(string Id, string Description, params string[] Needles);

public sealed record SecurityFinding(string Rule, string File, string Description);

public sealed class SecurityScanResult
{
    public const int MaxFindings = 50;

    public SecurityScanResult(
        string modHash,
        IReadOnlyList<SecurityFinding> findings,
        IReadOnlyList<string> skippedLargeFiles,
        bool isAllowedByAllowlist)
    {
        ModHash = modHash;
        Findings = findings;
        SkippedLargeFiles = skippedLargeFiles;
        IsAllowedByAllowlist = isAllowedByAllowlist;
    }

    public string ModHash { get; }
    public IReadOnlyList<SecurityFinding> Findings { get; }
    public IReadOnlyList<string> SkippedLargeFiles { get; }
    public bool IsAllowedByAllowlist { get; }
    public bool IsBlocked => Findings.Count > 0 && !IsAllowedByAllowlist;

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
            return $"{first.Rule} in {first.File}{extra}";
        }
    }
}
