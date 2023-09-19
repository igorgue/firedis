import libc

from hashtable import hash_fn, Item, Array
from testing import assert_equal, assert_not_equal, assert_true, assert_false


fn test_hash_fn() -> Bool:
    if assert_equal(hash_fn("test"), 2724192577743982107):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_fn("test"), 2724192577743982107):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_not_equal(hash_fn("test2"), 2724192577743982107):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_item() -> Bool:
    let item = Item("foo", 1)

    if assert_equal(item.key, "foo"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(item.value, 1):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    let item2 = Item("foo", 1)

    if assert_true(item == item2, "Items should be equal"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_false(item == None, "Items should be equal"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_array() -> Bool:
    print("E")
    print("test_array not implemented")
    return False


fn main():
    let total_tests = 1
    var passed = 0
    var failed_tests = DynamicVector[StringRef]()

    if test_hash_fn():
        passed += 1
    else:
        failed_tests.push_back("test_fn")

    if test_item():
        passed += 1
    else:
        failed_tests.push_back("test_item")

    if test_array():
        passed += 1
    else:
        failed_tests.push_back("test_array")

    print("")

    if passed != total_tests:
        print_no_newline("\nSome tests failed: ")

    for i in range(len(failed_tests)):
        print_no_newline(failed_tests[i], " ")

        if i == len(failed_tests) - 1:
            print("")

    print("\nPassed", passed, "of", total_tests, "tests.")
