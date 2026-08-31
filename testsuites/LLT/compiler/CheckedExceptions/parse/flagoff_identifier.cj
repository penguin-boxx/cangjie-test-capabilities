// Guard: WITHOUT --enable-chexc, `throws` remains an ordinary identifier —
// existing code that uses it as a name must keep compiling unchanged.

// EXEC: %compiler %cmp_opt %n.cj -o %output
// EXEC: %run %output

func throws(x: Int64): Int64 {
    x + 1
}

class C {
    var throws: Int64 = 0
}

main() {
    let c = C()
    c.throws = throws(41)
    if (c.throws != 42) {
        return 1
    }
    return 0
}
