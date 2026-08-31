// Checked exceptions (grammar impact): `throws` and `captures` are recognised by spelling only where a
// clause may start; everywhere else they stay ordinary identifiers, EVEN WITH THE FEATURE
// ENABLED. Reserving them would break existing code — `std.unittest.mock` exports a public
// `throws` function used at hundreds of call sites.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

func throws(x: Int64): Int64 {
    x + 1
}

class C {
    var captures: Int64 = 0

    func throws(): Int64 {
        captures
    }
}

// the same spellings still work as clauses in clause position
func real(): Unit throws AException {
    throw AException()
}

class Holder
captures AException {
    init() {
    }

    func run(): Unit {
        throw AException()
    }
}

main() {
    let captures = 41
    let c = C()
    c.captures = throws(captures)
    if (c.captures != 42 || c.throws() != 42) {
        return 1
    }
    try {
        real()
    } catch (e: AException) {
    }
    try {
        Holder().run()
    } catch (e: AException) {
    }
    return 0
}
