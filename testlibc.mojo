import libc


fn main():
    let msg = libc.to_char_ptr("Hello, world Server")
    print(libc.strlen(msg))
