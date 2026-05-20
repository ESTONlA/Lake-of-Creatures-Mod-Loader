#pragma once

#include <cstdint>
#include <string>
#include <vector>

namespace loclm::mp
{
    constexpr uint8_t Magic = 'L';
    constexpr uint8_t ProtocolVersion = 1;
    constexpr size_t MaxPacketSize = 1200;
    constexpr uint16_t DefaultBridgePort = 38470;
    constexpr uint16_t MaxBridgePort = 38490;

    enum class MpPacketType : uint8_t
    {
        Hello = 1,
        Welcome = 2,
        CreateLobby = 3,
        JoinLobby = 4,
        LobbyCreated = 5,
        LobbyJoined = 6,
        LobbyFailed = 7,
        StartHost = 8,
        ConnectToHost = 9,
        PlayerState = 10,
        RemotePlayerState = 11,
        Disconnect = 12,
        Error = 13,
        DebugLog = 14,
        LobbyNames = 15,
        WorldState = 16
    };

    struct NetworkPacket
    {
        MpPacketType type = MpPacketType::Error;
        uint32_t tick = 0;
        std::vector<uint8_t> payload;
    };

    struct PlayerState
    {
        uint64_t steamId = 0;
        float x = 0;
        float y = 0;
        float hspeed = 0;
        float vspeed = 0;
        float imageXScale = 1;
        uint32_t roomId = 0;
        uint16_t spriteId = 0;
        float imageIndex = 0;
    };

    std::vector<uint8_t> EncodeLocalPacket(MpPacketType type, const std::vector<uint8_t>& payload);
    bool DecodeLocalPacket(const std::vector<uint8_t>& bytes, MpPacketType& type, std::vector<uint8_t>& payload);

    std::vector<uint8_t> EncodeNetworkPacket(MpPacketType type, uint32_t tick, const std::vector<uint8_t>& payload);
    bool DecodeNetworkPacket(const uint8_t* data, size_t size, NetworkPacket& packet);

    std::vector<uint8_t> EncodeStringPayload(const std::string& value);
    std::string DecodeStringPayload(const std::vector<uint8_t>& payload);

    std::vector<uint8_t> EncodeU64Payload(uint64_t value);
    bool DecodeU64Payload(const std::vector<uint8_t>& payload, uint64_t& value);

    std::vector<uint8_t> EncodePlayerState(const PlayerState& state);
    bool DecodePlayerState(const std::vector<uint8_t>& payload, PlayerState& state);

    const char* PacketTypeName(MpPacketType type);
}
