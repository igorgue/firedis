import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn test_ptr_to_string() raises -> Bool:
    print_no_newline(".")
    return True


fn main() raises:
    print("> test_libc.mojo:")

    var passed = 0
    var test_fns = DynamicVector[fn () raises -> Bool]()

    test_fns.push_back(test_ptr_to_string)

    let total_tests = len(test_fns)

    for i in range(total_tests):
        if test_fns[i]():
            passed += 1

    if passed == total_tests:
        print("\nAll tests passed! 🔥")
    else:
        print("\nSome tests failed.")

    print("\nPassed", passed, "of", total_tests, "tests.")
