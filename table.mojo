from hashtable import HashTable

alias INIT_SIZE: Int = 100


struct Table:
    var keys: DynamicVector[StringRef]
    var types: DynamicVector[UInt8]

    var bools: HashTable[Bool]
    var ints: HashTable[Int]
    var floats: HashTable[Float32]
    var strs: HashTable[StringRef]

    fn __init__(inout self: Self) raises:
        self.keys = DynamicVector[StringRef]()
        self.types = DynamicVector[UInt8]()

        self.bools = HashTable[Bool](INIT_SIZE)
        self.ints = HashTable[Int](INIT_SIZE)
        self.floats = HashTable[Float32](INIT_SIZE)
        self.strs = HashTable[StringRef](INIT_SIZE)

    fn put(inout self: Self, key: StringRef, value: Bool) raises -> Bool:
        try:
            _ = self.ints[key]
            _ = self.floats[key]
            _ = self.strs[key]

            return False
        except e:
            # means we could not find the key elsewhere
            pass

        self.bools[key] = value

        return True

    fn put(inout self: Self, key: StringRef, value: Int) raises -> Bool:
        try:
            _ = self.ints[key]
            _ = self.floats[key]
            _ = self.strs[key]

            return False
        except e:
            # means we could not find the key elsewhere
            pass

        self.ints[key] = value

        return True

    fn put(inout self: Self, key: StringRef, value: Float32) raises -> Bool:
        try:
            _ = self.ints[key]
            _ = self.floats[key]
            _ = self.strs[key]

            return False
        except e:
            # means we could not find the key elsewhere
            pass

        self.floats[key] = value

        return True

    fn put(inout self: Self, key: StringRef, value: StringRef) raises -> Bool:
        try:
            _ = self.ints[key]
            _ = self.floats[key]
            _ = self.strs[key]

            return False
        except e:
            # means we could not find the key elsewhere
            pass

        self.strs[key] = value

        return True

    fn get(inout self: Self, key: StringRef, inout value: Bool) raises:
        value = self.bools[key]

    fn get(inout self: Self, key: StringRef, inout value: Int) raises:
        value = self.ints[key]

    fn get(inout self: Self, key: StringRef, inout value: StringRef) raises:
        value = self.strs[key]

    fn get(inout self: Self, key: StringRef, inout value: Float32) raises:
        value = self.floats[key]
