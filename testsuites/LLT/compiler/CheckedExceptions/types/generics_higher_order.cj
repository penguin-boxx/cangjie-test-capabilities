// Checked exceptions (generics, first-class functions): a capability list may mention the type
// parameters of the declaration it belongs to, including inside a parameter's functional type. The
// call site instantiates the whole signature, so the callback's requirement is the instantiated one:
// a function reference carrying it fits, a literal takes it from the expected type, and the
// requirement is discharged inside the higher-order function -- the `retrying` shape of the design.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

func thrower(): Unit throws AException {
    throw AException()
}

// the callback's requirement is discharged here and never reaches the caller
func handling<E>(fn: () throws E -> Unit): Int64 where E <: Exception {
    try {
        fn()
        0
    } catch (e: E) {
        1
    }
}

// the type parameter also appears in an ordinary position, so it can be inferred
func handlingBoth<E>(fn: () throws E -> Unit, witness: E): Int64 where E <: Exception {
    try {
        fn()
        0
    } catch (e: E) {
        1
    }
}

// a member of a generic class: the mapping comes from the receiver
class Handler<E> where E <: Exception {
    func run(fn: () throws E -> Unit): Int64 {
        try {
            fn()
            0
        } catch (e: E) {
            1
        }
    }
}

main(): Int64 {
    if (handling<AException>(thrower) != 1) {
        return 1
    }
    if (handling<BException>({ => throw BException() }) != 1) {
        return 1
    }
    if (handlingBoth(thrower, AException()) != 1) {
        return 1
    }
    if (Handler<AException>().run(thrower) != 1) {
        return 1
    }
    return 0
}
