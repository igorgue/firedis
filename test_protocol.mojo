from protocol import FiredisParser
from testing import assert_equal
from table import Table


fn test_parse_ping() raises -> Bool:
    var db = Table.create()
    let msg = "*1\r\n$4\r\nPING\r\n"
    let resp = "+PONG\r\n"
    var parser = FiredisParser(db, msg)

    parser.parse()

    if assert_equal(parser.result, resp):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_parse_echo() raises -> Bool:
    var db = Table.create()
    let msg = "*2\r\n$4\r\necho\r\n$5\r\nfirst\r\n"
    let resp = "$5\r\nfirst\r\n"
    var parser = FiredisParser(db, msg)

    parser.parse()

    if assert_equal(parser.result, resp):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
