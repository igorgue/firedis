import libc

from sys.intrinsics import external_call
from sys.intrinsics import _mlirtype_is_eq


fn main():
    let msg = "Hello!"
    _ = libc.printf("msg: %s\n", msg)
