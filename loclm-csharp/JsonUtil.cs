using System.Text.Json;

public static class JsonUtil
{
    public static JsonSerializerOptions IndentedOptions { get; } = new()
    {
        WriteIndented = true
    };

    public static JsonSerializerOptions CaseInsensitiveOptions { get; } = new()
    {
        PropertyNameCaseInsensitive = true
    };
}
