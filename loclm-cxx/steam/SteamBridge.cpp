#include "SteamBridge.h"

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

#include <chrono>
#include <cctype>
#include <fstream>
#include <sstream>

namespace loclm::mp
{
    namespace
    {
        std::unique_ptr<SteamBridge> g_bridge;
        std::mutex g_bridgeMutex;

        std::wstring JoinPath(const std::wstring& left, const std::wstring& right)
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

        std::string WideToUtf8(const std::wstring& value)
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

        void EnsureDirectory(const std::wstring& path)
        {
            CreateDirectoryW(path.c_str(), nullptr);
        }

        std::string ReadFileUtf8(const std::wstring& path)
        {
            std::ifstream file(path, std::ios::binary);
            if (!file)
            {
                return "";
            }

            std::ostringstream stream;
            stream << file.rdbuf();
            return stream.str();
        }

        bool FindBool(const std::string& text, const std::string& key, bool fallback)
        {
            size_t keyPos = text.find("\"" + key + "\"");
            if (keyPos == std::string::npos)
            {
                return fallback;
            }

            size_t colon = text.find(':', keyPos);
            if (colon == std::string::npos)
            {
                return fallback;
            }

            size_t value = text.find_first_not_of(" \t\r\n", colon + 1);
            if (value == std::string::npos)
            {
                return fallback;
            }

            if (text.compare(value, 4, "true") == 0)
            {
                return true;
            }
            if (text.compare(value, 5, "false") == 0)
            {
                return false;
            }

            return fallback;
        }

        int FindInt(const std::string& text, const std::string& key, int fallback)
        {
            size_t keyPos = text.find("\"" + key + "\"");
            if (keyPos == std::string::npos)
            {
                return fallback;
            }

            size_t colon = text.find(':', keyPos);
            if (colon == std::string::npos)
            {
                return fallback;
            }

            size_t value = text.find_first_of("-0123456789", colon + 1);
            if (value == std::string::npos)
            {
                return fallback;
            }

            return std::atoi(text.c_str() + value);
        }

        bool TryParseU64(const std::string& text, uint64_t& value)
        {
            value = 0;
            if (text.empty())
            {
                return false;
            }

            uint64_t result = 0;
            for (char ch : text)
            {
                if (!std::isdigit(static_cast<unsigned char>(ch)))
                {
                    return false;
                }

                uint64_t digit = static_cast<uint64_t>(ch - '0');
                if (result > (UINT64_MAX - digit) / 10)
                {
                    return false;
                }

                result = (result * 10) + digit;
            }

            value = result;
            return value != 0;
        }
    }

    SteamBridge::SteamBridge(std::wstring gameDirectory)
        : gameDirectory_(std::move(gameDirectory)),
          loclmDirectory_(JoinPath(gameDirectory_, L"loclm")),
          runtimeDirectory_(JoinPath(loclmDirectory_, L"runtime")),
          logPath_(JoinPath(JoinPath(loclmDirectory_, L"logs"), L"steam-mp.log")),
          configPath_(JoinPath(JoinPath(loclmDirectory_, L"config"), L"steam_mp.json"))
#if LOCLM_ENABLE_STEAMWORKS
          , connectionStatusCallback_(this, &SteamBridge::OnConnectionStatusChanged)
#endif
    {
    }

    SteamBridge::~SteamBridge()
    {
        Stop();
    }

    bool SteamBridge::Start()
    {
        if (running_)
        {
            return true;
        }

        EnsureDirectory(loclmDirectory_);
        EnsureDirectory(JoinPath(loclmDirectory_, L"logs"));
        EnsureDirectory(runtimeDirectory_);
        EnsureDirectory(JoinPath(loclmDirectory_, L"config"));
        EnsureConfigFile();
        if (!LoadConfig())
        {
            Log("SteamBridge: config disabled or invalid; bridge will not start");
            return false;
        }

        if (!config_.enabled)
        {
            Log("SteamBridge: disabled by loclm/config/steam_mp.json");
            return false;
        }

        InitSteam();
        p2p_ = std::make_unique<SteamP2P>(
            [this](MpPacketType type, const std::vector<uint8_t>& payload)
            {
                SendToGml(type, payload);
                if (type == MpPacketType::Welcome && lobby_)
                {
                    lobby_->SendLobbyNames();
                }
            },
            [this](const std::string& message) { Log(message); });
        lobby_ = std::make_unique<SteamLobby>(
            *p2p_,
            [this](MpPacketType type, const std::vector<uint8_t>& payload) { SendToGml(type, payload); },
            [this](const std::string& message) { Log(message); });
        localBridge_ = std::make_unique<LocalBridgeServer>(
            runtimeDirectory_,
            config_.localBridgePort,
            [this](MpPacketType type, const std::vector<uint8_t>& payload) { HandleLocalPacket(type, payload); },
            [this](const std::string& message) { Log(message); });

        if (!localBridge_->Start())
        {
            std::lock_guard lock(statusMutex_);
            status_.lastError = "Local bridge could not bind to localhost";
            return false;
        }

        running_ = true;
        thread_ = std::thread(&SteamBridge::Run, this);
        Log("SteamBridge: started");
        return true;
    }

    void SteamBridge::Stop()
    {
        if (!running_.exchange(false))
        {
            return;
        }

        if (thread_.joinable())
        {
            thread_.join();
        }

        if (localBridge_)
        {
            localBridge_->Stop();
        }
        if (lobby_)
        {
            lobby_->LeaveLobby();
        }
        if (p2p_)
        {
            p2p_->Disconnect();
        }

        ShutdownSteam();
        Log("SteamBridge: stopped");
    }

    SteamBridgeStatus SteamBridge::Status() const
    {
        std::lock_guard lock(statusMutex_);
        return status_;
    }

    void SteamBridge::Run()
    {
        while (running_)
        {
#if LOCLM_ENABLE_STEAMWORKS
            if (Status().steamAvailable)
            {
                SteamAPI_RunCallbacks();
            }
#endif
            if (p2p_)
            {
                p2p_->Tick();
            }

            std::this_thread::sleep_for(std::chrono::milliseconds(16));
        }
    }

    void SteamBridge::HandleLocalPacket(MpPacketType type, const std::vector<uint8_t>& payload)
    {
        if (type != MpPacketType::PlayerState)
        {
            Log(std::string("SteamBridge: local packet ") + PacketTypeName(type));
        }

        switch (type)
        {
        case MpPacketType::Hello:
        {
            SteamBridgeStatus status = Status();
            std::string message = status.steamAvailable
                ? "Steam available: " + status.personaName + " (" + std::to_string(status.steamId) + ")"
                : "Steam unavailable: " + status.lastError;
            SendToGml(MpPacketType::Welcome, EncodeStringPayload(message));
            break;
        }
        case MpPacketType::CreateLobby:
            if (!Status().steamAvailable)
            {
                SendToGml(MpPacketType::LobbyFailed, EncodeStringPayload("Steam is unavailable: " + Status().lastError));
                break;
            }

            if (lobby_)
            {
                lobby_->CreateLobby(2, true);
            }
            break;
        case MpPacketType::JoinLobby:
        {
            uint64_t lobbyId = 0;
            bool parsed = false;
            std::string lobbyText = DecodeStringPayload(payload);
            if (!lobbyText.empty())
            {
                parsed = TryParseU64(lobbyText, lobbyId);
            }
            if (!parsed)
            {
                parsed = DecodeU64Payload(payload, lobbyId);
            }

            if (parsed && lobby_ && lobbyId != 0)
            {
                Log("SteamBridge: joining lobby id " + std::to_string(lobbyId));
                lobby_->JoinLobby(lobbyId);
            }
            else
            {
                SendToGml(MpPacketType::LobbyFailed, EncodeStringPayload("Invalid lobby id payload. Copy the full numeric Steam lobby ID."));
            }
            break;
        }
        case MpPacketType::PlayerState:
            if (p2p_ && p2p_->HasConnection())
            {
                std::vector<uint8_t> stampedPayload = payload;
                PlayerState state;
                if (DecodePlayerState(payload, state) && state.steamId == 0)
                {
                    state.steamId = Status().steamId;
                    stampedPayload = EncodePlayerState(state);
                }
                p2p_->Send(MpPacketType::PlayerState, stampedPayload, false);
            }
            break;
        case MpPacketType::WorldState:
            if (p2p_ && p2p_->HasConnection())
            {
                p2p_->Send(MpPacketType::WorldState, payload, false);
            }
            break;
        case MpPacketType::StartHost:
            if (p2p_ && p2p_->HasConnection())
            {
                p2p_->Send(MpPacketType::StartHost, payload, true);
                Log("SteamBridge: forwarded StartHost to Steam peer");
            }
            else
            {
                SendToGml(MpPacketType::Error, EncodeStringPayload("No Steam peer is connected yet."));
            }
            break;
        case MpPacketType::Disconnect:
            if (p2p_)
            {
                p2p_->Disconnect();
            }
            if (lobby_)
            {
                lobby_->LeaveLobby();
            }
            break;
        default:
            Log("SteamBridge: dropped unsupported local packet type");
            break;
        }
    }

    void SteamBridge::SendToGml(MpPacketType type, const std::vector<uint8_t>& payload)
    {
        if (localBridge_)
        {
            localBridge_->SendToClients(type, payload);
        }
    }

    void SteamBridge::Log(const std::string& message) const
    {
        std::ofstream file(logPath_, std::ios::app | std::ios::binary);
        if (!file)
        {
            OutputDebugStringA((message + "\n").c_str());
            return;
        }

        SYSTEMTIME time = {};
        GetSystemTime(&time);
        file << "["
            << time.wYear << "-"
            << time.wMonth << "-"
            << time.wDay << "T"
            << time.wHour << ":"
            << time.wMinute << ":"
            << time.wSecond << "Z] "
            << message << "\n";
    }

    bool SteamBridge::LoadConfig()
    {
        std::string text = ReadFileUtf8(configPath_);
        if (text.empty())
        {
            return true;
        }

        config_.enabled = FindBool(text, "enabled", config_.enabled);
        config_.debug = FindBool(text, "debug", config_.debug);
        config_.localBridgePort = static_cast<uint16_t>(FindInt(text, "localBridgePort", config_.localBridgePort));
        config_.protocolVersion = static_cast<uint8_t>(FindInt(text, "protocolVersion", config_.protocolVersion));
        config_.sendRate = FindInt(text, "sendRate", config_.sendRate);
        return true;
    }

    void SteamBridge::EnsureConfigFile() const
    {
        DWORD attributes = GetFileAttributesW(configPath_.c_str());
        if (attributes != INVALID_FILE_ATTRIBUTES)
        {
            return;
        }

        std::ofstream file(configPath_, std::ios::binary);
        if (!file)
        {
            return;
        }

        file <<
            "{\n"
            "  \"enabled\": true,\n"
            "  \"localBridgePort\": 38470,\n"
            "  \"protocolVersion\": 1,\n"
            "  \"debug\": true,\n"
            "  \"sendRate\": 20\n"
            "}\n";
    }

    bool SteamBridge::InitSteam()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (!SteamAPI_Init())
        {
            std::lock_guard lock(statusMutex_);
            status_.steamAvailable = false;
            status_.lastError = "SteamAPI_Init failed. Game may not be launched through Steam, steam_appid.txt may be missing for local dev, or steam_api64.dll may be missing.";
            Log("SteamBridge: " + status_.lastError);
            return false;
        }

        std::lock_guard lock(statusMutex_);
        status_.steamAvailable = true;
        status_.steamId = SteamUser() != nullptr ? SteamUser()->GetSteamID().ConvertToUint64() : 0;
        status_.personaName = SteamFriends() != nullptr ? SteamFriends()->GetPersonaName() : "";
        status_.lastError.clear();
        Log("SteamBridge: Steam init success. SteamID=" + std::to_string(status_.steamId) + " persona=" + status_.personaName);
        return true;
#else
        std::lock_guard lock(statusMutex_);
        status_.steamAvailable = false;
        status_.lastError = "LOCLM was built without Steamworks support.";
        Log("SteamBridge: " + status_.lastError);
        return false;
#endif
    }

    void SteamBridge::ShutdownSteam()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (Status().steamAvailable)
        {
            SteamAPI_Shutdown();
        }
#endif
    }

#if LOCLM_ENABLE_STEAMWORKS
    void SteamBridge::OnConnectionStatusChanged(SteamNetConnectionStatusChangedCallback_t* callback)
    {
        if (p2p_)
        {
            p2p_->OnConnectionStatusChanged(callback);
        }
    }
#endif

    void StartSteamBridgeForGameProcess(const std::wstring& gameDirectory)
    {
        std::lock_guard lock(g_bridgeMutex);
        if (g_bridge)
        {
            return;
        }

        g_bridge = std::make_unique<SteamBridge>(gameDirectory);
        g_bridge->Start();
    }

    void StopSteamBridgeForGameProcess()
    {
        std::lock_guard lock(g_bridgeMutex);
        if (g_bridge)
        {
            g_bridge->Stop();
            g_bridge.reset();
        }
    }
}
