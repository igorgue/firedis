from hashtable import HashTable

alias INIT_SIZE: Int = 100


@value
@register_passable("trivial")
struct Table:
    var bools: HashTable[Bool]
    var ints: HashTable[Int]
    var floats: HashTable[Float32]
    var strs: HashTable[StringRef]

    fn __init__(inout self: Self) raises -> Self:
        return Self {
            bools: HashTable[Bool](INIT_SIZE),
            ints: HashTable[Int](INIT_SIZE),
            floats: HashTable[Float32](INIT_SIZE),
            strs: HashTable[StringRef](INIT_SIZE),
        }

    fn __init__(inout self: Self, size: Int) raises -> Self:
        return Self {
            bools: HashTable[Bool](size),
            ints: HashTable[Int](size),
            floats: HashTable[Float32](size),
            strs: HashTable[StringRef](size),
        }

    fn put(inout self: Self, key: StringRef, value: Bool) -> Bool:
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

    fn put(inout self: Self, key: StringRef, value: Int) -> Bool:
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

    fn put(inout self: Self, key: StringRef, value: Float32) -> Bool:
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

    fn put(inout self: Self, key: StringRef, value: StringRef) -> Bool:
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

            return True
        except e:
            return False
