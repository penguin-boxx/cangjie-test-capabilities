// Checked exceptions (§3.9): `captures` is allowed on structs; copying duplicates
// the capability (freely duplicable evidence).

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class ParseException <: Exception {}

struct Cursor
captures ParseException {
    var pos: Int64 = 0

    init() {
    }

    mut func advanceOrThrow(limit: Int64): Unit {
        pos = pos + 1
        if (pos > limit) {
            throw ParseException()
        }
    }
}

main() {
    try {
        var c = Cursor()
        var d = c // copy carries the capability too
        c.advanceOrThrow(10)
        d.advanceOrThrow(0) // throws
        return 1
    } catch (e: ParseException) {
    }
    return 0
}
