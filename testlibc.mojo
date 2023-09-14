import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


# fn printf[T0: AnyType, T1: AnyType](format: StringRef, arg0: T0, arg1: T1) -> Int32:
#     let ptr = Pointer[UInt8]().alloc(len(format))
#     for i in range(len(format)):
#         ptr.store(i, ord(format[i]))
#
#     return external_call["printf", Int32, Pointer[UInt8], T0, T1](ptr, arg0, arg1)


fn main():
    let msg = "Hello, world Server"
    _ = libc.printf("Hello, world %d\n", 10)
    # let format: String = "test %d\n"
    # let ptr: Pointer[UInt8] = Pointer[UInt8]().alloc(len(format))
    # for i in range(len(format)):
    #     ptr.store(i, ord(format[i]))
    #
    # _ = __printf__["printf", Int32](ptr, 10)
    # _ = printf("Hello, world %d\n", 10)
    # let msg = libc.to_char_ptr("Hello, world Server")
    # # _ = libc.printf(msg)
    # print(libc.strlen(msg))
    #
    # let number = 10
    #
    # _ = libc.printf("Number %d\n", 111132)
