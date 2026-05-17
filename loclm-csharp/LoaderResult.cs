public sealed record LoaderError(string Code, string Message, Exception? Exception = null)
{
    public override string ToString() => string.IsNullOrWhiteSpace(Code) ? Message : $"{Code}: {Message}";
}

public sealed class LoaderResult
{
    private LoaderResult(bool success, LoaderError? error)
    {
        Success = success;
        Error = error;
    }

    public bool Success { get; }
    public LoaderError? Error { get; }

    public static LoaderResult Ok() => new(true, null);
    public static LoaderResult Fail(string code, string message, Exception? exception = null) =>
        new(false, new LoaderError(code, message, exception));
}

public sealed class LoaderResult<T>
{
    private LoaderResult(bool success, T? value, LoaderError? error)
    {
        Success = success;
        Value = value;
        Error = error;
    }

    public bool Success { get; }
    public T? Value { get; }
    public LoaderError? Error { get; }

    public static LoaderResult<T> Ok(T value) => new(true, value, null);
    public static LoaderResult<T> Fail(string code, string message, Exception? exception = null) =>
        new(false, default, new LoaderError(code, message, exception));
}
