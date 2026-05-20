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

    public LoaderResult CheckWritable(string path, long requiredBytes)
    {
        string directory = Path.GetDirectoryName(path) ?? Directory.GetCurrentDirectory();
        try
        {
            DriveInfo drive = new(Path.GetPathRoot(Path.GetFullPath(directory)) ?? directory);
            if (drive.AvailableFreeSpace < requiredBytes)
            {
                return LoaderResult.Fail("low_disk_space", $"Not enough disk space to write patched data.win. Available: {drive.AvailableFreeSpace} bytes, required estimate: {requiredBytes} bytes.");
            }

            Directory.CreateDirectory(directory);
            string probe = Path.Combine(directory, ".loclm_write_probe.tmp");
            File.WriteAllText(probe, "probe");
            File.Delete(probe);
            return LoaderResult.Ok();
        }
        catch (IOException ex)
        {
            return LoaderResult.Fail("cache_file_locked", "Cache or game folder appears locked/unwritable: " + ex.Message, ex);
        }
        catch (UnauthorizedAccessException ex)
        {
            return LoaderResult.Fail("cache_access_denied", "LOCLM does not have permission to write the cache: " + ex.Message, ex);
        }
        catch (Exception ex)
        {
            return LoaderResult.Fail("cache_write_check_failed", "Could not validate cache write access: " + ex.Message, ex);
        }
    }

    public LoaderResult WriteDataWinAtomic(string path, UndertaleData data)
    {
        try
        {
            string directory = Path.GetDirectoryName(path) ?? Directory.GetCurrentDirectory();
            Directory.CreateDirectory(directory);
            string tempPath = Path.Combine(directory, Path.GetFileName(path) + ".tmp");

            if (File.Exists(tempPath))
            {
                File.Delete(tempPath);
            }

            using (FileStream writeStream = File.Open(tempPath, FileMode.CreateNew, FileAccess.Write, FileShare.None))
            {
                UndertaleIO.Write(writeStream, data);
            }

            if (File.Exists(path))
            {
                File.Replace(tempPath, path, null, ignoreMetadataErrors: true);
            }
            else
            {
                File.Move(tempPath, path);
            }

            return LoaderResult.Ok();
        }
        catch (IOException ex)
        {
            return LoaderResult.Fail("cache_file_locked", "Could not write patched data.win. The cache file may be locked: " + ex.Message, ex);
        }
        catch (UnauthorizedAccessException ex)
        {
            return LoaderResult.Fail("cache_access_denied", "Could not write patched data.win because access was denied: " + ex.Message, ex);
        }
        catch (Exception ex)
        {
            return LoaderResult.Fail("cache_atomic_write_failed", "Could not write patched data.win atomically: " + ex.Message, ex);
        }
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
