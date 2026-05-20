#include "SteamP2P.h"

namespace loclm::mp
{
    SteamP2P::SteamP2P(PacketHandler packetHandler, LogHandler logHandler)
        : packetHandler_(std::move(packetHandler)),
          log_(std::move(logHandler))
    {
    }

    SteamP2P::~SteamP2P()
    {
        Disconnect();
    }

    bool SteamP2P::StartHost()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamNetworkingSockets() == nullptr)
        {
            log_("SteamP2P: SteamNetworkingSockets unavailable");
            return false;
        }

        if (listenSocket_ != k_HSteamListenSocket_Invalid)
        {
            return true;
        }

        listenSocket_ = SteamNetworkingSockets()->CreateListenSocketP2P(0, 0, nullptr);
        if (listenSocket_ == k_HSteamListenSocket_Invalid)
        {
            log_("SteamP2P: CreateListenSocketP2P failed");
            return false;
        }

        log_("SteamP2P: P2P listen socket created");
        return true;
#else
        log_("SteamP2P: Steamworks disabled at build time; host listen unavailable");
        return false;
#endif
    }

    bool SteamP2P::ConnectToHost(uint64_t hostSteamId)
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamNetworkingSockets() == nullptr)
        {
            log_("SteamP2P: SteamNetworkingSockets unavailable");
            return false;
        }

        hostSteamId_ = hostSteamId;
        SteamNetworkingIdentity identity;
        identity.Clear();
        identity.SetSteamID64(hostSteamId);
        connection_ = SteamNetworkingSockets()->ConnectP2P(identity, 0, 0, nullptr);
        if (connection_ == k_HSteamNetConnection_Invalid)
        {
            log_("SteamP2P: ConnectP2P failed");
            return false;
        }

        log_("SteamP2P: ConnectP2P started to " + std::to_string(hostSteamId));
        return true;
#else
        hostSteamId_ = hostSteamId;
        connected_ = false;
        log_("SteamP2P: Steamworks disabled at build time; ConnectP2P unavailable");
        return false;
#endif
    }

    void SteamP2P::Disconnect()
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamNetworkingSockets() != nullptr)
        {
            if (connection_ != k_HSteamNetConnection_Invalid)
            {
                SteamNetworkingSockets()->CloseConnection(connection_, 0, "LOCLM disconnect", false);
                connection_ = k_HSteamNetConnection_Invalid;
            }

            if (listenSocket_ != k_HSteamListenSocket_Invalid)
            {
                SteamNetworkingSockets()->CloseListenSocket(listenSocket_);
                listenSocket_ = k_HSteamListenSocket_Invalid;
            }
        }
#else
        connected_ = false;
#endif
    }

    void SteamP2P::Tick()
    {
        tick_++;
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamNetworkingSockets() == nullptr || connection_ == k_HSteamNetConnection_Invalid)
        {
            return;
        }

        while (true)
        {
            ISteamNetworkingMessage* message = nullptr;
            int count = SteamNetworkingSockets()->ReceiveMessagesOnConnection(connection_, &message, 1);
            if (count <= 0 || message == nullptr)
            {
                break;
            }

            NetworkPacket packet;
            if (DecodeNetworkPacket(static_cast<const uint8_t*>(message->m_pData), static_cast<size_t>(message->m_cbSize), packet))
            {
                std::vector<uint8_t> payload = packet.payload;
                if (packet.type == MpPacketType::PlayerState)
                {
                    PlayerState state;
                    if (DecodePlayerState(payload, state) && state.steamId == 0 && remoteSteamId_ != 0)
                    {
                        state.steamId = remoteSteamId_;
                        payload = EncodePlayerState(state);
                    }
                }
                MpPacketType localType = packet.type == MpPacketType::PlayerState
                    ? MpPacketType::RemotePlayerState
                    : packet.type;
                packetHandler_(localType, payload);
            }

            message->Release();
        }
#endif
    }

    bool SteamP2P::Send(MpPacketType type, const std::vector<uint8_t>& payload, bool reliable)
    {
#if LOCLM_ENABLE_STEAMWORKS
        if (SteamNetworkingSockets() == nullptr || connection_ == k_HSteamNetConnection_Invalid)
        {
            return false;
        }

        std::vector<uint8_t> packet = EncodeNetworkPacket(type, tick_, payload);
        int flags = reliable ? k_nSteamNetworkingSend_Reliable : k_nSteamNetworkingSend_UnreliableNoDelay;
        EResult result = SteamNetworkingSockets()->SendMessageToConnection(
            connection_,
            packet.data(),
            static_cast<uint32>(packet.size()),
            flags,
            nullptr);
        return result == k_EResultOK;
#else
        (void)type;
        (void)payload;
        (void)reliable;
        return false;
#endif
    }

    bool SteamP2P::HasConnection() const
    {
#if LOCLM_ENABLE_STEAMWORKS
        return connection_ != k_HSteamNetConnection_Invalid;
#else
        return connected_;
#endif
    }

    uint64_t SteamP2P::RemoteSteamId() const
    {
        return remoteSteamId_;
    }

#if LOCLM_ENABLE_STEAMWORKS
    void SteamP2P::OnConnectionStatusChanged(SteamNetConnectionStatusChangedCallback_t* callback)
    {
        if (callback == nullptr || SteamNetworkingSockets() == nullptr)
        {
            return;
        }

        std::string state = std::to_string(callback->m_info.m_eState);
        log_("SteamP2P: connection state changed to " + state);
        uint64_t remoteId = callback->m_info.m_identityRemote.GetSteamID64();
        if (remoteId != 0)
        {
            remoteSteamId_ = remoteId;
        }

        if (callback->m_info.m_eState == k_ESteamNetworkingConnectionState_Connecting)
        {
            if (listenSocket_ != k_HSteamListenSocket_Invalid && connection_ == k_HSteamNetConnection_Invalid)
            {
                if (SteamNetworkingSockets()->AcceptConnection(callback->m_hConn) == k_EResultOK)
                {
                    connection_ = callback->m_hConn;
                    remoteSteamId_ = remoteId;
                    log_("SteamP2P: accepted incoming P2P connection");
                    packetHandler_(MpPacketType::Welcome, EncodeStringPayload("Steam P2P connected"));
                }
                else
                {
                    SteamNetworkingSockets()->CloseConnection(callback->m_hConn, 0, "Accept failed", false);
                }
            }
        }
        else if (callback->m_info.m_eState == k_ESteamNetworkingConnectionState_Connected)
        {
            connection_ = callback->m_hConn;
            remoteSteamId_ = remoteId;
            packetHandler_(MpPacketType::Welcome, EncodeStringPayload("Steam P2P connected"));
        }
        else if (callback->m_info.m_eState == k_ESteamNetworkingConnectionState_ClosedByPeer ||
            callback->m_info.m_eState == k_ESteamNetworkingConnectionState_ProblemDetectedLocally)
        {
            if (connection_ == callback->m_hConn)
            {
                connection_ = k_HSteamNetConnection_Invalid;
            }
            remoteSteamId_ = 0;

            packetHandler_(MpPacketType::Disconnect, EncodeStringPayload("Steam P2P disconnected"));
        }
    }
#endif
}
