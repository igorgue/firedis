from libc import exit

from test_hashtable import test_hash_fn, test_array, test_item, test_hashtable
from test_table import test_table_with_many_types, test_table_delete_items
from test_protocol import test_parse_ping, test_parse_echo, test_parse_long_message
from test_string_utils import (
    test_to_upper,
    test_to_lower,
    test_to_repr,
    test_to_string_ref,
)


fn main() raises:
    var passed = 0
    var tests = DynamicVector[fn () raises -> Bool]()

    # string utils
    tests.push_back(test_to_upper)
    tests.push_back(test_to_lower)
    tests.push_back(test_to_repr)
    tests.push_back(test_to_string_ref)

    # hashtable
    tests.push_back(test_hash_fn)
    tests.push_back(test_array)
    tests.push_back(test_item)
    tests.push_back(test_item)

    # table
    tests.push_back(test_table_with_many_types)
    tests.push_back(test_table_delete_items)

    # protocol
    tests.push_back(test_parse_ping)
    tests.push_back(test_parse_echo)
    tests.push_back(test_parse_long_message)

    let total_tests = len(tests)

    for i in range(total_tests):
        if tests[i]():
            passed += 1

    put_new_line()

    # TODO: figure out how to show the test name

    if passed == total_tests:
        print("\033[0;32mAll (" + String(total_tests) + ") tests passed!\033[0;0m 🔥")
        exit(0)
    else:
        print(
            "\033[0;31mSome tests failed ("
            + String(passed)
            + "/"
            + String(total_tests)
            + ")!\033[0;0m 🌊"
        )
        exit(-1)
