import socket


def create_server(
    host: str,
    port: int,
    reuse_port: bool,
) -> socket.socket:
    return socket.create_server((host, port), reuse_port=reuse_port)
