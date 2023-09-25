from list_iterator import ListIterator
from libc import strlen
from memory import memcpy

from string_utils import to_string_ref


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

    fn __eq__(self, other: DodgyString) -> Bool:
        if self.len != other.len:
            return False

        for i in range(self.len):
            if self.data.load(i) != other.data.load(i):
                return False

        return True

    fn __ne__(self, other: DodgyString) -> Bool:
        return not self.__eq__(other)

    fn __iter__(self) -> ListIterator[Int8]:
        return ListIterator[Int8](self.data, self.len)

    fn to_string(self) -> String:
        let ptr = Pointer[Int8]().alloc(self.len)

        memcpy(ptr, self.data, self.len)

        return String(ptr, self.len)

    fn to_string_ref(self) -> StringRef:
        return to_string_ref(self.to_string())
