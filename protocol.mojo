from math import isnan
from math.limit import isinf

from libc import c_char
from libc import c_charptr_to_string, to_char_ptr

# redis tokens
alias REDIS_CRLF: String = "\r\n"
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
    var msg: String
    var size: Int
    var result: String

    fn __init__(inout self: Self, msg: String):
        let msg_ptr = to_char_ptr(msg)
        self.msg = msg
        self.size = len(msg)
        self.result = ""

    fn parse(inout self: Self):
        if self.msg[0] != REDIS_ARRAY:
            return

        var i = 1

        var len_str: String = ""
        while i < self.size:
            if self.msg[i] == REDIS_CRLF[0] and self.msg[i + 1] == REDIS_CRLF[1]:
                len_str = self.msg[1:i]
                break
            i += 1

        let size: Int

        try:
            size = atol(len_str)
        except:
            return

        print("REDIS_ARRAY size:", size)

        var strings = DynamicVector[String]()
        i += 2

        for n in range(size):
            var j = i  # puts us after the size part
            while j < self.size:
                if self.msg[j] == REDIS_CRLF[0] and self.msg[j + 1] == REDIS_CRLF[1]:
                    let x = self.msg[i:j]
                    break

                j += 1

        # print("COMMAND:", command)

        self.result = "+PONG" + REDIS_CRLF

    # fn advance(inout self: Self) -> UInt8:
    #     self.current = self.current + 1
    #
    #     return (self.current - 1).load()
    #
    # fn peek(inout self: Self) -> UInt8:
    #     return self.current.load()
    #
    # fn peek_next(inout self: Self) -> UInt8:
    #     return self.current[1]
    #
    # fn is_digit(inout self: Self, c: UInt8) -> Bool:
    #     return c >= ord("0") and c <= ord("9")
    #
    # fn is_alpha(inout self: Self, c: UInt8) -> Bool:
    #     return (c >= ord("a") and c <= ord("z")) or (c >= ord("A") and c <= ord("Z"))
    #
    # fn is_at_end(inout self: Self) -> Bool:
    #     return self.current.load() == 0
    #
    # fn match_char(inout self: Self, c: UInt8) -> Bool:
    #     if self.is_at_end():
    #         return False
    #
    #     if self.current.load() != c:
    #         return False
    #
    #     self.current += 1
    #     return True


fn make_msg(header: String, msg: String) -> String:
    let msg_len = len(msg)
    let header_len = len(header)
    let buf = Pointer[c_char]().alloc(header_len + msg_len + 2)

    buf.store(0, ord(header))

    for i in range(msg_len):
        buf.store(header_len + i, ord(msg[i]))

    buf.store(header_len + msg_len, ord(REDIS_CRLF[0]))
    buf.store(header_len + msg_len + 1, ord(REDIS_CRLF[1]))

    return c_charptr_to_string(buf, header_len + msg_len + 2)


fn make_string(msg: String) -> String:
    return make_msg(REDIS_STRING, msg)


fn make_error(msg: String) -> String:
    return make_msg(REDIS_ERROR, msg)


fn make_integer(msg: Int) -> String:
    return make_msg(REDIS_INTEGER, String(msg))


fn make_bulk_string(msg: String) -> String:
    let header: String

    if not msg:
        header = REDIS_BULK_STRING + "-1" + REDIS_CRLF
    else:
        header = REDIS_BULK_STRING + String(len(msg)) + REDIS_CRLF

    return make_msg(header, msg)


fn make_array(msgs: VariadicList[String]) -> String:
    let msgs_len = len(msgs)
    let header = REDIS_ARRAY + String(msgs_len) + REDIS_CRLF
    var result: String = ""

    for msg in range(msgs_len):
        result += msg

    return make_msg(header, result)


fn make_array(msgs: None) -> String:
    let header = REDIS_ARRAY + "-1"

    return make_msg(header, "")


fn make_null() -> String:
    return make_msg(REDIS_NULL, "")


fn make_bool(msg: Bool) -> String:
    if msg:
        return make_msg(REDIS_BOOL, "t")
    else:
        return make_msg(REDIS_BOOL, "f")


fn make_double(msg: None) -> String:
    return make_msg(REDIS_DOUBLE, "nan")


fn make_double(msg: Float32) -> String:
    if isnan(msg):
        return make_msg(REDIS_DOUBLE, "nan")
    elif isinf(msg):
        if msg > 0:
            return make_msg(REDIS_DOUBLE, "inf")
        else:
            return make_msg(REDIS_DOUBLE, "-inf")
    else:
        return make_msg(REDIS_DOUBLE, String(msg))


fn make_big_integer(msg: Int64) -> String:
    return make_msg(REDIS_BIG_NUMBER, String(msg))
