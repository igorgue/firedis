from memory import memcpy


fn to_lower(s: String, slen: Int) -> String:
    let ptr = Pointer[Int8]().alloc(slen)

    memcpy(ptr, s._buffer.data.bitcast[Int8](), slen)

    for i in range(slen):
        if ptr.load(i) >= ord("A") and ptr.load(i) <= ord("Z"):
            ptr.store(i, ptr.load(i) + 32)

    return String(ptr, slen)


fn to_lower(s: String) -> String:
    return to_lower(s, len(s))


fn to_upper(s: String, slen: Int) -> String:
    let ptr = Pointer[Int8]().alloc(slen)

    memcpy(ptr, s._buffer.data.bitcast[Int8](), slen)

    for i in range(slen):
        if ptr.load(i) >= ord("a") and ptr.load(i) <= ord("z"):
            ptr.store(i, ptr.load(i) - 32)

    return String(ptr, slen)


fn to_upper(s: String) -> String:
    return to_upper(s, len(s))
