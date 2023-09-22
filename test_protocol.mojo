from protocol import FiredisParser
from testing import assert_equal


fn test_parse() raises -> Bool:
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
