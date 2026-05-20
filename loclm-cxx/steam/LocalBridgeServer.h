#pragma once

#include "MpPackets.h"

#include <atomic>
#include <cstdint>
#include <functional>
#include <mutex>
#include <string>
#include <thread>
#include <vector>

namespace loclm::mp
{
    class LocalBridgeServer
    {
    public:
        using PacketHandler = std::function<void(MpPacketType, const std::vector<uint8_t>&)>;
        using LogHandler = std::function<void(const std::string&)>;

        LocalBridgeServer(std::wstring runtimeDirectory, uint16_t preferredPort, PacketHandler packetHandler, LogHandler logHandler);
        ~LocalBridgeServer();

        bool Start();
        void Stop();
        void SendToClients(MpPacketType type, const std::vector<uint8_t>& payload);
        uint16_t Port() const;
        bool IsRunning() const;

    private:
        void Run();
        bool BindListener(uint16_t port);
        void AcceptClient();
        void ReadClients();
        void DropClient(size_t index);
        void WritePortFile() const;

        std::wstring runtimeDirectory_;
        uint16_t preferredPort_ = DefaultBridgePort;
        uint16_t port_ = 0;
        PacketHandler packetHandler_;
        LogHandler log_;
        std::thread thread_;
        std::atomic<bool> running_ = false;
        uintptr_t listener_ = ~static_cast<uintptr_t>(0);
        std::mutex clientsMutex_;
        std::vector<uintptr_t> clients_;
    };
}
