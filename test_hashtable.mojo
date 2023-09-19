import libc

from hashtable import hash_fn, Item, Array, HashTable
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
    let item = Item("foo", rebind[AnyType](1))

    if assert_equal(item.key, "foo"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(rebind[Int](item.value), 1):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    let item2 = Item("foo", rebind[AnyType](1))

    if assert_true(
        rebind[Int](item.value) == rebind[Int](item2.value), "Items should be equal"
    ):
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
    let arr = Array[Int](10)

    if assert_equal(arr.size, 10):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    arr[0] = 10

    if assert_equal(arr[0], 10):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    let arr2 = Array[Int](10)

    if assert_equal(arr2.size, 10):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    arr2[0] = 11

    if assert_equal(arr2[0], 11):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn test_hashtable() -> Bool:
    var hash_table = HashTable[Int](10)

    hash_table.put("time", 123)
    hash_table.put("time2", 123)

    try:
        hash_table.display()
    except e:
        print(e.value)

    if assert_equal(hash_table.table[8][0].value, 123):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table.table[8].size, 1):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table.table[8].cap, 2):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_true(True == False, "TODO: Fix put and get and all methods on hashtable"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True


fn main():
    let total_tests = 4
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

    if test_hashtable():
        passed += 1
    else:
        failed_tests.push_back("test_hashtable")

    print("")

    if passed != total_tests:
        print_no_newline("\nSome tests failed: ")

    for i in range(len(failed_tests)):
        print_no_newline(failed_tests[i])

        if i == len(failed_tests) - 1:
            print("")
        else:
            print_no_newline(", ")

    print("\nPassed", passed, "of", total_tests, "tests.")
