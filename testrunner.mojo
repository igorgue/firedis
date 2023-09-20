import libc

from test_libc import test_ptr_to_string
from test_hashtable import test_hash_fn, test_array, test_item, test_hashtable


fn main() raises:
    var passed = 0
    var tests = DynamicVector[fn () raises -> Bool]()

    # libc tests
    tests.push_back(test_ptr_to_string)

    # hashtable tests
    tests.push_back(test_hash_fn)
    tests.push_back(test_array)
    tests.push_back(test_item)
    tests.push_back(test_item)

    let total_tests = len(tests)

    for i in range(total_tests):
        if tests[i]():
            passed += 1

    print("\n")

    # TODO: figure out how to show the test name

    if passed == total_tests:
        print("All tests passed! 🔥")
        libc.exit(0)
    else:
        print("Some tests failed! 🌊")
        libc.exit(-1)
