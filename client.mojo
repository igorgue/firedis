struct FiredisClient:
    """
    A client for redis.
    """

    var host: String
    var port: Int
    var db: Int

    fn __init__(inout self):
        self.host = "0.0.0.0"
        self.port = 6379
        self.db = 0

    fn __init__(inout self, host: String, port: Int, db: Int):
        self.host = host
        self.port = port
        self.db = db
