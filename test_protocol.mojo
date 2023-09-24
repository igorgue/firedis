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

    let msg2 = "*3\r\n$4\r\necho\r\n$12\r\nfirst string\r\n$13\r\nsecond string\r\n"
    let resp2 = "+PONG\r\n"
    var parser2 = FiredisParser(msg2)

    parser2.parse()

    if assert_equal(parser2.result, resp2):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
