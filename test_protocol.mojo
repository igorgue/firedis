from protocol import FiredisParser
from testing import assert_equal


fn test_parse_ping() raises -> Bool:
    let msg = "*1\r\n$4\r\nPING\r\n"
    let resp = "+PONG\r\n"
    var parser = FiredisParser(msg)

    parser.parse()

    if assert_equal(parser.result, resp):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_parse_echo() raises -> Bool:
    let msg = "*2\r\n$4\r\necho\r\n$5\r\nfirst\r\n"
    let resp = "$5\r\nfirst\r\n"
    var parser = FiredisParser(msg)

    parser.parse()

    if assert_equal(parser.result, resp):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
