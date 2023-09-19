fn main():
    let x: AnyType
    let y = 10

    x = rebind[AnyType](y)

    let z = rebind[Int](x)

    print("x =", z)
