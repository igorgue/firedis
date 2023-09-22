from libc import exit

from test_hashtable import test_hash_fn, test_array, test_item, test_hashtable
from test_table import test_table_with_many_types
from test_protocol import test_parse


fn main() raises:
    var passed = 0
    var tests = DynamicVector[fn () raises -> Bool]()

    # hashtable
    tests.push_back(test_hash_fn)
    tests.push_back(test_array)
    tests.push_back(test_item)
    tests.push_back(test_item)

    # table
    tests.push_back(test_table_with_many_types)

    # protocol
    tests.push_back(test_parse)

    let total_tests = len(tests)

    for i in range(total_tests):
        if tests[i]():
            passed += 1

    put_new_line()

    # TODO: figure out how to show the test name

    if passed == total_tests:
        print("All tests passed! 🔥")
        exit(0)
    else:
        print("Some tests failed! 🌊")
        exit(-1)
