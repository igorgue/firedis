from string_utils import to_lower, to_upper
from testing import assert_equal


fn test_to_upper() raises -> Bool:
    return to_upper("hello") == "HELLO"


fn test_to_lower() raises -> Bool:
    return to_lower("HELLO") == "hello"
