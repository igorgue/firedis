# TODO: implement these hash functions
fn hash_fn(key: String) -> Int:
    return 0


struct Item[T: AnyType]:
    var key: String
    var value: T

    fn __init__(inout self, key: String, value: T):
        self.key = key
        self.value = value


struct Array[T: AnyType]:
    var data: Pointer[T]
    var size: Int
    var cap: Int

    fn __init__(inout self, size: Int, value: T):
        self.cap = size * 2
        self.size = size
        self.data = Pointer[T].alloc(self.cap)

        for i in range(self.size):
            self.data.store(i, value)

    fn __getitem__(self, i: Int) -> T:
        return self.data.load(i)

    fn __del__(owned self):
        self.data.free()


struct HashTable:
    var size: Int
    var table: Array[Array[Item]]
    var count: Int

    fn __init__(inout self: Self, size: Int):
        self.size = size
        self.count = 0

        var item = StaticTuple("test", value)
        var item_array = Array[StaticTuple[2, String]](
            self.size, StaticTuple[2, String]("test", "test")
        )

        # self.table = Array[Array[Item]](
        #     self.size,
        # )


#     fn hash_function(self, key: String) -> Int:
#         return hash_fn(key) % self.size
#
#     fn put(inout self: Self, key: String, value: AnyType):
#         if self.count >= self.size:
#             self.resize()
#
#         let hash_index = self.hash_function(key)
#
#         for i in range(len(self.table[hash_index].size)):
#             if :
#                 self.table[hash_index][i][1] = value
#                 return
#         for pair in self.table[hash_index]:
#             if pair[0] == key:
#                 pair[1] = value
#                 return
#         self.table[hash_index].append([key, value])
#         self.count += 1
#
#     def get(self, key):
#         hash_index = self.hash_function(key)
#         for pair in self.table[hash_index]:
#             if pair[0] == key:
#                 return pair[1]
#         return None
#
#     def delete(self, key):
#         hash_index = self.hash_function(key)
#         for index, pair in enumerate(self.table[hash_index]):
#             if pair[0] == key:
#                 del self.table[hash_index][index]
#                 self.count -= 1
#                 return
#
#     fn resize(self: Self):
#         old_table = self.table
#         self.size *= 2
#         self.table = [[] for _ in range(self.size)]
#         self.count = 0
#
#         for bucket in old_table:
#             for key, value in bucket:
#                 self.put(key, value)


fn main():
    var item = Item("key", "test")
