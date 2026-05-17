public static class PathUtil
{
    public static string NormalizeRelativePath(string path) => path.Replace('\\', '/');

    public static string SafeFileName(string value, string fallback = "file")
    {
        string safe = string.Join("_", value.Split(Path.GetInvalidFileNameChars(), StringSplitOptions.RemoveEmptyEntries));
        return string.IsNullOrWhiteSpace(safe) ? fallback : safe;
    }
}
