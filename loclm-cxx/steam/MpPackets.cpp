#include "MpPackets.h"

#include <cstring>

namespace loclm::mp
{
    namespace
    {
        template <typename T>
        void Append(std::vector<uint8_t>& out, T value)
        {
            uint8_t bytes[sizeof(T)] = {};
            std::memcpy(bytes, &value, sizeof(T));
            out.insert(out.end(), bytes, bytes + sizeof(T));
        }

        template <typename T>
        bool Read(const std::vector<uint8_t>& data, size_t& offset, T& value)
        {
            if (offset + sizeof(T) > data.size())
            {
                return false;
            }

            std::memcpy(&value, data.data() + offset, sizeof(T));
            offset += sizeof(T);
            return true;
        }
    }

    std::vector<uint8_t> EncodeLocalPacket(MpPacketType type, const std::vector<uint8_t>& payload)
    {
        std::vector<uint8_t> out;
        const uint16_t length = static_cast<uint16_t>(1 + payload.size());
        Append(out, length);
        out.push_back(static_cast<uint8_t>(type));
        out.insert(out.end(), payload.begin(), payload.end());
        return out;
    }

    bool DecodeLocalPacket(const std::vector<uint8_t>& bytes, MpPacketType& type, std::vector<uint8_t>& payload)
    {
        if (bytes.empty() || bytes.size() > MaxPacketSize)
        {
            return false;
        }

        type = static_cast<MpPacketType>(bytes[0]);
        payload.assign(bytes.begin() + 1, bytes.end());
        return true;
    }

    std::vector<uint8_t> EncodeNetworkPacket(MpPacketType type, uint32_t tick, const std::vector<uint8_t>& payload)
    {
        std::vector<uint8_t> out;
        out.reserve(7 + payload.size());
        out.push_back(Magic);
        out.push_back(ProtocolVersion);
        out.push_back(static_cast<uint8_t>(type));
        Append(out, tick);
        out.insert(out.end(), payload.begin(), payload.end());
        return out;
    }

    bool DecodeNetworkPacket(const uint8_t* data, size_t size, NetworkPacket& packet)
    {
        if (data == nullptr || size < 7 || size > MaxPacketSize || data[0] != Magic || data[1] != ProtocolVersion)
        {
            return false;
        }

        packet.type = static_cast<MpPacketType>(data[2]);
        std::memcpy(&packet.tick, data + 3, sizeof(uint32_t));
        packet.payload.assign(data + 7, data + size);
        return true;
    }

    std::vector<uint8_t> EncodeStringPayload(const std::string& value)
    {
        std::vector<uint8_t> out;
        const uint16_t length = static_cast<uint16_t>(value.size());
        Append(out, length);
        out.insert(out.end(), value.begin(), value.end());
        return out;
    }

    std::string DecodeStringPayload(const std::vector<uint8_t>& payload)
    {
        if (payload.size() < sizeof(uint16_t))
        {
            return "";
        }

        uint16_t length = 0;
        std::memcpy(&length, payload.data(), sizeof(uint16_t));
        if (sizeof(uint16_t) + length > payload.size())
        {
            return "";
        }

        return std::string(reinterpret_cast<const char*>(payload.data() + sizeof(uint16_t)), length);
    }

    std::vector<uint8_t> EncodeU64Payload(uint64_t value)
    {
        std::vector<uint8_t> out;
        Append(out, value);
        return out;
    }

    bool DecodeU64Payload(const std::vector<uint8_t>& payload, uint64_t& value)
    {
        if (payload.size() < sizeof(uint64_t))
        {
            return false;
        }

        std::memcpy(&value, payload.data(), sizeof(uint64_t));
        return true;
    }

    std::vector<uint8_t> EncodePlayerState(const PlayerState& state)
    {
        std::vector<uint8_t> out;
        Append(out, state.steamId);
        Append(out, state.x);
        Append(out, state.y);
        Append(out, state.hspeed);
        Append(out, state.vspeed);
        Append(out, state.imageXScale);
        Append(out, state.roomId);
        Append(out, state.spriteId);
        Append(out, state.imageIndex);
        return out;
    }

    bool DecodePlayerState(const std::vector<uint8_t>& payload, PlayerState& state)
    {
        size_t offset = 0;
        return Read(payload, offset, state.steamId) &&
            Read(payload, offset, state.x) &&
            Read(payload, offset, state.y) &&
            Read(payload, offset, state.hspeed) &&
            Read(payload, offset, state.vspeed) &&
            Read(payload, offset, state.imageXScale) &&
            Read(payload, offset, state.roomId) &&
            Read(payload, offset, state.spriteId) &&
            Read(payload, offset, state.imageIndex);
    }

    const char* PacketTypeName(MpPacketType type)
    {
        switch (type)
        {
        case MpPacketType::Hello: return "HELLO";
        case MpPacketType::Welcome: return "WELCOME";
        case MpPacketType::CreateLobby: return "CREATE_LOBBY";
        case MpPacketType::JoinLobby: return "JOIN_LOBBY";
        case MpPacketType::LobbyCreated: return "LOBBY_CREATED";
        case MpPacketType::LobbyJoined: return "LOBBY_JOINED";
        case MpPacketType::LobbyFailed: return "LOBBY_FAILED";
        case MpPacketType::StartHost: return "START_HOST";
        case MpPacketType::ConnectToHost: return "CONNECT_TO_HOST";
        case MpPacketType::PlayerState: return "PLAYER_STATE";
        case MpPacketType::RemotePlayerState: return "REMOTE_PLAYER_STATE";
        case MpPacketType::Disconnect: return "DISCONNECT";
        case MpPacketType::Error: return "ERROR";
        case MpPacketType::DebugLog: return "DEBUG_LOG";
        case MpPacketType::LobbyNames: return "LOBBY_NAMES";
        case MpPacketType::WorldState: return "WORLD_STATE";
        default: return "UNKNOWN";
        }
    }
}
