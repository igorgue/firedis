import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn main():
    let msg = "Hello, world Server"
    let msg2 = "Hello, world Server 2"
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s %s\n", msg, msg2)  # sadly this doesn't work...
