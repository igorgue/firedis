from memory import memcpy


fn to_repr(s: String) -> String:
    var res: String = '"'

    for i in range(len(s)):
        if s[i] == "\r":
            res += "\\r"
        elif s[i] == "\n":
            res += "\\n"
        else:
            res += s[i]

    res += '"'

    return res


fn to_string_ref(s: String) -> StringRef:
    let slen = len(s)
    let ptr = Pointer[Int8]().alloc(slen)

    memcpy(ptr, s._buffer.data.bitcast[Int8](), slen)

    return StringRef(ptr.bitcast[__mlir_type.`!pop.scalar<si8>`]().address, slen)


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
