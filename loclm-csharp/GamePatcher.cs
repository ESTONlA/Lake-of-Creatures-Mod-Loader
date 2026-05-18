using UndertaleModLib;

public sealed class GamePatcher
{
    public UndertaleData ReadDataWin(string path, Action<string> importantError)
    {
        using FileStream readStream = File.OpenRead(path);
        return UndertaleIO.Read(
            readStream,
            (UndertaleReader.WarningHandlerDelegate)((message, isImportant) =>
            {
                if (isImportant)
                {
                    importantError(message);
                }
            }),
            (UndertaleReader.MessageHandlerDelegate)(_ => { }));
    }

    public void WriteDataWin(string path, UndertaleData data)
    {
        if (File.Exists(path))
        {
            File.Delete(path);
        }

        using FileStream writeStream = File.OpenWrite(path);
        UndertaleIO.Write(writeStream, data);
    }

    public LoaderResult ValidateWrittenDataWin(string path)
    {
        FileInfo file = new(path);
        if (!file.Exists)
        {
            return LoaderResult.Fail("missing_cache_output", "Generated cache file is missing: " + path);
        }

        if (file.Length == 0)
        {
            return LoaderResult.Fail("empty_cache_output", "Generated cache file is empty: " + path);
        }

        try
        {
            using FileStream stream = File.Open(path, FileMode.Open, FileAccess.Read, FileShare.Read);
            Span<byte> buffer = stackalloc byte[Math.Min(16, (int)Math.Min(file.Length, 16))];
            _ = stream.Read(buffer);
            return LoaderResult.Ok();
        }
        catch (Exception ex)
        {
            return LoaderResult.Fail("unreadable_cache_output", "Generated cache file could not be opened for validation: " + ex.Message);
        }
    }
}
