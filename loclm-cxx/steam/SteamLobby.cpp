#include "SteamLobby.h"

namespace loclm::mp
{
    SteamLobby::SteamLobby(SteamP2P& p2p, PacketHandler packetHandler, LogHandler logHandler)
        : p2p_(p2p),
          packetHandler_(std::move(packetHandler)),
          log_(std::move(logHandler))
#if LOCLM_ENABLE_STEAMWORKS
          , lobbyEnteredCallback_(this, &SteamLobby::OnLobbyEntered),
          gameLobbyJoinRequestedCallback_(this, &SteamLobby::OnGameLobbyJoinRequested),
          lobbyChatUpdateCallback_(this, &SteamLobby::OnLobbyChatUpdate)
#endif
    {
    }

    SteamLobby::~SteamLobby()
    {
        LeaveLobby();
    }

    bool SteamLobby::CreateLobby(int maxPlayers, bool friendsOnly)
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamMatchmaking() == nullptr)
        {
            log_("SteamLobby: SteamMatchmaking unavailable");
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("SteamMatchmaking unavailable"));
            return false;
        }

        if (!p2p_.StartHost())
        {
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("Could not create P2P listen socket"));
            return false;
        }

        ELobbyType type = friendsOnly ? k_ELobbyTypeFriendsOnly : k_ELobbyTypePrivate;
        SteamAPICall_t call = SteamMatchmaking()->CreateLobby(type, maxPlayers);
        lobbyCreatedCall_.Set(call, this, &SteamLobby::OnLobbyCreated);
        log_("SteamLobby: CreateLobby requested");
        return true;
#else
        (void)maxPlayers;
        (void)friendsOnly;
        log_("SteamLobby: Steamworks disabled at build time; CreateLobby unavailable");
        packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("Steamworks support is not enabled in this LOCLM build"));
        return false;
#endif
    }

    bool SteamLobby::JoinLobby(uint64_t lobbySteamId)
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamMatchmaking() == nullptr)
        {
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("SteamMatchmaking unavailable"));
            return false;
        }

        lobbyId_ = lobbySteamId;
        SteamMatchmaking()->JoinLobby(CSteamID(lobbySteamId));
        log_("SteamLobby: JoinLobby requested " + std::to_string(lobbySteamId));
        return true;
#else
        (void)lobbySteamId;
        log_("SteamLobby: Steamworks disabled at build time; JoinLobby unavailable");
        packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("Steamworks support is not enabled in this LOCLM build"));
        return false;
#endif
    }

    void SteamLobby::LeaveLobby()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (lobbyId_ != 0 && SteamMatchmaking() != nullptr)
        {
            SteamMatchmaking()->LeaveLobby(CSteamID(lobbyId_));
        }
#endif
        lobbyId_ = 0;
        lobbyOwner_ = 0;
    }

    uint64_t SteamLobby::GetLobbyOwner() const
    {
        return lobbyOwner_;
    }

    uint64_t SteamLobby::CurrentLobby() const
    {
        return lobbyId_;
    }

#if LOCLM_ENABLE_STEAMWORKS
    void SteamLobby::OnLobbyCreated(LobbyCreated_t* callback, bool ioFailure)
    {
        if (ioFailure || callback == nullptr || callback->m_eResult != k_EResultOK)
        {
            std::string error = "Lobby create failed";
            if (callback != nullptr)
            {
                error += " result=" + std::to_string(static_cast<int>(callback->m_eResult));
            }
            if (ioFailure)
            {
                error += " io_failure=true";
            }

            log_("SteamLobby: " + error);
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload(error));
            return;
        }

        lobbyId_ = callback->m_ulSteamIDLobby;
        lobbyOwner_ = SteamUser() != nullptr ? SteamUser()->GetSteamID().ConvertToUint64() : 0;
        CSteamID lobby(lobbyId_);
        SteamMatchmaking()->SetLobbyData(lobby, "loclm_mp", "1");
        SteamMatchmaking()->SetLobbyData(lobby, "protocol", "1");
        SteamMatchmaking()->SetLobbyData(lobby, "game", "LakeOfCreatures");
        SteamMatchmaking()->SetLobbyData(lobby, "loader", "LOCLM");
        if (SteamFriends() != nullptr)
        {
            SteamMatchmaking()->SetLobbyData(lobby, "host_name", SteamFriends()->GetPersonaName());
        }
        log_("SteamLobby: lobby created " + std::to_string(lobbyId_));
        packetHandler_(MpPacketType::LobbyCreated, EncodeU64Payload(lobbyId_));
        SendLobbyNames();
    }

    void SteamLobby::OnLobbyEntered(LobbyEnter_t* callback)
    {
        if (callback == nullptr)
        {
            return;
        }

        lobbyId_ = callback->m_ulSteamIDLobby;
        if (callback->m_EChatRoomEnterResponse != k_EChatRoomEnterResponseSuccess)
        {
            std::string error = "Lobby enter failed response=" + std::to_string(callback->m_EChatRoomEnterResponse);
            log_("SteamLobby: " + error);
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload(error));
            return;
        }

        CSteamID lobby(lobbyId_);
        lobbyOwner_ = SteamMatchmaking()->GetLobbyOwner(lobby).ConvertToUint64();
        uint64_t self = SteamUser() != nullptr ? SteamUser()->GetSteamID().ConvertToUint64() : 0;
        log_("SteamLobby: lobby entered " + std::to_string(lobbyId_) + ", owner " + std::to_string(lobbyOwner_));
        if (lobbyOwner_ == 0)
        {
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("Joined lobby, but Steam returned no lobby owner. Check the lobby ID and make sure the host is still in the lobby."));
            return;
        }

        SendLobbyNames();
        if (lobbyOwner_ == self)
        {
            log_("SteamLobby: lobby entered as owner; keeping host state");
            return;
        }

        packetHandler_(MpPacketType::LobbyJoined, EncodeU64Payload(lobbyId_));
        if (lobbyOwner_ != 0 && lobbyOwner_ != self)
        {
            p2p_.ConnectToHost(lobbyOwner_);
        }
    }

    void SteamLobby::OnGameLobbyJoinRequested(GameLobbyJoinRequested_t* callback)
    {
        if (callback == nullptr)
        {
            return;
        }

        uint64_t lobbyId = callback->m_steamIDLobby.ConvertToUint64();
        log_("SteamLobby: Steam invite join requested " + std::to_string(lobbyId));
        packetHandler_(MpPacketType::Welcome, EncodeStringPayload("Steam invite accepted. Joining lobby..."));
        if (lobbyId == 0)
        {
            packetHandler_(MpPacketType::LobbyFailed, EncodeStringPayload("Steam invite did not contain a valid lobby ID"));
            return;
        }

        JoinLobby(lobbyId);
    }

    void SteamLobby::OnLobbyChatUpdate(LobbyChatUpdate_t* callback)
    {
        if (callback == nullptr || callback->m_ulSteamIDLobby != lobbyId_)
        {
            return;
        }

        SendLobbyNames();
    }
#endif

    void SteamLobby::SendLobbyNames()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (lobbyId_ == 0 || SteamMatchmaking() == nullptr)
        {
            return;
        }

        CSteamID lobby(lobbyId_);
        uint64_t self = SteamUser() != nullptr ? SteamUser()->GetSteamID().ConvertToUint64() : 0;
        uint64_t host = lobbyOwner_ != 0 ? lobbyOwner_ : self;
        std::string hostName = SteamMatchmaking()->GetLobbyData(lobby, "host_name");
        if (hostName.empty())
        {
            hostName = GetPersonaName(host);
        }
        std::string peerName;

        if (self != 0 && self != host)
        {
            peerName = GetPersonaName(self);
        }
        else
        {
            int memberCount = SteamMatchmaking()->GetNumLobbyMembers(lobby);
            for (int i = 0; i < memberCount; i++)
            {
                uint64_t member = SteamMatchmaking()->GetLobbyMemberByIndex(lobby, i).ConvertToUint64();
                if (member != 0 && member != host)
                {
                    peerName = GetPersonaName(member);
                    break;
                }
            }
        }

        std::string payload = hostName + "\n" + peerName;
        packetHandler_(MpPacketType::LobbyNames, EncodeStringPayload(payload));
        if (p2p_.HasConnection())
        {
            p2p_.Send(MpPacketType::LobbyNames, EncodeStringPayload(payload), true);
        }
        log_("SteamLobby: names host='" + hostName + "' peer='" + peerName + "'");
#endif
    }

    std::string SteamLobby::GetPersonaName(uint64_t steamId) const
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (steamId == 0 || SteamFriends() == nullptr)
        {
            return "";
        }

        CSteamID id(steamId);
        SteamFriends()->RequestUserInformation(id, true);
        const char* name = SteamFriends()->GetFriendPersonaName(id);
        if (name != nullptr && name[0] != '\0' && std::string(name) != "[unknown]")
        {
            return name;
        }

        if (SteamUser() != nullptr && SteamUser()->GetSteamID().ConvertToUint64() == steamId)
        {
            const char* selfName = SteamFriends()->GetPersonaName();
            return selfName != nullptr ? selfName : "";
        }
#else
        (void)steamId;
#endif
        return "";
    }
}
