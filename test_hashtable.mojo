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

    if assert_true(item.value == item2.value, "Items should be equal"):
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
    try:
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
    except:
        print_no_newline("E")
        return False


fn test_hashtable() -> Bool:
    var hash_table: HashTable[Int]

    try:
        hash_table = HashTable[Int](10)

        hash_table.put("time", 123)
        hash_table.put("time2", 456)
    except:
        print_no_newline("E")
        return False

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

    if assert_equal(hash_table.table[6][0].value, 456):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    try:
        if assert_equal(hash_table.get("time"), 123):
            print_no_newline(".")
        else:
            print_no_newline("E")
            return False
    except:
        print_no_newline("E")
        return False

    return True


fn main():
    var passed = 0
    var test_fns = DynamicVector[fn () -> Bool]()

    test_fns.push_back(test_hash_fn)
    test_fns.push_back(test_item)
    test_fns.push_back(test_array)
    test_fns.push_back(test_hashtable)

    let total_tests = len(test_fns)

    for i in range(total_tests):
        if test_fns[i]():
            passed += 1

    if passed == total_tests:
        print("\nAll tests passed!")
    else:
        print("\nSome tests failed.")

    print("\nPassed", passed, "of", total_tests, "tests.")
