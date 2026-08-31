// Checked exceptions (capability parameters in declarations): `throws` clauses on top-level function declarations.
// Positive: all forms parse and the program compiles and runs.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

// single entry
func f1() throws AException {
    throw AException()
}

// multiple entries
func f2() throws AException, BException {
    f1()
    throw BException()
}

// empty clause: requires no capabilities from call sites
func f3() throws () {
    try {
        f1()
    } catch (e: AException) {
    }
}

// throws before where
func g1<T>(x: T): Unit throws AException where T <: ToString {
    throw AException()
}

// where before throws
func g2<T>(x: T): Unit where T <: ToString throws AException {
    throw AException()
}

// generic exception type in the clause
func gThrow<E>(e: E): Nothing where E <: Exception throws E {
    throw e
}

main() {
    try {
        f2()
        g1<Int64>(1)
        g2<Int64>(2)
        gThrow<AException>(AException())
    } catch (e: Exception) {
    }
    f3()
    return 0
}
