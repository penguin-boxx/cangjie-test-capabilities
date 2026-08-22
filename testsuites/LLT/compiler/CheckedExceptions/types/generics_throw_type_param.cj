// Checked exceptions (generics): a clause entry may be a type parameter, and the value thrown may
// have that parameter as its static type -- the language admits the throw because the parameter is
// bounded by `Exception` (an unbounded one is rejected by the ordinary throw rule, and by the
// clause rule of clause_not_exception_neg.cj). A `catch` naming the parameter introduces the
// capability for it, so the requirement is discharged inside the generic function itself.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

// the requirement travels to the call site as `throws E`
func safeThrow<E>(e: E): Nothing where E <: Exception throws E {
    throw e
}

// ... or is discharged locally by a catch naming the same parameter
func catchOwn<E>(mk: () -> E): Int64 where E <: Exception {
    try {
        throw mk()
    } catch (e: E) {
        1
    }
}

main(): Int64 {
    if (catchOwn<AException>({ => AException() }) != 1) {
        return 1
    }
    if (catchOwn<BException>({ => BException() }) != 1) {
        return 1
    }
    try {
        safeThrow<AException>(AException())
    } catch (e: AException) {
        return 0
    }
    return 1
}
