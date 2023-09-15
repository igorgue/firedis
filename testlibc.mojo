import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn main():
    let msg = "Hello, world Server"
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
    _ = libc.printf("Hello, world %s\n", msg)
