# TODO: implement these hash functions
fn hash_fn(key: String) -> Int:
    return 0


@register_passable("trivial")
struct Item[T: AnyType]:
    var key: StringRef
    var value: T

    fn __init__(key: StringRef, value: T) -> Item[T]:
        return Self {key: key, value: value}

    fn __eq__(self, other: None) -> Bool:
        return False

    fn __eq__(self, other: Item[AnyType]) -> Bool:
        return self.key == other.key


@register_passable("trivial")
struct Array[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(size: Int, value: None) -> Array[T]:
        let cap = size * 2
        let data = Pointer[T].alloc(cap)

        return Self {data: data, size: size, cap: cap}

    fn __init__(size: Int, value: T) -> Array[T]:
        let cap = size * 2
        let data = Pointer[T].alloc(cap)

        for i in range(size):
            data.store(i, value)

        return Self {data: data, size: size, cap: cap}

    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)

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
        self.table = Array[Array[Item[AnyType]]](self.size, None)

    fn hash_function(self, key: String) -> Int:
        return hash_fn(key) % self.size

    fn put(inout self: Self, key: StringRef, value: AnyType):
        if self.count >= self.size:
            self.resize()

            let hash_index = self.hash_function(key)

            for i in range(len(self.table[hash_index].size)):
                if self.table[hash_index][i].key == key:
                    var item = self.table[hash_index][i]
                    item.value = value

                    return

            let items = self.table[hash_index]

            for i in range(items.size):
                var item = items[i]

                if item == None:
                    item = Item[AnyType](key, value)
                    self.count += 1
                    return

            for i in range(self.table[hash_index].size):
                var item = self.table[hash_index][i]
                if item.key == key:
                    item.value = value
                    return

            self.table[hash_index].data.store(
                self.table[hash_index].size, Item[AnyType](key, value)
            )

            self.count += 1

        def get(self, key):
            hash_index = self.hash_function(key)

            for i in range(self.table[hash_index].size):
                let item = self.table[hash_index][i]
                if item.key == key:
                    return item.value

            return None

        def delete(self, key):
            let hash_index = self.hash_function(key)

            for i in range(self.table[hash_index].size):
                let item = self.table[hash_index][i]
                if item.key == key:
                    self.table[hash_index][i].__del__()

                    self.count -= 1
                    return

    fn resize(inout self: Self):
        let old_table = self.table.data
        self.size *= 2
        self.table = Array[Array[Item[AnyType]]](self.size, None)
        self.count = 0

        for i in range(self.size):
            let bucket = old_table[i]

            if bucket != None:
                for j in range(bucket.size):
                    let item = bucket[j]

                    self.put(item.key, item.value)
