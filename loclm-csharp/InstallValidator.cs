public static class InstallValidator
{
    public static LoaderResult Validate(LoaderConfig config)
    {
        if (!File.Exists(config.OriginalDataWinPath))
        {
            return LoaderResult.Fail("missing_data_win", $"data.win was not found: {config.OriginalDataWinPath}");
        }

        if (!File.Exists(config.GameExecutable))
        {
            return LoaderResult.Fail("missing_game_executable", $"Game executable was not found: {config.GameExecutable}");
        }

        string? gameDirectory = Path.GetDirectoryName(config.GameExecutable);
        if (!string.IsNullOrWhiteSpace(gameDirectory) &&
            !string.Equals(Path.GetFullPath(config.DataDirectory), Path.GetFullPath(gameDirectory), StringComparison.OrdinalIgnoreCase))
        {
            return LoaderResult.Fail("wrong_game_folder", "data.win and the game executable are not in the same folder.");
        }

        return LoaderResult.Ok();
    }
}
