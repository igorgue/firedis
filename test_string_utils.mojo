from string_utils import to_lower, to_upper
from testing import assert_equal


fn test_to_upper() raises -> Bool:
    if assert_equal(to_upper("hello"), "HELLO"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_to_lower() raises -> Bool:
    if assert_equal(to_lower("HELLO"), "hello"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
