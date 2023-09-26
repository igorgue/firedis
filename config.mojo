from libc import exit

from algorithm import num_cores
from os import getenv


# firedis config defaults
alias FIREDIS_MAX_CLIENTS = 128
alias FIREDIS_CORE_MULTIPLIER = 1000
alias FIREDIS_PORT = 6379
alias FIREDIS_HOST = "0.0.0.0"


struct FiredisConfig:
    """
    Firedis configuration struct.
    """

    var max_clients: Int
    var core_multiplier: Int
    var workers: Int
    var port: UInt16
    var host: StringRef

    fn __init__(
        inout self: Self,
        max_clients: Int,
        core_multiplier: Int,
        workers: Int,
        port: UInt16,
        host: StringRef,
    ):
        self.max_clients = max_clients
        self.core_multiplier = core_multiplier
        self.workers = workers
        self.port = port
        self.host = host


fn load_config() -> FiredisConfig:
    try:
        var max_clients = atol(getenv("MAX_CLIENTS", "-1"))
        var core_multiplier = atol(getenv("CORE_MULTIPLIER", "-1"))
        var port = atol(getenv("PORT", "-1"))
        let host = getenv("HOST", FIREDIS_HOST)

        if port == -1:
            port = FIREDIS_PORT

        if core_multiplier == -1:
            core_multiplier = FIREDIS_CORE_MULTIPLIER

        if max_clients == -1:
            max_clients = FIREDIS_MAX_CLIENTS
        var workers = (num_cores() * core_multiplier)
        if workers > max_clients:
            workers = max_clients

        return FiredisConfig(max_clients, core_multiplier, workers, port, host)
    except e:
        print("> failed to start firedis:", e.value)
        print("> error loading configuration, exiting...")

        exit(-1)

        return FiredisConfig(-1, -1, -1, 0, "")
