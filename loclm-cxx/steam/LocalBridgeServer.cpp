#include "LocalBridgeServer.h"

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>
#include <WinSock2.h>
#include <WS2tcpip.h>

#include <algorithm>
#include <chrono>
#include <fstream>
#include <utility>

namespace loclm::mp
{
    namespace
    {
        constexpr SOCKET InvalidSocket = INVALID_SOCKET;

        void CloseSocket(uintptr_t value)
        {
            if (value != ~static_cast<uintptr_t>(0))
            {
                closesocket(static_cast<SOCKET>(value));
            }
        }

        bool IsLoopback(const sockaddr_in& address)
        {
            return ntohl(address.sin_addr.s_addr) == 0x7F000001;
        }

        bool SendAll(SOCKET socket, const uint8_t* data, size_t size)
        {
            size_t sent = 0;
            while (sent < size)
            {
                int result = send(socket, reinterpret_cast<const char*>(data + sent), static_cast<int>(size - sent), 0);
                if (result <= 0)
                {
                    return false;
                }

                sent += static_cast<size_t>(result);
            }

            return true;
        }
    }

    LocalBridgeServer::LocalBridgeServer(std::wstring runtimeDirectory, uint16_t preferredPort, PacketHandler packetHandler, LogHandler logHandler)
        : runtimeDirectory_(std::move(runtimeDirectory)),
          preferredPort_(preferredPort),
          packetHandler_(std::move(packetHandler)),
          log_(std::move(logHandler))
    {
    }

    LocalBridgeServer::~LocalBridgeServer()
    {
        Stop();
    }

    bool LocalBridgeServer::Start()
    {
        if (running_)
        {
            return true;
        }

        WSADATA data = {};
        if (WSAStartup(MAKEWORD(2, 2), &data) != 0)
        {
            log_("LocalBridgeServer: WSAStartup failed");
            return false;
        }

        for (uint16_t port = preferredPort_; port <= MaxBridgePort; ++port)
        {
            if (BindListener(port))
            {
                port_ = port;
                break;
            }
        }

        if (port_ == 0)
        {
            log_("LocalBridgeServer: could not bind any localhost port");
            WSACleanup();
            return false;
        }

        running_ = true;
        WritePortFile();
        thread_ = std::thread(&LocalBridgeServer::Run, this);
        log_("LocalBridgeServer: listening on 127.0.0.1:" + std::to_string(port_));
        return true;
    }

    void LocalBridgeServer::Stop()
    {
        if (!running_.exchange(false))
        {
            return;
        }

        CloseSocket(listener_);
        listener_ = ~static_cast<uintptr_t>(0);
        {
            std::lock_guard lock(clientsMutex_);
            for (uintptr_t client : clients_)
            {
                CloseSocket(client);
            }
            clients_.clear();
        }

        if (thread_.joinable())
        {
            thread_.join();
        }

        WSACleanup();
    }

    void LocalBridgeServer::SendToClients(MpPacketType type, const std::vector<uint8_t>& payload)
    {
        std::vector<uint8_t> packet = EncodeLocalPacket(type, payload);
        std::lock_guard lock(clientsMutex_);
        for (size_t i = 0; i < clients_.size();)
        {
            SOCKET socket = static_cast<SOCKET>(clients_[i]);
            if (!SendAll(socket, packet.data(), packet.size()))
            {
                DropClient(i);
                continue;
            }

            ++i;
        }
    }

    uint16_t LocalBridgeServer::Port() const
    {
        return port_;
    }

    bool LocalBridgeServer::IsRunning() const
    {
        return running_;
    }

    void LocalBridgeServer::Run()
    {
        while (running_)
        {
            AcceptClient();
            ReadClients();
            std::this_thread::sleep_for(std::chrono::milliseconds(8));
        }
    }

    bool LocalBridgeServer::BindListener(uint16_t port)
    {
        SOCKET socket = ::socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
        if (socket == InvalidSocket)
        {
            return false;
        }

        u_long nonBlocking = 1;
        ioctlsocket(socket, FIONBIO, &nonBlocking);

        sockaddr_in address = {};
        address.sin_family = AF_INET;
        address.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
        address.sin_port = htons(port);

        if (bind(socket, reinterpret_cast<sockaddr*>(&address), sizeof(address)) == SOCKET_ERROR ||
            listen(socket, SOMAXCONN) == SOCKET_ERROR)
        {
            closesocket(socket);
            return false;
        }

        listener_ = static_cast<uintptr_t>(socket);
        return true;
    }

    void LocalBridgeServer::AcceptClient()
    {
        sockaddr_in address = {};
        int length = sizeof(address);
        SOCKET socket = accept(static_cast<SOCKET>(listener_), reinterpret_cast<sockaddr*>(&address), &length);
        if (socket == InvalidSocket)
        {
            return;
        }

        if (!IsLoopback(address))
        {
            log_("LocalBridgeServer: rejected non-loopback client");
            closesocket(socket);
            return;
        }

        u_long nonBlocking = 1;
        ioctlsocket(socket, FIONBIO, &nonBlocking);
        {
            std::lock_guard lock(clientsMutex_);
            clients_.push_back(static_cast<uintptr_t>(socket));
        }

        log_("LocalBridgeServer: GML client connected");
        SendToClients(MpPacketType::Welcome, EncodeStringPayload("LOCLM Steam bridge ready"));
    }

    void LocalBridgeServer::ReadClients()
    {
        std::vector<std::pair<MpPacketType, std::vector<uint8_t>>> packets;
        {
            std::lock_guard lock(clientsMutex_);
            for (size_t i = 0; i < clients_.size();)
            {
                SOCKET socket = static_cast<SOCKET>(clients_[i]);
                uint16_t length = 0;
                int peek = recv(socket, reinterpret_cast<char*>(&length), sizeof(length), MSG_PEEK);
                if (peek == 0)
                {
                    DropClient(i);
                    continue;
                }

                if (peek == SOCKET_ERROR)
                {
                    int error = WSAGetLastError();
                    if (error == WSAEWOULDBLOCK)
                    {
                        ++i;
                        continue;
                    }

                    DropClient(i);
                    continue;
                }

                if (peek < static_cast<int>(sizeof(length)))
                {
                    ++i;
                    continue;
                }

                if (length == 0 || length > MaxPacketSize)
                {
                    log_("LocalBridgeServer: dropping oversized or empty local packet");
                    DropClient(i);
                    continue;
                }

                std::vector<uint8_t> framed(sizeof(length) + length);
                int received = recv(socket, reinterpret_cast<char*>(framed.data()), static_cast<int>(framed.size()), 0);
                if (received != static_cast<int>(framed.size()))
                {
                    ++i;
                    continue;
                }

                std::vector<uint8_t> packet(framed.begin() + sizeof(length), framed.end());
                MpPacketType type = MpPacketType::Error;
                std::vector<uint8_t> payload;
                if (DecodeLocalPacket(packet, type, payload))
                {
                    packets.emplace_back(type, std::move(payload));
                }

                ++i;
            }
        }

        for (const auto& packet : packets)
        {
            packetHandler_(packet.first, packet.second);
        }
    }

    void LocalBridgeServer::DropClient(size_t index)
    {
        if (index >= clients_.size())
        {
            return;
        }

        CloseSocket(clients_[index]);
        clients_.erase(clients_.begin() + static_cast<std::ptrdiff_t>(index));
        log_("LocalBridgeServer: GML client disconnected");
    }

    void LocalBridgeServer::WritePortFile() const
    {
        CreateDirectoryW(runtimeDirectory_.c_str(), nullptr);
        std::wstring path = runtimeDirectory_ + L"\\steam_bridge_port.txt";
        std::ofstream file(path);
        if (file)
        {
            file << port_ << "\n";
        }
    }
}
