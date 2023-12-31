from time import now

from hashtable import HashTable, Item
from hashtable import NOT_FOUND_ERROR
from libc import exit

alias INIT_SIZE: Int = 100


@value
@register_passable("trivial")
struct Table:
    var bools: HashTable[Bool]
    var ints: HashTable[Int]
    var floats: HashTable[Float32]
    var strs: HashTable[StringRef]

    @staticmethod
    fn create() -> Table:
        let table: Table

        try:
            table = Table()
        except e:
            print("> fatal error: could not init table")
            exit(-1)

            pass

        return table

    fn __init__() raises -> Self:
        return Self {
            bools: HashTable[Bool](INIT_SIZE),
            ints: HashTable[Int](INIT_SIZE),
            floats: HashTable[Float32](INIT_SIZE),
            strs: HashTable[StringRef](INIT_SIZE),
        }

    fn __init__(size: Int) raises -> Self:
        return Self {
            bools: HashTable[Bool](size),
            ints: HashTable[Int](size),
            floats: HashTable[Float32](size),
            strs: HashTable[StringRef](size),
        }

    fn set(inout self: Self, key: StringRef, value: Bool) -> Bool:
        try:
            if self.ints.contains(key):
                return False
            if self.floats.contains(key):
                return False
            if self.strs.contains(key):
                return False

            self.bools[key] = value

            return True
        except e:
            return False

    fn set(inout self: Self, key: StringRef, value: Int) -> Bool:
        try:
            if self.bools.contains(key):
                return False
            if self.floats.contains(key):
                return False
            if self.strs.contains(key):
                return False

            self.ints[key] = value

            return True
        except e:
            return False

    fn set(inout self: Self, key: StringRef, value: Float32) -> Bool:
        try:
            if self.bools.contains(key):
                return False
            if self.ints.contains(key):
                return False
            if self.strs.contains(key):
                return False

            self.floats[key] = value

            return True
        except e:
            return False

    fn set(inout self: Self, key: StringRef, value: StringRef) -> Bool:
        try:
            if self.bools.contains(key):
                return False
            if self.ints.contains(key):
                return False
            if self.floats.contains(key):
                return False

            self.strs[key] = value

            return True
        except e:
            return False

    fn get_item(
        inout self: Self, key: StringRef, inout value: Item[Int]
    ) raises -> Bool:
        if self.ints.contains(key):
            value = self.ints.get_item(key)

            return True

        return False

    fn get_item(
        inout self: Self, key: StringRef, inout value: Item[Bool]
    ) raises -> Bool:
        if self.bools.contains(key):
            value = self.bools.get_item(key)

            return True

        return False

    fn get_item(
        inout self: Self, key: StringRef, inout value: Item[StringRef]
    ) raises -> Bool:
        if self.strs.contains(key):
            value = self.strs.get_item(key)

            return True

        return False

    fn get_item(
        inout self: Self, key: StringRef, inout value: Item[Float32]
    ) raises -> Bool:
        if self.floats.contains(key):
            value = self.floats.get_item(key)

            return True

        return False

    fn get(inout self: Self, key: StringRef, inout value: Bool) -> Bool:
        try:
            value = self.bools[key]

            return True
        except e:
            return False

    fn get(inout self: Self, key: StringRef, inout value: Int) -> Bool:
        try:
            value = self.ints[key]

            return True
        except e:
            return False

    fn get(inout self: Self, key: StringRef, inout value: Float32) -> Bool:
        try:
            value = self.floats[key]

            return True
        except e:
            return False

    fn get(inout self: Self, key: StringRef, inout value: StringRef) -> Bool:
        try:
            value = self.strs[key]

            # NOTE: This is due a bug in the compiler,
            # an exception is returned as a value of the function.
            return value != NOT_FOUND_ERROR
        except e:
            return False

    fn delete(inout self: Self, key: StringRef) -> Bool:
        try:
            return (
                self.bools.delete(key)
                or self.ints.delete(key)
                or self.floats.delete(key)
                or self.strs.delete(key)
            )
        except:
            return False

    fn count(self: Self) -> Int:
        return self.bools.count + self.ints.count + self.floats.count + self.strs.count

    fn set_px(inout self: Self, key: StringRef, value: Int) -> Bool:
        """Set expire in milliseconds."""
        let expire = (now() // 1_000_000) + value

        try:
            if self.bools.contains(key):
                self.bools.set_expire(key, expire)
            elif self.ints.contains(key):
                self.ints.set_expire(key, expire)
            elif self.floats.contains(key):
                self.floats.set_expire(key, expire)
            elif self.strs.contains(key):
                self.strs.set_expire(key, expire)
            else:
                return False

            return True
        except e:
            print("> error setting expire:", e.value)
            return False

    fn set_ex(inout self: Self, key: StringRef, value: Int) -> Bool:
        """Set expire in seconds."""
        return self.set_px(key, value * 1_000)

    fn to_string(inout self: Self) raises -> String:
        var res: String = "\n{\n"

        res += self.bools._to_string_attrs()
        res += "\n"
        res += self.ints._to_string_attrs()
        res += "\n"
        res += self.floats._to_string_attrs()
        res += "\n"
        res += self.strs._to_string_attrs()
        res += "\n"

        res += "}"

        return res

    fn print(inout self: Self) raises:
        print(self.to_string())
