using System.Diagnostics;

public static class GameLauncher
{
    public static void Launch(
        string gameExecutable,
        string outputDataWinPath,
        string[] args,
        Action<string> warn,
        Action<string> error,
        Action<string> success)
    {
        if (string.Equals(Environment.GetEnvironmentVariable("LOCLM_SKIP_LAUNCH"), "1", StringComparison.Ordinal))
        {
            warn("LOCLM_SKIP_LAUNCH=1 is set. Not launching the game.");
            return;
        }

        ConsoleTheme.WriteColored("", ConsoleColor.White);
        ConsoleTheme.WriteColored("LOCLM is ready to relaunch the game.", ConsoleColor.Yellow);
        ConsoleTheme.WriteColored("Type 'y' and press Enter to continue. This window will stay open until then.", ConsoleColor.Yellow);
        WaitForYes(warn);

        string argstring = "";
        for (int i = 2; i < args.Length; i++)
        {
            argstring += " \"";
            argstring += args[i];
            argstring += "\"";
        }

        Process? process = Process.Start(gameExecutable, $"-game \"{outputDataWinPath}\"" + argstring);
        if (process is null)
        {
            error("Game process did not start.");
            return;
        }

        success($"Game process started. PID: {process.Id}");
    }

    public static void WaitForYes(Action<string> warn)
    {
        while (true)
        {
            ConsoleTheme.WriteColored("> ", ConsoleColor.Yellow, false);
            string? input = Console.ReadLine();
            if (string.Equals(input?.Trim(), "y", StringComparison.OrdinalIgnoreCase))
            {
                return;
            }

            warn("Type 'y' and press Enter to continue.");
        }
    }
}
