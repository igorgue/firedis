from hashtable import hash_fn, Item, Array, HashTable
from testing import assert_equal, assert_not_equal, assert_true, assert_false


fn test_hash_fn() raises -> Bool:
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


fn test_item() raises -> Bool:
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


fn test_array() raises -> Bool:
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

    let arr3 = Array[Int](10)
    arr3[0] = 1
    arr3[1] = 2
    arr3[2] = 3
    arr3[3] = 4
    arr3[4] = 5
    arr3[5] = 6
    arr3[6] = 7
    arr3[7] = 8
    arr3[8] = 9
    arr3[9] = 10

    if assert_equal(arr3.size, 10):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    var i = 1
    for item in arr3:
        if assert_equal(item, i):
            print_no_newline(".")
        else:
            print_no_newline("E")
            return False
        i += 1

    return True


fn test_hashtable() raises -> Bool:
    let hash_table_int: HashTable[Int]

    hash_table_int = HashTable[Int](10)

    hash_table_int.set("time", 123)
    hash_table_int.set("time2", 456)

    if assert_equal(hash_table_int.data[8][0].value, 123):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_int.data[8].size, 1):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_int.data[8].cap, 2):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_int.data[6][0].value, 456):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_int.get("time"), 123):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_int["time"], 123):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    hash_table_int["time"] = 321

    if assert_equal(hash_table_int["time"], 321):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    let hash_table_str: HashTable[StringRef]

    hash_table_str["a"] = "a"
    hash_table_str["b"] = "b"
    hash_table_str["c"] = "c"

    if assert_equal(hash_table_str["a"], "a"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    if assert_equal(hash_table_str["b"], "b"):
        print_no_newline(".")
    else:
        print_no_newline("E")
        return False

    return True
