using System.Diagnostics;
using System.IO.Compression;
using System.Text.Json;

public sealed class FileHashCache
{
    private readonly object lockObject = new();
    private readonly Dictionary<string, CachedFileHash> entries;

    private FileHashCache(string path, Dictionary<string, CachedFileHash> entries)
    {
        Path = path;
        this.entries = entries;
    }

    public string Path { get; }

    public static FileHashCache Load(string path, Action<string> warn)
    {
        try
        {
            if (!File.Exists(path))
            {
                return new FileHashCache(path, new Dictionary<string, CachedFileHash>(StringComparer.OrdinalIgnoreCase));
            }

            FileHashCacheFile? cacheFile = JsonSerializer.Deserialize<FileHashCacheFile>(
                File.ReadAllText(path),
                JsonUtil.CaseInsensitiveOptions);

            Dictionary<string, CachedFileHash> entries = cacheFile?.Entries?
                .Where(entry => !string.IsNullOrWhiteSpace(entry.Path))
                .GroupBy(entry => entry.Path, StringComparer.OrdinalIgnoreCase)
                .ToDictionary(group => group.Key, group => group.Last(), StringComparer.OrdinalIgnoreCase)
                ?? new Dictionary<string, CachedFileHash>(StringComparer.OrdinalIgnoreCase);

            return new FileHashCache(path, entries);
        }
        catch (Exception ex)
        {
            warn("Could not read file hash cache: " + ex.Message);
            return new FileHashCache(path, new Dictionary<string, CachedFileHash>(StringComparer.OrdinalIgnoreCase));
        }
    }

    public string GetSha256(string filePath)
    {
        FileInfo file = new(filePath);
        if (!file.Exists)
        {
            return "";
        }

        string fullPath = System.IO.Path.GetFullPath(filePath);
        long length = file.Length;
        long writeTicks = file.LastWriteTimeUtc.Ticks;

        lock (lockObject)
        {
            if (entries.TryGetValue(fullPath, out CachedFileHash? cached) &&
                cached.Length == length &&
                cached.LastWriteUtcTicks == writeTicks &&
                !string.IsNullOrWhiteSpace(cached.Sha256))
            {
                cached.LastUsedUtc = DateTime.UtcNow.ToString("O");
                return cached.Sha256;
            }
        }

        string hash = HashUtil.ComputeFileSha256(filePath);
        CachedFileHash updated = new()
        {
            Path = fullPath,
            Length = length,
            LastWriteUtcTicks = writeTicks,
            Sha256 = hash,
            UpdatedUtc = DateTime.UtcNow.ToString("O"),
            LastUsedUtc = DateTime.UtcNow.ToString("O")
        };

        lock (lockObject)
        {
            entries[fullPath] = updated;
        }

        return hash;
    }

    public void Save(Action<string> warn)
    {
        try
        {
            Directory.CreateDirectory(System.IO.Path.GetDirectoryName(Path) ?? AppContext.BaseDirectory);
            FileHashCacheFile cacheFile = new()
            {
                GeneratedUtc = DateTime.UtcNow.ToString("O"),
                Entries = entries.Values
                    .OrderBy(entry => entry.Path, StringComparer.OrdinalIgnoreCase)
                    .ToList()
            };

            File.WriteAllText(Path, JsonSerializer.Serialize(cacheFile, JsonUtil.IndentedOptions));
        }
        catch (Exception ex)
        {
            warn("Could not write file hash cache: " + ex.Message);
        }
    }
}

public sealed class FileHashCacheFile
{
    public string GeneratedUtc { get; set; } = "";
    public List<CachedFileHash> Entries { get; set; } = new();
}

public sealed class CachedFileHash
{
    public string Path { get; set; } = "";
    public long Length { get; set; }
    public long LastWriteUtcTicks { get; set; }
    public string Sha256 { get; set; } = "";
    public string UpdatedUtc { get; set; } = "";
    public string LastUsedUtc { get; set; } = "";
}

public sealed class LoaderPhaseTimer
{
    private readonly Stopwatch total = Stopwatch.StartNew();
    private readonly List<PhaseTiming> phases = new();

    public T Measure<T>(string name, Func<T> action)
    {
        Stopwatch stopwatch = Stopwatch.StartNew();
        try
        {
            return action();
        }
        finally
        {
            stopwatch.Stop();
            phases.Add(new PhaseTiming
            {
                Name = name,
                DurationMs = stopwatch.ElapsedMilliseconds
            });
        }
    }

    public void Measure(string name, Action action)
    {
        _ = Measure(name, () =>
        {
            action();
            return true;
        });
    }

    public PerformanceReport WriteReport(string logsDirectory, string mode, Action<string> info, Action<string> warn)
    {
        total.Stop();
        Directory.CreateDirectory(logsDirectory);
        PerformanceReport report = new()
        {
            GeneratedUtc = DateTime.UtcNow.ToString("O"),
            LoaderVersion = LoaderConstants.LoaderVersion,
            Mode = mode,
            TotalDurationMs = total.ElapsedMilliseconds,
            PeakWorkingSetBytes = Environment.WorkingSet,
            ManagedHeapBytes = GC.GetTotalMemory(forceFullCollection: false),
            Phases = phases.ToList()
        };

        string path = System.IO.Path.Combine(logsDirectory, "performance_report.json");
        try
        {
            File.WriteAllText(path, JsonSerializer.Serialize(report, JsonUtil.IndentedOptions));
            info($"Performance report: {path}");
            info($"Total loader time: {report.TotalDurationMs} ms; working set: {FormatBytes(report.PeakWorkingSetBytes)}; managed heap: {FormatBytes(report.ManagedHeapBytes)}");
        }
        catch (Exception ex)
        {
            warn("Could not write performance report: " + ex.Message);
        }

        return report;
    }

    private static string FormatBytes(long bytes)
    {
        double value = bytes;
        string[] units = { "B", "KB", "MB", "GB" };
        int unit = 0;
        while (value >= 1024 && unit < units.Length - 1)
        {
            value /= 1024;
            unit++;
        }

        return $"{value:0.##} {units[unit]}";
    }
}

public sealed class PerformanceReport
{
    public string GeneratedUtc { get; set; } = "";
    public string LoaderVersion { get; set; } = "";
    public string Mode { get; set; } = "";
    public long TotalDurationMs { get; set; }
    public long PeakWorkingSetBytes { get; set; }
    public long ManagedHeapBytes { get; set; }
    public List<PhaseTiming> Phases { get; set; } = new();
}

public sealed class PhaseTiming
{
    public string Name { get; set; } = "";
    public long DurationMs { get; set; }
}

public static class ReportMaintenance
{
    private static readonly HashSet<string> CurrentRunFiles = new(StringComparer.OrdinalIgnoreCase)
    {
        "LOCLM.log",
        "LOCLM_summary.txt",
        "performance_report.json",
        "file_hash_cache.json",
        "game_baseline.json",
        "game_resource_baseline.json",
        LoaderConstants.CacheManifestFileName
    };

    public static void CompressOldReports(string logsDirectory, TimeSpan olderThan, Action<string> info, Action<string> warn)
    {
        if (!Directory.Exists(logsDirectory))
        {
            return;
        }

        DateTime cutoff = DateTime.UtcNow - olderThan;
        int compressed = 0;
        foreach (string path in Directory.GetFiles(logsDirectory, "*", SearchOption.TopDirectoryOnly))
        {
            FileInfo file = new(path);
            if (file.LastWriteTimeUtc >= cutoff ||
                CurrentRunFiles.Contains(file.Name) ||
                file.Extension.Equals(".gz", StringComparison.OrdinalIgnoreCase) ||
                file.Length == 0 ||
                file.Name.StartsWith("LOCLM_CACHE_", StringComparison.OrdinalIgnoreCase))
            {
                continue;
            }

            if (file.Extension is not ".json" and not ".txt" and not ".log")
            {
                continue;
            }

            string gzipPath = path + ".gz";
            try
            {
                using FileStream source = File.OpenRead(path);
                using FileStream destination = File.Create(gzipPath);
                using GZipStream gzip = new(destination, CompressionLevel.SmallestSize);
                source.CopyTo(gzip);
                File.SetLastWriteTimeUtc(gzipPath, file.LastWriteTimeUtc);
                File.Delete(path);
                compressed++;
            }
            catch (Exception ex)
            {
                warn($"Could not compress old report '{file.Name}': {ex.Message}");
            }
        }

        if (compressed > 0)
        {
            info($"Compressed {compressed} old report file(s).");
        }
    }
}

public static class BenchmarkMode
{
    public static void Run(string loclmDirectory, LoaderPhaseTimer phases, Action<string> info, Action<string> warn, Action<string> success)
    {
        string logsDirectory = System.IO.Path.Combine(loclmDirectory, "Logs");
        Directory.CreateDirectory(logsDirectory);
        string tempRoot = System.IO.Path.Combine(System.IO.Path.GetTempPath(), "loclm-benchmark-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(tempRoot);

        try
        {
            string modsDirectory = Directory.CreateDirectory(System.IO.Path.Combine(tempRoot, "mods")).FullName;
            FileHashCache hashCache = FileHashCache.Load(System.IO.Path.Combine(logsDirectory, "file_hash_cache.json"), warn);
            SecurityAllowlist allowlist = SecurityAllowlist.Empty;

            phases.Measure("benchmark create fake mods", () => CreateFakeMods(modsDirectory, info));
            phases.Measure("benchmark cached file hashing", () =>
            {
                foreach (string file in Directory.GetFiles(modsDirectory, "*", SearchOption.AllDirectories))
                {
                    _ = hashCache.GetSha256(file);
                }
            });
            phases.Measure("benchmark parallel security scanning", () =>
            {
                List<ModInfo> mods = Directory.GetDirectories(modsDirectory)
                    .Select(path => new ModInfo
                    {
                        modPath = path,
                        folderName = System.IO.Path.GetFileName(path),
                        modName = System.IO.Path.GetFileName(path)
                    })
                    .ToList();

                _ = SecurityScanner.ScanMods(mods, modsDirectory, allowlist, hashCache);
            });

            hashCache.Save(warn);
            success("Benchmark mode completed with fake mod data.");
        }
        finally
        {
            try
            {
                Directory.Delete(tempRoot, recursive: true);
            }
            catch (Exception ex)
            {
                warn("Could not clean benchmark temp data: " + ex.Message);
            }
        }
    }

    private static void CreateFakeMods(string modsDirectory, Action<string> info)
    {
        const int modCount = 16;
        byte[] cleanBytes = new byte[256 * 1024];
        Random random = new(42);
        random.NextBytes(cleanBytes);

        for (int i = 0; i < modCount; i++)
        {
            string folderName = "BenchmarkMod" + i.ToString("00");
            string modDirectory = Directory.CreateDirectory(System.IO.Path.Combine(modsDirectory, folderName)).FullName;
            File.WriteAllBytes(System.IO.Path.Combine(modDirectory, folderName + ".dll"), cleanBytes);
            File.WriteAllText(
                System.IO.Path.Combine(modDirectory, "modinfo.json"),
                JsonSerializer.Serialize(new
                {
                    modName = folderName,
                    authors = new[] { "LOCLM Benchmark" },
                    description = "Synthetic benchmark mod.",
                    priority = i
                }));
        }

        info($"Created {modCount} fake benchmark mod(s).");
    }
}
