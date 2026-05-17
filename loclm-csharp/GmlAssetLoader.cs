public sealed class GmlAssetLoader
{
    private readonly string assetDirectory;

    public GmlAssetLoader(string loclmDirectory)
    {
        assetDirectory = Path.Combine(loclmDirectory, "assets", "gml");
    }

    public string Load(string fileName, params (string Token, string Value)[] replacements)
    {
        string path = Path.Combine(assetDirectory, fileName);
        if (!File.Exists(path))
        {
            throw new FileNotFoundException("Missing LOCLM GML asset.", path);
        }

        string code = File.ReadAllText(path);
        foreach ((string token, string value) in replacements)
        {
            code = code.Replace(token, value);
        }

        return code;
    }

    public static string QuoteGmlString(string value) =>
        "\"" + value
            .Replace("\\", "\\\\")
            .Replace("\"", "\\\"")
            .Replace("\r", "")
            .Replace("\n", "\\n") + "\"";
}
