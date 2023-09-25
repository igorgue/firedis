from table import Table
from hashtable import NOT_FOUND_ERROR
from testing import assert_equal, assert_not_equal, assert_true, assert_false


fn test_table_with_many_types() raises -> Bool:
    var table = Table()

    if not table.put("a", True):
        print_no_newline("E")
        return False
    else:
        print_no_newline(".")

    if not table.put("b", 2):
        print_no_newline("E")
        return False
    else:
        print_no_newline(".")

    if not table.put("c", 3.3):
        print_no_newline("E")
        return False
    else:
        print_no_newline(".")

    if not table.put("d", "4"):
        print_no_newline("E")
        return False
    else:
        print_no_newline(".")

    var a: Bool = False
    _ = table.get("a", a)

    if assert_equal(a, True):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var b: Int = -1
    _ = table.get("b", b)

    if assert_equal(b, 2):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var c: Float32 = -1.0
    _ = table.get("c", c)

    if assert_equal(c, 3.3):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var d: StringRef = ""
    _ = table.get("d", d)

    if assert_equal(d, "4"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var e: StringRef = ""
    if not table.get("e", e) and assert_equal(e, NOT_FOUND_ERROR):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var e2: Float32 = -1.0
    if not table.get("e", e2) and assert_equal(e2, -1.0):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
