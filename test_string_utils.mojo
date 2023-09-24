from string_utils import to_lower, to_upper, to_repr, to_string_ref
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


fn test_to_repr() raises -> Bool:
    let s = "hello\n\r"

    if assert_equal(to_repr(s), '"hello\\n\\r"'):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_to_string_ref() raises -> Bool:
    let s: String = "hello"
    let expected: StringRef = "hello"

    if assert_equal(to_string_ref(s), expected):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
