from math import abs


fn hash_fn(key: String) -> Int:
    var hash = 2166136261

    for i in range(len(key)):
        hash ^= ord(key[i])
        hash *= 16777619

    return abs(hash)


@register_passable("trivial")
struct Item[T: AnyType]:
    var key: StringRef
    var value: T

    fn __init__(key: StringRef, value: T) -> Item[T]:
        return Self {key: key, value: value}

    fn __eq__(self, other: None) -> Bool:
        return False


@register_passable("trivial")
struct Array[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(size: Int) -> Array[T]:
        let cap = size * 2
        let data = Pointer[T].alloc(cap)

        return Self {data: data, size: size, cap: cap}

    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)

    fn __setitem__(self, i: Int, value: T):
        self.data.store(i, value)

    fn __ne__(self, other: None) -> Bool:
        return False

    fn __ne__(self, other: Array[T]) -> Bool:
        return not self.data == other.data


struct HashTable:
    var size: Int
    var table: Array[Array[Item[AnyType]]]
    var count: Int

    fn __init__(inout self: Self, size: Int):
        self.size = size
        self.count = 0
        self.table = Array[Array[Item[AnyType]]](self.size)

    fn hash_function(self, key: StringRef) -> Int:
        return hash_fn(key) % self.size

    fn put[T: AnyType](inout self: Self, key: StringRef, value: T):
        if self.count >= self.size:
            self.resize()

            let hash_index = self.hash_function(key)

            for i in range(len(self.table[hash_index].size)):
                if self.table[hash_index][i].key == key:
                    var item = self.table[hash_index][i]
                    item.value = rebind[AnyType](value)

                    return

            let items = self.table[hash_index]

            for i in range(items.size):
                var item = items[i]

                if item == None:
                    item = Item(key, rebind[AnyType](value))
                    self.count += 1
                    return

            for i in range(self.table[hash_index].size):
                var item = self.table[hash_index][i]
                if item.key == key:
                    item.value = rebind[AnyType](value)
                    return

            self.table[hash_index].data.store(
                self.table[hash_index].size, Item(key, rebind[AnyType](value))
            )

            self.count += 1

    fn get(self: Self, key: StringRef) -> AnyType:
        let hash_index = self.hash_function(key)

        for i in range(self.table[hash_index].size):
            let item = rebind[Item[AnyType]](self.table[hash_index][i])
            if item.key == key:
                return item.value

        return rebind[AnyType](None)

    fn delete(inout self: Self, key: StringRef):
        let hash_index = self.hash_function(key)

        for i in range(self.table[hash_index].size):
            let item = self.table[hash_index][i]
            if item.key == key:
                self.table[hash_index][i] = rebind[Item[AnyType]](None)

                self.count -= 1
                return

    fn resize(inout self: Self):
        let old_table = self.table.data
        self.size *= 2
        self.table = Array[Array[Item[AnyType]]](self.size)
        self.count = 0

        for i in range(self.size):
            let bucket = old_table[i]

            if bucket != None:
                for j in range(bucket.size):
                    let item = bucket[j]

                    self.put(item.key, item.value)
