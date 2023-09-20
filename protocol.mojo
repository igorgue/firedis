from math import isnan
from math.limit import isinf

from libc import c_char
from libc import c_charptr_to_string, to_char_ptr

# redis tokens
alias REDIS_CRLF = "\r\n"
alias REDIS_STRING = "+"
alias REDIS_ERROR = "-"
alias REDIS_INTEGER = ":"
alias REDIS_BULK_STRING = "$"
alias REDIS_ARRAY = "*"
alias REDIS_NULL = "_"
alias REDIS_BOOL = "#"
alias REDIS_DOUBLE = ","
alias REDIS_BIG_NUMBER = "("
alias REDIS_BULK_ERRORS = "!"
alias REDIS_VERBATIM_STRING = "="
alias REDIS_MAP = "%"
alias REDIS_SET = "~"
alias REDIS_PUSHES = "|"


struct FiredisParser:
    var start: Pointer[UInt8]
    var current: Pointer[UInt8]
    var result: String

    fn __init__(inout self: Self, msg: String):
        let msg_ptr = to_char_ptr(msg)

        self.start = msg_ptr
        self.current = msg_ptr
        self.result = ""

    fn parse(inout self: Self) -> None:
        self.result = "+PONG" + REDIS_CRLF

    fn advance(inout self: Self) -> UInt8:
        self.current = self.current + 1

        return (self.current - 1).load()

    fn peek(inout self: Self) -> UInt8:
        return self.current.load()

    fn peek_next(inout self: Self) -> UInt8:
        return self.current[1]

    fn is_digit(inout self: Self, c: UInt8) -> Bool:
        return c >= ord("0") and c <= ord("9")

    fn is_alpha(inout self: Self, c: UInt8) -> Bool:
        return (c >= ord("a") and c <= ord("z")) or (c >= ord("A") and c <= ord("Z"))

    fn is_at_end(inout self: Self) -> Bool:
        return self.current.load() == 0

    fn match_char(inout self: Self, c: UInt8) -> Bool:
        if self.is_at_end():
            return False

        if self.current.load() != c:
            return False

        self.current += 1
        return True

    fn make_msg(inout self: Self, header: String, msg: String) -> String:
        let msg_len = len(msg)
        let header_len = len(header)
        let buf = Pointer[c_char]().alloc(header_len + msg_len + 2)

        buf.store(0, ord(header))

        for i in range(msg_len):
            buf.store(header_len + i, ord(msg[i]))

        buf.store(header_len + msg_len, ord(String(REDIS_CRLF.data())[0]))
        buf.store(header_len + msg_len + 1, ord(String(REDIS_CRLF.data())[1]))

        return c_charptr_to_string(buf, header_len + msg_len + 2)

    fn make_string(inout self: Self, msg: String) -> String:
        return self.make_msg(REDIS_STRING, msg)

    fn make_error(inout self: Self, msg: String) -> String:
        return self.make_msg(REDIS_ERROR, msg)

    fn make_integer(inout self: Self, msg: Int) -> String:
        return self.make_msg(REDIS_INTEGER, String(msg))

    fn make_bulk_string(inout self: Self, msg: String) -> String:
        let header: String

        if not msg:
            header = REDIS_BULK_STRING + "-1" + REDIS_CRLF
        else:
            header = REDIS_BULK_STRING + String(len(msg)) + REDIS_CRLF

        return self.make_msg(header, msg)

    fn make_array(inout self: Self, msgs: VariadicList[String]) -> String:
        let msgs_len = len(msgs)
        let header = REDIS_ARRAY + String(msgs_len) + REDIS_CRLF
        var result: String = ""

        for msg in range(msgs_len):
            result += msg

        return self.make_msg(header, result)

    fn make_array(inout self: Self, msgs: None) -> String:
        let header = REDIS_ARRAY + "-1"

        return self.make_msg(header, "")

    fn make_null(inout self: Self) -> String:
        return self.make_msg(REDIS_NULL, "")

    fn make_bool(inout self: Self, msg: Bool) -> String:
        if msg:
            return self.make_msg(REDIS_BOOL, "t")
        else:
            return self.make_msg(REDIS_BOOL, "f")

    fn make_double(inout self: Self, msg: None) -> String:
        return self.make_msg(REDIS_DOUBLE, "nan")

    fn make_double(inout self: Self, msg: Float32) -> String:
        if isnan(msg):
            return self.make_msg(REDIS_DOUBLE, "nan")
        elif isinf(msg):
            if msg > 0:
                return self.make_msg(REDIS_DOUBLE, "inf")
            else:
                return self.make_msg(REDIS_DOUBLE, "-inf")
        else:
            return self.make_msg(REDIS_DOUBLE, String(msg))

    fn make_big_integer(inout self: Self, msg: Int64) -> String:
        return self.make_msg(REDIS_BIG_NUMBER, String(msg))
