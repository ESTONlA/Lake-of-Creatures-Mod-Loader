#pragma once

#include "LocalBridgeServer.h"
#include "SteamLobby.h"
#include "SteamP2P.h"

#include <atomic>
#include <memory>
#include <mutex>
#include <string>
#include <thread>

#if LOCLM_ENABLE_STEAMWORKS
#include <steam/steam_api.h>
#endif

namespace loclm::mp
{
    struct SteamBridgeStatus
    {
        bool steamAvailable = false;
        uint64_t steamId = 0;
        std::string personaName;
        std::string lastError;
    };

    struct SteamMpConfig
    {
        bool enabled = true;
        uint16_t localBridgePort = DefaultBridgePort;
        uint8_t protocolVersion = ProtocolVersion;
        bool debug = true;
        int sendRate = 20;
    };

    class SteamBridge
    {
    public:
        explicit SteamBridge(std::wstring gameDirectory);
        ~SteamBridge();

        bool Start();
        void Stop();
        SteamBridgeStatus Status() const;

    private:
        void Run();
        void HandleLocalPacket(MpPacketType type, const std::vector<uint8_t>& payload);
        void SendToGml(MpPacketType type, const std::vector<uint8_t>& payload);
        void Log(const std::string& message) const;
        bool LoadConfig();
        void EnsureConfigFile() const;
        bool InitSteam();
        void ShutdownSteam();

        std::wstring gameDirectory_;
        std::wstring loclmDirectory_;
        std::wstring runtimeDirectory_;
        std::wstring logPath_;
        std::wstring configPath_;
        SteamMpConfig config_;
        SteamBridgeStatus status_;
        std::unique_ptr<LocalBridgeServer> localBridge_;
        std::unique_ptr<SteamP2P> p2p_;
        std::unique_ptr<SteamLobby> lobby_;
        std::thread thread_;
        std::atomic<bool> running_ = false;
        mutable std::mutex statusMutex_;

#if LOCLM_ENABLE_STEAMWORKS
        STEAM_CALLBACK(SteamBridge, OnConnectionStatusChanged, SteamNetConnectionStatusChangedCallback_t, connectionStatusCallback_);
#endif
    };

    void StartSteamBridgeForGameProcess(const std::wstring& gameDirectory);
    void StopSteamBridgeForGameProcess();
}
