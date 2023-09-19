import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn main():
    var msg = "Hello!"
    _ = libc.printf("msg: %s\n", msg)

    libc.exit(-1)

    msg = "Hello again!"
    _ = libc.printf("msg: %s\n", msg)
