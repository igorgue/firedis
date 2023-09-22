from math import isnan
from math.limit import isinf

from libc import c_char
from libc import c_charptr_to_string, to_char_ptr

from dodgy import DodgyString

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

    fn parse(inout self: Self) raises:
        print_no_newline('\n> msg:"')
        print_no_newline(self.msg)
        print('"')
        var i = 1  # skip REDIS_ARRAY char

        var len_str: String = ""
        while i < self.size:
            if self.msg[i] == REDIS_CRLF[0] and self.msg[i + 1] == REDIS_CRLF[1]:
                len_str = self.msg[1:i]
                i += 1
                break
            i += 1

        let size: Int = atol(len_str)

        var strings = DynamicVector[DodgyString]()
        i += 2 + 1  # skip REDIS_CRLF

        self.result = make_msg(REDIS_STRING, "PONG")

        for n in range(size):
            # print("> self.msg[i - 1]:", self.msg[i - 1])
            # print("> self.msg[i]:", self.msg[i])
            var j = i
            var msg_size_str: String = ""

            while j < self.size:
                if self.msg[j] == REDIS_CRLF[0] and self.msg[j + 1] == REDIS_CRLF[1]:
                    msg_size_str = self.msg[i:j]
                    j += 2  # skip REDIS_CRLF
                    i += 2
                    break

                j += 1

            # print("> n:", n, "msg_size_str:", msg_size_str)

            let msg_size = atol(msg_size_str)

            if msg_size == -1:
                strings.push_back(DodgyString(""))
            else:
                let msg = self.msg[j : j + msg_size]
                strings.push_back(DodgyString(msg))

            i += msg_size + 2 + 2

        for i in range(size):
            print(i, ":", strings[i].to_string())
            # self.result += make_bulk_string(strings[i].to_string())

        self.result = make_msg(REDIS_STRING, "PONG")

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
