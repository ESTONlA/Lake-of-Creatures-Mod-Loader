#pragma once

#include "SteamP2P.h"

#include <cstdint>
#include <functional>
#include <string>

#if LOCLM_ENABLE_STEAMWORKS
#include <steam/steam_api.h>
#endif

namespace loclm::mp
{
    class SteamLobby
    {
    public:
        using PacketHandler = std::function<void(MpPacketType, const std::vector<uint8_t>&)>;
        using LogHandler = std::function<void(const std::string&)>;

        SteamLobby(SteamP2P& p2p, PacketHandler packetHandler, LogHandler logHandler);
        ~SteamLobby();

        bool CreateLobby(int maxPlayers = 2, bool friendsOnly = true);
        bool JoinLobby(uint64_t lobbySteamId);
        void LeaveLobby();
        uint64_t GetLobbyOwner() const;
        uint64_t CurrentLobby() const;
        void SendLobbyNames();

#if LOCLM_ENABLE_STEAMWORKS
        void OnLobbyCreated(LobbyCreated_t* callback, bool ioFailure);
        void OnLobbyEntered(LobbyEnter_t* callback);
        void OnGameLobbyJoinRequested(GameLobbyJoinRequested_t* callback);
        void OnLobbyChatUpdate(LobbyChatUpdate_t* callback);
#endif

    private:
        std::string GetPersonaName(uint64_t steamId) const;

        SteamP2P& p2p_;
        PacketHandler packetHandler_;
        LogHandler log_;
        uint64_t lobbyId_ = 0;
        uint64_t lobbyOwner_ = 0;

#if LOCLM_ENABLE_STEAMWORKS
        CCallResult<SteamLobby, LobbyCreated_t> lobbyCreatedCall_;
        CCallback<SteamLobby, LobbyEnter_t> lobbyEnteredCallback_;
        CCallback<SteamLobby, GameLobbyJoinRequested_t> gameLobbyJoinRequestedCallback_;
        CCallback<SteamLobby, LobbyChatUpdate_t> lobbyChatUpdateCallback_;
#endif
    };
}
