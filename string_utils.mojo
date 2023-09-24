fn to_lower(s: String) -> String:
    var result: String = ""

    for i in range(len(s)):
        var c = s[i]

        if ord(c) >= ord("A") and ord(c) <= ord("Z"):
            c = chr(ord(c) + 32)

        result += c

    return result


fn to_upper(s: String) -> String:
    var result: String = ""

    for i in range(len(s)):
        var c = s[i]

        if ord(c) >= ord("a") and ord(c) <= ord("z"):
            c = chr(ord(c) - 32)

        print("c:", c)

        result += c

    print("'s:", "'" + s + "'", "result:", "'" + result + "'")

    return result
