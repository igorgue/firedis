#!/usr/bin/env python3
import socket


def create_server(
    host: str,
    port: int,
    reuse_port: bool,
) -> socket.socket:
    return socket.create_server((host, port), reuse_port=reuse_port)


if __name__ == "__main__":
    host = "localhost"
    port = 6379

    print("> starting firedis on host:", host, "and port", port, "🔥")
    server_socket = create_server(host, port, True)
    client_socket, addr = server_socket.accept()

    print(f"> client connected: {addr}")

    while True:
        data = client_socket.recv(1024)

        print("> received:", data)

        pong = b"+PONG\r\n"
        res = client_socket.send(pong)

        print(">", res, "bytes sent")
