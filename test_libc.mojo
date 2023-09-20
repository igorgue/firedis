import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn test_ptr_to_string() raises -> Bool:
    print_no_newline(".")
    return True
