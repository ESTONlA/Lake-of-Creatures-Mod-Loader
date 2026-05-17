public static class ModScanner
{
    public static IReadOnlyList<string> FindModDirectories(string modsDirectory)
    {
        if (!Directory.Exists(modsDirectory))
        {
            return Array.Empty<string>();
        }

        return Directory.GetDirectories(modsDirectory)
            .OrderBy(path => path, StringComparer.OrdinalIgnoreCase)
            .ToArray();
    }
}
