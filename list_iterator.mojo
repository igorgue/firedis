struct ListIterator[T: AnyType]:
    """
    To use in a for loop, you need to implement `__iter__`.
    """

    var storage: Pointer[T]
    var offset: Int
    var max: Int

    fn __init__(inout self, storage: Pointer[T], max: Int):
        self.offset = 0
        self.max = max
        self.storage = storage

    fn __len__(self) -> Int:
        return self.max - self.offset

    fn __next__(inout self) -> T:
        let ret = self.storage.load(self.offset)
        self.offset += 1
        return ret
