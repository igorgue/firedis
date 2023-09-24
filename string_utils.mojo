fn to_lower(s: String, slen: Int) -> String:
    let ptr = Pointer[UInt8]().alloc(slen)

    for i in range(slen):
        if ord(s[i]) >= ord("A") and ord(s[i]) <= ord("Z"):
            ptr.store(i, ord(s[i]) + 32)
        else:
            ptr.store(i, ord(s[i]))

    return String(ptr.bitcast[Int8](), slen)


fn to_lower(s: String) -> String:
    return to_lower(s, len(s))


fn to_upper(s: String, slen: Int) -> String:
    let ptr = Pointer[UInt8]().alloc(slen)

    for i in range(slen):
        if ord(s[i]) >= ord("a") and ord(s[i]) <= ord("z"):
            ptr.store(i, ord(s[i]) - 32)
        else:
            ptr.store(i, ord(s[i]))

    return String(ptr.bitcast[Int8](), slen)


fn to_upper(s: String) -> String:
    return to_upper(s, len(s))
