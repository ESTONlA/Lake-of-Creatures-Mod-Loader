#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <shellapi.h>

#include <string>
#include <vector>

constexpr wchar_t PROXY_DLL[] = L"version.dll";
constexpr wchar_t LOADER_EXE[] = L"antenni-loader.exe";
constexpr wchar_t LOADER_DIR[] = L"antenni";
constexpr wchar_t LOGS_DIR[] = L"Logs";
constexpr wchar_t LOG_FILE[] = L"ANTENNI_proxy.log";

#define DLL_PROXY_ORIGINAL(name) original_##name

#define DLL_NAME(name)                \
    FARPROC DLL_PROXY_ORIGINAL(name); \
    void _##name() {                  \
        DLL_PROXY_ORIGINAL(name)();   \
    }
#include "proxy.h"

#undef DLL_NAME

bool hasLoaded = false;

std::wstring getProcessPath()
{
    std::vector<wchar_t> buffer(32768);
    DWORD length = GetModuleFileNameW(nullptr, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0 || length >= buffer.size())
    {
        return L"";
    }

    return std::wstring(buffer.data(), length);
}

std::wstring getModulePath(HMODULE module)
{
    std::vector<wchar_t> buffer(32768);
    DWORD length = GetModuleFileNameW(module, buffer.data(), static_cast<DWORD>(buffer.size()));
    if (length == 0 || length >= buffer.size())
    {
        return L"";
    }

    return std::wstring(buffer.data(), length);
}

std::wstring getDirectory(const std::wstring& path)
{
    size_t slash = path.find_last_of(L"\\/");
    if (slash == std::wstring::npos)
    {
        return L".";
    }

    return path.substr(0, slash);
}

std::wstring joinPath(const std::wstring& left, const std::wstring& right)
{
    if (left.empty())
    {
        return right;
    }

    wchar_t last = left[left.size() - 1];
    if (last == L'\\' || last == L'/')
    {
        return left + right;
    }

    return left + L"\\" + right;
}

std::string wideToUtf8(const std::wstring& value)
{
    if (value.empty())
    {
        return "";
    }

    int size = WideCharToMultiByte(CP_UTF8, 0, value.c_str(), static_cast<int>(value.size()), nullptr, 0, nullptr, nullptr);
    if (size <= 0)
    {
        return "";
    }

    std::string result(size, '\0');
    WideCharToMultiByte(CP_UTF8, 0, value.c_str(), static_cast<int>(value.size()), result.data(), size, nullptr, nullptr);
    return result;
}

void ensureDirectory(const std::wstring& path)
{
    if (path.empty())
    {
        return;
    }

    DWORD attributes = GetFileAttributesW(path.c_str());
    if (attributes != INVALID_FILE_ATTRIBUTES && (attributes & FILE_ATTRIBUTE_DIRECTORY) != 0)
    {
        return;
    }

    CreateDirectoryW(path.c_str(), nullptr);
}

void logLine(const std::wstring& message)
{
    std::wstring processPath = getProcessPath();
    std::wstring processDir = getDirectory(processPath);
    std::wstring loaderDir = joinPath(processDir, LOADER_DIR);
    std::wstring logsDir = joinPath(loaderDir, LOGS_DIR);
    ensureDirectory(loaderDir);
    ensureDirectory(logsDir);
    std::wstring logPath = joinPath(logsDir, LOG_FILE);

    HANDLE file = CreateFileW(
        logPath.c_str(),
        FILE_APPEND_DATA,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        nullptr,
        OPEN_ALWAYS,
        FILE_ATTRIBUTE_NORMAL,
        nullptr);

    if (file == INVALID_HANDLE_VALUE)
    {
        OutputDebugStringW((L"Antenni Loader proxy log failed: " + message + L"\n").c_str());
        return;
    }

    std::string line = wideToUtf8(message + L"\r\n");
    DWORD written = 0;
    WriteFile(file, line.data(), static_cast<DWORD>(line.size()), &written, nullptr);
    CloseHandle(file);
}

std::wstring getLastErrorText(DWORD error)
{
    wchar_t* message = nullptr;
    DWORD length = FormatMessageW(
        FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS,
        nullptr,
        error,
        0,
        reinterpret_cast<LPWSTR>(&message),
        0,
        nullptr);

    if (length == 0 || message == nullptr)
    {
        return L"error " + std::to_wstring(error);
    }

    std::wstring result(message, length);
    LocalFree(message);
    return result;
}

std::wstring quoteArgument(const std::wstring& value)
{
    std::wstring quoted = L"\"";
    for (wchar_t ch : value)
    {
        if (ch == L'"')
        {
            quoted += L"\\\"";
        }
        else
        {
            quoted += ch;
        }
    }

    quoted += L"\"";
    return quoted;
}

bool hasGameArgument()
{
    int argc = 0;
    LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);
    if (argv == nullptr)
    {
        logLine(L"hasGameArgument: CommandLineToArgvW failed: " + getLastErrorText(GetLastError()));
        return false;
    }

    bool found = false;
    for (int i = 1; i < argc; ++i)
    {
        if (std::wstring(argv[i]) == L"-game")
        {
            found = true;
            break;
        }
    }

    LocalFree(argv);
    return found;
}

bool loadProxy()
{
    logLine(L"loadProxy: start");

    wchar_t systemDirectory[MAX_PATH] = {};
    if (GetSystemDirectoryW(systemDirectory, MAX_PATH) == 0)
    {
        logLine(L"loadProxy: GetSystemDirectoryW failed: " + getLastErrorText(GetLastError()));
        return false;
    }

    std::wstring systemVersionPath = joinPath(systemDirectory, PROXY_DLL);
    HMODULE library = LoadLibraryW(systemVersionPath.c_str());
    if (library == nullptr)
    {
        logLine(L"loadProxy: LoadLibraryW failed: " + getLastErrorText(GetLastError()));
        return false;
    }

#define DLL_NAME(name) DLL_PROXY_ORIGINAL(name) = GetProcAddress(library, #name);
#include "proxy.h"
#undef DLL_NAME

    logLine(L"loadProxy: success");
    return true;
}

void showLaunchFailure(const std::wstring& message)
{
    MessageBoxW(nullptr, message.c_str(), L"Antenni Loader proxy launch failed", MB_OK | MB_ICONERROR);
}

void launchLoader()
{
    if (hasLoaded)
    {
        return;
    }

    hasLoaded = true;
    logLine(L"launchLoader: start");

    std::wstring gamePath = getProcessPath();
    std::wstring gameDir = getDirectory(gamePath);
    std::wstring dataWinPath = joinPath(gameDir, L"data.win");
    std::wstring loaderPath = joinPath(joinPath(gameDir, LOADER_DIR), LOADER_EXE);

    if (GetFileAttributesW(loaderPath.c_str()) == INVALID_FILE_ATTRIBUTES)
    {
        std::wstring message = L"Antenni Loader executable was not found:\n" + loaderPath;
        logLine(L"launchLoader: " + message);
        showLaunchFailure(message);
        return;
    }

    if (GetFileAttributesW(dataWinPath.c_str()) == INVALID_FILE_ATTRIBUTES)
    {
        std::wstring message = L"data.win was not found:\n" + dataWinPath;
        logLine(L"launchLoader: " + message);
        showLaunchFailure(message);
        return;
    }

    std::wstring commandLine = quoteArgument(loaderPath) + L" " + quoteArgument(dataWinPath) + L" " + quoteArgument(gamePath);

    int argc = 0;
    LPWSTR* argv = CommandLineToArgvW(GetCommandLineW(), &argc);
    if (argv != nullptr)
    {
        for (int i = 1; i < argc; ++i)
        {
            commandLine += L" ";
            commandLine += quoteArgument(argv[i]);
        }

        LocalFree(argv);
    }

    STARTUPINFOW startupInfo = {};
    PROCESS_INFORMATION processInfo = {};
    startupInfo.cb = sizeof(startupInfo);

    std::vector<wchar_t> mutableCommandLine(commandLine.begin(), commandLine.end());
    mutableCommandLine.push_back(L'\0');

    logLine(L"launchLoader: CreateProcessW " + commandLine);
    BOOL created = CreateProcessW(
        loaderPath.c_str(),
        mutableCommandLine.data(),
        nullptr,
        nullptr,
        FALSE,
        0,
        nullptr,
        gameDir.c_str(),
        &startupInfo,
        &processInfo);

    if (!created)
    {
        DWORD error = GetLastError();
        std::wstring message = L"Could not start Antenni Loader:\n" + loaderPath + L"\n\n" + getLastErrorText(error);
        logLine(L"launchLoader: CreateProcessW failed: " + getLastErrorText(error));
        showLaunchFailure(message);
        return;
    }

    CloseHandle(processInfo.hProcess);
    CloseHandle(processInfo.hThread);
    logLine(L"launchLoader: CreateProcessW success, closing original game process");
    ExitProcess(0);
}

DWORD WINAPI loaderThread(LPVOID)
{
    Sleep(100);
    launchLoader();
    return 0;
}

BOOL APIENTRY DllMain(HMODULE module, DWORD reason, LPVOID)
{
    if (reason != DLL_PROCESS_ATTACH)
    {
        return TRUE;
    }

    DisableThreadLibraryCalls(module);
    logLine(L"DllMain: process attach");

    std::wstring processDir = getDirectory(getProcessPath());
    std::wstring proxyDir = getDirectory(getModulePath(module));
    if (!processDir.empty() &&
        !proxyDir.empty() &&
        _wcsicmp(processDir.c_str(), proxyDir.c_str()) != 0)
    {
        std::wstring message = L"version.dll is not next to the game executable.\n\nGame folder:\n" +
            processDir +
            L"\n\nLoaded version.dll from:\n" +
            proxyDir +
            L"\n\nInstall version.dll beside the supported game's executable.";
        logLine(L"DllMain: " + message);
        showLaunchFailure(message);
    }

    if (!loadProxy())
    {
        logLine(L"DllMain: loadProxy failed");
        return FALSE;
    }

    if (hasGameArgument())
    {
        logLine(L"DllMain: -game detected, not launching Antenni Loader again");
        return TRUE;
    }

    HANDLE thread = CreateThread(nullptr, 0, loaderThread, nullptr, 0, nullptr);
    if (thread == nullptr)
    {
        logLine(L"DllMain: CreateThread failed: " + getLastErrorText(GetLastError()));
        return TRUE;
    }

    CloseHandle(thread);
    logLine(L"DllMain: loader thread created");
    return TRUE;
}
