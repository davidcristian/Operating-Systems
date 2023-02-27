#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <winsock2.h>
#include <ws2tcpip.h>

#pragma comment (lib, "Ws2_32.lib")
#pragma comment (lib, "Mswsock.lib")
#pragma comment (lib, "AdvApi32.lib")

#include <iostream>

#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 7777

#define CONN_FAMILY AF_INET
#define SOCK_TYPE SOCK_STREAM
#define SOCK_PROTOCOL IPPROTO_TCP

int main()
{
	std::cout << "TCP client" << std::endl;
	unsigned int number;

	std::cout << "Positive integer: ";
	std::cin >> number;

	// Convert to network byte order
	u_long numberToSend = htonl(number);

	// Start WSA
	WSAData wsaData;
	if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0)
	{
		std::cout << "ERROR: WSAStartup()" << std::endl;
		return 1;
	}

	// Create socket
	SOCKET sock = socket(CONN_FAMILY, SOCK_TYPE, SOCK_PROTOCOL);
	if (sock == INVALID_SOCKET)
	{
		std::cout << "ERROR: socket()" << std::endl;
		WSACleanup();
		return 2;
	}

	SOCKADDR_IN connection;
	connection.sin_family = CONN_FAMILY;
	connection.sin_port = htons(SERVER_PORT);

	// Convert IPv4 and IPv6 addresses from text to binary form
	if (inet_pton(CONN_FAMILY, SERVER_IP, &connection.sin_addr) != 1)
	{
		std::cout << "ERROR: inet_pton()" << std::endl;
		WSACleanup();
		return 3;
	}

	// Connect to server
	if (connect(sock, (SOCKADDR*)&connection, sizeof(connection)) == SOCKET_ERROR)
	{
		std::cout << "ERROR: connect()" << std::endl;
		closesocket(sock);
		WSACleanup();
		return 4;
	}

	// Send number to server
	if (send(sock, (char*)&numberToSend, sizeof(numberToSend), 0) == SOCKET_ERROR)
	{
		std::cout << "ERROR: send()" << std::endl;
		closesocket(sock);
		WSACleanup();
		return 5;
	}
	std::cout << "Sent: " << number << std::endl;

	// Get number from server
	u_long receivedNumber;

	while (true)
	{
		int recvBytes = recv(sock, (char*)&receivedNumber, sizeof(receivedNumber), 0);
		if (recvBytes == 0)
		{
			std::cout << "INFO: Connection closed" << std::endl;
			break;
		}

		if (recvBytes < 0)
		{
			std::cout << "ERROR: recv()" << std::endl;
			closesocket(sock);
			WSACleanup();
			return 6;
		}

		// Convert to host byte order
		unsigned int final = ntohl(receivedNumber);
		std::cout << "Got: " << final << std::endl;
	}

	// Close socket
	closesocket(sock);
	WSACleanup();

	std::cout << "Socket closed" << std::endl;
	return 0;
}
