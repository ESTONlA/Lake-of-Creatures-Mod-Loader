using System.Security.Cryptography;

public static class HashUtil
{
    public static string ComputeFileSha256(string path)
    {
        using SHA256 sha = SHA256.Create();
        using FileStream stream = File.OpenRead(path);
        return Convert.ToHexString(sha.ComputeHash(stream));
    }

    public static string ComputeFileSha256(string path, FileHashCache? cache) =>
        cache is null ? ComputeFileSha256(path) : cache.GetSha256(path);

    public static string ComputeStringSha256(string value) =>
        Convert.ToHexString(SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(value)));
}
