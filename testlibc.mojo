import libc


fn main():
    let msg = libc.to_char_ptr("Hello, world Server")
    _ = libc.printf(msg)
    print(libc.strlen(msg))
