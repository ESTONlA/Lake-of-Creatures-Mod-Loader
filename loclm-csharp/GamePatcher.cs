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
}
