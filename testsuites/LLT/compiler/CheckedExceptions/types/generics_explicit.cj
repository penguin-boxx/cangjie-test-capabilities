// Checked exceptions (§3.6): clause types may be/contain type parameters; capability
// argument inference follows type-argument inference (explicit args work).

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

func safeThrow<E>(e: E): Nothing where E <: Exception throws E {
    throw e
}

func eqOrThrow<T, E>(x: T, y: T, mkE: () -> E): Unit
where T <: Equatable<T>, E <: Exception
throws E {
    if (x != y) {
        throw mkE()
    }
}

main() {
    try {
        eqOrThrow<Int64, AException>(1, 1, { => AException() })
        safeThrow<AException>(AException())
    } catch (e: AException) {
        return 0
    }
    return 1
}
