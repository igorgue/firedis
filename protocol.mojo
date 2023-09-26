from math import isnan
from math.limit import isinf
from time import now

from string_utils import to_upper, to_repr, to_string_ref
from hashtable import Item
from table import Table

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
    """
    FiredisParser parses a redis message.
    """

    var msg: String
    var size: Int
    var result: String
    var db: Table

    fn __init__(inout self: Self, inout db: Table, msg: String):
        self.msg = msg
        self.db = db
        self.size = len(msg)
        self.result = ""

    fn __repr__(inout self: Self) -> String:
        return to_repr(self.msg)

    fn parse(inout self: Self) raises:
        var i = 1  # skip REDIS_ARRAY char

        var len_str: String = ""
        while i < self.size:
            if self.msg[i] == REDIS_CRLF[0] and self.msg[i + 1] == REDIS_CRLF[1]:
                len_str = self.msg[1:i]
                i += 1
                break
            i += 1

        let size: Int = atol(len_str)

        i += 1  # move after size

        var strings = DynamicVector[DodgyString]()

        for n in range(size):
            i += 1  # skip REDIS_BULK_STRING char

            var j = i

            while self.msg[j] != REDIS_CRLF[0] and self.msg[j + 1] != REDIS_CRLF[1]:
                j += 1

            let msg_len_str = self.msg[i:j]
            let msg_len = atol(msg_len_str)

            i += len(msg_len_str)  # skip len chars
            i += 2  # skip REDIS_CRLF chars

            let msg = self.msg[i : i + msg_len]
            strings.push_back(DodgyString(msg))

            i = i + msg_len + 2  # skip msg and REDIS_CRLF chars

        if i != self.size:
            let err = "could not parse message, did not parse: " + to_repr(self.msg[i:])
            raise Error(to_string_ref(err))

        let raw_command = strings[0].to_string()
        var args = DynamicVector[DodgyString]()

        for i in range(1, len(strings)):
            args.push_back(strings[i])

        self.build_result(raw_command, args)

    fn build_result(
        inout self: Self, raw_command: String, args: DynamicVector[DodgyString]
    ):
        let command = to_upper(raw_command)

        if command == "PING":
            if len(args) == 0:
                self.result = make_string("PONG")
                return

            if len(args) > 1:
                self.result = make_error("wrong number of arguments for 'ping' command")

            self.result = make_msg(REDIS_STRING, args[0].to_string())
        elif command == "ECHO":
            if len(args) > 1:
                self.result = make_error("wrong number of arguments for 'echo' command")
                return

            self.result = make_bulk_string(args[0].to_string())
        elif command == "GET":
            if len(args) > 1:
                self.result = make_error("wrong number of arguments for 'get' command")
                return

            let key = args[0].to_string_ref()
            var value: StringRef = ""

            if not self.db.get(key, value):
                self.result = make_null()
                return

            try:
                var item: Item[StringRef] = Item[StringRef]("null", "null")

                if not self.db.get_item(key, item):
                    self.result = make_null()
                    return

                let now_ms = now() // 1_000_000

                if item.expire == -1:
                    self.result = make_bulk_string(value)
                    return
                elif item.is_expired():
                    self.result = make_null()
                    return
                else:
                    self.result = make_bulk_string(value)
                    return
            except:
                self.result = make_error("could not get item")
                return
        elif command == "SET":
            var key: StringRef = ""
            var value: StringRef = ""

            if len(args) < 2:
                self.result = make_error("wrong number of arguments for 'set' command")
                return

            key = args[0].to_string_ref()
            value = args[1].to_string_ref()

            if self.db.set(key, value):
                self.result = make_string("OK")
            else:
                self.result = make_error("could not set value")

            if len(args) == 2:
                return

            for i in range(2, len(args), 2):
                let option_key = to_string_ref(to_upper(args[i].to_string()))
                let option_value = args[i + 1].to_string_ref()

                if option_key == "EX":
                    try:
                        let ex = atol(option_value)
                        if self.db.set_ex(key, ex):
                            self.result = make_string("OK")
                        else:
                            self.result = make_error("could not set ex value")
                            return
                    except e:
                        print("> error: ", e.value)
                        self.result = make_error("invalid ex value")
                        return
                if option_key == "PX":
                    try:
                        let ex = atol(option_value)
                        if self.db.set_px(key, ex):
                            self.result = make_string("OK")
                        else:
                            self.result = make_error("could not set px value")
                            return
                    except:
                        self.result = make_error("invalid px value")
                        return

        elif command == "DEL":
            if len(args) == 0:
                self.result = make_error("wrong number of arguments for 'del' command")
                return

            var count = 0
            for i in range(len(args)):
                let key = args[i].to_string_ref()

                if self.db.delete(key):
                    count += 1

            self.result = make_integer(count)
        else:
            self.result = make_msg(REDIS_ERROR, "unknown command: " + command)


fn make_msg(header: String, msg: String) -> String:
    var res: String = ""

    res += header
    res += msg
    res += REDIS_CRLF

    return res


# NOTE: how to do it with pointers
# fn make_msg(header: String, msg: String) -> String:
#     let res_len = len(header) + len(msg) + 2
#     let ptr = Pointer[Int8]().alloc(res_len)
#
#     memcpy(ptr, header._buffer.data, len(header))
#     memcpy(ptr.offset(len(header)), msg._buffer.data, len(msg))
#     memcpy(ptr.offset(len(header) + len(msg)), REDIS_CRLF._buffer.data, 2)
#
#     return String(ptr, res_len)


fn make_string(msg: String) -> String:
    return make_msg(REDIS_STRING, msg)


fn make_error(msg: String) -> String:
    return make_msg(REDIS_ERROR, msg)


fn make_integer(msg: Int) -> String:
    return make_msg(REDIS_INTEGER, String(msg))


fn make_bulk_string() -> String:
    return make_msg(REDIS_BULK_STRING + "-1", "")


fn make_bulk_string(msg: String) -> String:
    var header: String = ""
    let msg_len = len(msg)

    if msg_len == 0:
        return make_msg(REDIS_BULK_STRING + "0" + REDIS_CRLF, "")

    header += REDIS_BULK_STRING + String(msg_len) + REDIS_CRLF

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
