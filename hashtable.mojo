from math import abs
from memory import memcmp


@always_inline
fn hash_fn(key: String) -> Int:
    var hash = 2166136261

    for i in range(len(key)):
        hash ^= ord(key[i])
        hash *= 16777619

    return abs(hash)


@value
@register_passable("trivial")
struct Item[T: AnyType]:
    var key: StringRef
    var value: T

    fn __init__(key: StringRef, value: T) -> Self:
        return Self {key: key, value: value}

    fn __eq__(self, other: None) -> Bool:
        return False

    fn __eq__(self, other: Item[Bool]) -> Bool:
        return self.key == other.key and rebind[Bool](self.value) == other.value

    fn __eq__(self, other: Item[Int]) -> Bool:
        return self.key == other.key and rebind[Int](self.value) == other.value

    fn __eq__(self, other: Item[Float32]) -> Bool:
        return self.key == other.key and rebind[Float32](self.value) == other.value

    fn __eq__(self, other: Item[Float64]) -> Bool:
        return self.key == other.key and rebind[Float64](self.value) == other.value

    fn __eq__(self, other: Item[StringRef]) -> Bool:
        return self.key == other.key and rebind[StringRef](self.value) == other.value

    fn __ne__(self, other: None) -> Bool:
        return True

    fn __ne__(self, other: Item[Bool]) -> Bool:
        return self.__eq__(other) == False

    fn __ne__(self, other: Item[Int]) -> Bool:
        return self.__eq__(other) == False

    fn __ne__(self, other: Item[Float32]) -> Bool:
        return self.__eq__(other) == False

    fn __ne__(self, other: Item[Float64]) -> Bool:
        return self.__eq__(other) == False

    fn __ne__(self, other: Item[StringRef]) -> Bool:
        return self.__eq__(other) == False

    fn set_value(inout self: Self, value: T):
        self.value = value


@value
@register_passable("trivial")
struct Array[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(size: Int) -> Self:
        let cap = size * 2
        let data = Pointer[T].alloc(cap)

        return Self {data: data, size: size, cap: cap}

    fn __getitem__(borrowed self: Self, i: Int) raises -> T:
        if i >= self.size:
            raise Error("Index out of bounds")

        return self.data.load(i)

    fn __setitem__(borrowed self: Self, i: Int, item: T) raises:
        if i >= self.size:
            raise Error("Index out of bounds")

        self.data.store(i, item)

    fn __ne__(self: Self, other: None) -> Bool:
        return False

    fn __ne__(self: Self, other: Array[Bool]) -> Bool:
        return not rebind[Bool](self.data.load()) == other.data.load()

    fn __ne__(self: Self, other: Array[Int]) -> Bool:
        return not rebind[Int](self.data.load()) == other.data.load()

    fn __ne__(self: Self, other: Array[StringRef]) -> Bool:
        return not rebind[StringRef](self.data.load()) == other.data.load()

    fn __ne__(self: Self, other: Array[Float32]) -> Bool:
        return not rebind[Float32](self.data.load()) == other.data.load()

    fn __ne__(self: Self, other: Array[Float64]) -> Bool:
        return not rebind[Float64](self.data.load()) == other.data.load()

    fn push_back(inout self: Self, item: T) raises:
        if self.size >= self.cap:
            self.resize(self.size + 1)

        self.__setitem__(self.size, item)

    fn resize(inout self: Self, new_size: Int):
        let new_cap = new_size * 2
        let new_data = Pointer[T].alloc(new_cap)

        for i in range(new_size):
            new_data.store(i, self.data.load(i))

        self.data.free()
        self.data = new_data
        self.size = new_size
        self.cap = new_cap


@value
@register_passable("trivial")
struct HashTable[T: AnyType]:
    var size: Int
    var table: Array[Array[Item[T]]]
    var count: Int

    fn __init__(size: Int) raises -> Self:
        let table = Array[Array[Item[T]]](size)

        for i in range(size):
            table[i] = Array[Item[T]](0)

        return Self {size: size, table: table, count: 0}

    fn hash_function(self, key: StringRef) -> Int:
        return hash_fn(key) % self.size

    fn put(inout self: Self, key: StringRef, value: T) raises:
        let hash_index = self.hash_function(key)

        for i in range(self.table[hash_index].size):
            if self.table[hash_index][i].key == key:
                self.table[hash_index][i].set_value(value)
                return

        let item = Item[T](key, value)

        self.table[hash_index].data.store(self.table[hash_index].size, item)
        self.table[hash_index].resize(self.table[hash_index].size + 1)

        self.count += 1
        if self.count > self.size:
            self.resize()

    fn get(self: Self, key: StringRef) raises -> T:
        let hash_index = self.hash_function(key)

        for i in range(self.table[hash_index].size):
            let item = self.table[hash_index][i]
            if item.key == key:
                return rebind[T](item.value)

        raise Error("Key not found")

    fn __getitem__(self: Self, key: StringRef) raises -> T:
        return self.get(key)

    fn __setitem__(inout self: Self, key: StringRef, value: T) raises:
        self.put(key, value)

    fn delete(inout self: Self, key: StringRef) raises:
        let hash_index = self.hash_function(key)

        for i in range(self.table[hash_index].size):
            let item = self.table[hash_index][i]
            if item.key == key:
                self.table[hash_index][i] = rebind[Item[T]](None)

                self.count -= 1
                return

    fn resize(inout self: Self) raises:
        let old_table = self.table.data
        self.size *= 2
        self.table = Array[Array[Item[T]]](self.size)
        self.count = 0

        for i in range(self.size):
            let bucket = old_table[i]

            if bucket != None:
                for j in range(bucket.size):
                    let item = bucket[j]

                    self.put(item.key, item.value)

    fn display(inout self: Self) raises -> String:
        var res: String = ""
        # use later for multiple levels (a hash table inside of a hash table)
        let indent = "  "

        res += "\n{\n"

        for i in range(self.size):
            let bucket = self.table[i]

            for j in range(bucket.size):
                let item = bucket[j]

                res += indent
                res += '"'
                res += item.key
                res += '"'
                res += ": "

                if T == Bool:
                    res += String(rebind[Bool](item.value))
                elif T == Float32:
                    res += String(rebind[Float32](item.value))
                elif T == Float64:
                    res += String(rebind[Float64](item.value))
                elif T == Int:
                    res += String(rebind[Int](item.value))
                elif T == StringRef:
                    res += String(rebind[StringRef](item.value))
                elif T == String:
                    res += String(rebind[StringRef](item.value))
                else:
                    res += "???"

                res += ","
                res += "\n"

        res += "}"

        print(res)

        return res
