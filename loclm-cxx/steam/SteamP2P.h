#pragma once

#include "MpPackets.h"

#include <cstdint>
#include <functional>
#include <string>
#include <vector>

#if LOCLM_ENABLE_STEAMWORKS
#include <steam/steam_api.h>
#include <steam/isteamnetworkingsockets.h>
#endif

namespace loclm::mp
{
    class SteamP2P
    {
    public:
        using PacketHandler = std::function<void(MpPacketType, const std::vector<uint8_t>&)>;
        using LogHandler = std::function<void(const std::string&)>;

        SteamP2P(PacketHandler packetHandler, LogHandler logHandler);
        ~SteamP2P();

        bool StartHost();
        bool ConnectToHost(uint64_t hostSteamId);
        void Disconnect();
        void Tick();
        bool Send(MpPacketType type, const std::vector<uint8_t>& payload, bool reliable);
        bool HasConnection() const;
        uint64_t RemoteSteamId() const;

#if LOCLM_ENABLE_STEAMWORKS
        void OnConnectionStatusChanged(SteamNetConnectionStatusChangedCallback_t* callback);
#endif

    private:
        PacketHandler packetHandler_;
        LogHandler log_;
        uint32_t tick_ = 0;
        uint64_t hostSteamId_ = 0;
        uint64_t remoteSteamId_ = 0;

#if LOCLM_ENABLE_STEAMWORKS
        HSteamListenSocket listenSocket_ = k_HSteamListenSocket_Invalid;
        HSteamNetConnection connection_ = k_HSteamNetConnection_Invalid;
#else
        bool connected_ = false;
#endif
    };
}
