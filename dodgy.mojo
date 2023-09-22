from list_iterator import ListIterator


@value
@register_passable("trivial")
struct DodgyString:
    var data: Pointer[Int8]
    var len: Int

    fn __init__(str: StringLiteral) -> DodgyString:
        let l = str.__len__()
        let s = String(str)
        let p = Pointer[Int8].alloc(l)

        for i in range(l):
            p.store(i, s._buffer[i])

        return DodgyString(p, l)

    fn __init__(str: String) -> DodgyString:
        let l = len(str)
        let p = Pointer[Int8].alloc(l)

        for i in range(l):
            p.store(i, str._buffer[i])

        return DodgyString(p, l)

    fn __init__(str: StringRef) -> DodgyString:
        let l = len(str)
        let s = String(str)
        let p = Pointer[Int8].alloc(l)

        for i in range(l):
            p.store(i, s._buffer[i])

        return DodgyString(p, l)

    # fn __iter__(self) -> ListIterator[Int]:
    #     return ListIterator[Int](self.data, self.size)

    fn to_string(self) -> String:
        let s = String(self.data, self.len)

        return s
