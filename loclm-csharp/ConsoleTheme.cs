public static class ConsoleTheme
{
    private static bool SupportsColor => !Console.IsOutputRedirected;

    public static void WriteColored(string text, ConsoleColor color, bool newline = true)
    {
        if (SupportsColor)
        {
            ConsoleColor previous = Console.ForegroundColor;
            Console.ForegroundColor = color;
            if (newline)
            {
                Console.WriteLine(text);
            }
            else
            {
                Console.Write(text);
            }

            Console.ForegroundColor = previous;
            return;
        }

        if (newline)
        {
            Console.WriteLine(text);
        }
        else
        {
            Console.Write(text);
        }
    }
}
