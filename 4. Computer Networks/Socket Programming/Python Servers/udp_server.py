#!/usr/bin/env python3

import socket
from time import sleep

IP = "0.0.0.0"
PORT = 5555
ADDR = (IP, PORT)

INT_BYTES = 4


def main() -> None:
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    # do this before bind so that we can reuse
    # the port in case the program crashes
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

    sock.bind(ADDR)
    print(f"Listening on {PORT}...")

    try:
        while True:
            buff, addr = sock.recvfrom(INT_BYTES)
            print(f"Received {len(buff)} bytes from {addr}")

            number = int.from_bytes(buff, byteorder="big", signed=False)
            print(f"Got: {number} from {addr}")

            to_send = number * 2
            sock.sendto(
                to_send.to_bytes(INT_BYTES, byteorder="big", signed=False), addr
            )
            print(f"Sent: {to_send} to {addr}")

            # WARNING: UDP packets are not in order, this is bad
            # Send 0 bytes to signal end of transmission
            # sleep(1)
            sock.sendto(b"", addr)
            print(f"Signaled finish by sending 0 bytes to {addr}")

    except KeyboardInterrupt:
        print("\rStopping...")

    sock.close()
    print("Socket closed")


if __name__ == "__main__":
    main()
