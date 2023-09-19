import libc
from testing import assert_equal

from hashtable import Item


fn test_item() -> Bool:
    let item = Item("foo", 1)

    if not assert_equal(item.key, "foo"):
        return False

    if not assert_equal(item.value, 2):
        return False

    return True


fn main():
    let total_tests = 1
    var passed = 0
    var failed_tests = DynamicVector[StringRef]()

    if test_item():
        passed += 1
        print(".")
    else:
        failed_tests.push_back("test_item")
        print("E")

    if passed != total_tests:
        print_no_newline("\nSome tests failed: ")

    for i in range(len(failed_tests)):
        print_no_newline(failed_tests[i], " ")

        if i == len(failed_tests) - 1:
            print("")

    print("\nPassed", passed, "of", total_tests, "tests.")
