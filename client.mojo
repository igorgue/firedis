from libc import c_void, c_uint, c_char
from libc import AF_INET, SOCK_STREAM, SHUT_RDWR
from libc import (
    inet_pton,
    to_char_ptr,
    htons,
    sockaddr_in,
    sockaddr,
    socket,
    connect,
    shutdown,
)


struct FiredisClient:
    """
    A client for redis.
    """

    var host: String
    var port: Int
    var db: Int
    var sockfd: Int32

    fn __init__(inout self):
        self.host = "0.0.0.0"
        self.port = 6379
        self.db = 0
        self.sockfd = 0

    fn __init__(inout self, host: String, port: Int, db: Int):
        self.host = host
        self.port = port
        self.db = db
        self.sockfd = 0

    fn connect(inout self) -> Bool:
        let address_family = AF_INET

        let ip_buf = Pointer[c_void].alloc(4)
        let conv_status = inet_pton(address_family, to_char_ptr(self.host), ip_buf)
        let raw_ip = ip_buf.bitcast[c_uint]().load()

        print("> inet_pton:", raw_ip, ":: status:", conv_status)

        let bin_port = htons(UInt16(self.port))

        print("> htons:", bin_port)

        var ai = sockaddr_in(address_family, bin_port, raw_ip, StaticTuple[8, c_char]())
        let ai_ptr = Pointer[sockaddr_in].address_of(ai).bitcast[sockaddr]()

        let sockfd = socket(address_family, SOCK_STREAM, 0)
        if sockfd == -1:
            print("> socket creation error")
            return False

        print("> sockfd:", sockfd)

        self.sockfd = sockfd

        if connect(sockfd, ai_ptr, sizeof[sockaddr_in]()) == -1:
            _ = shutdown(sockfd, SHUT_RDWR)
            return False

        return True


fn main():
    var client = FiredisClient()

    if client.connect():
        print("> connected")
    else:
        print("> connection failed")
