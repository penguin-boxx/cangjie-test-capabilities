// Recursive execution remains legal through authoritative complete contracts.
// Rewrite policy: inferred cycles are rejected by rewrite/cycles/*_neg.cj.
// The mixed anchor/inferred case below has no recursive contract dependency.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

// self-recursion through a written contract
func countdown(n: Int64): Int64 throws AException {
    if (n < 0) {
        throw AException()
    }
    if (n == 0) {
        0
    } else {
        countdown(n - 1)
    }
}

// mutual recursion with partial discharge:
// pingpong's own B-throw survives; pong discharges A inside the cycle,
// the written contracts preserve partial discharge: ping requires {A, B}, pong only {B}
func ping(n: Int64): Int64 throws AException, BException {
    if (n < 0) {
        throw AException()
    }
    pong(n - 1)
}

func pong(n: Int64): Int64 throws BException {
    if (n == 7) {
        throw BException()
    }
    if (n <= 0) {
        0
    } else {
        try {
            ping(n - 1)
        } catch (e: AException) {
            0
        }
    }
}

// mixed cycle: one member carries an authoritative explicit clause
func loud(n: Int64): Int64 throws AException { // explicit, checked as written
    quiet(n)
}

func quiet(n: Int64): Int64 { // inferred: throws AException (from calling loud)
    if (n <= 0) {
        0
    } else {
        loud(n - 1)
    }
}

main() {
    try {
        let a = countdown(3)
        let b = pong(20)
        let c = quiet(2)
        if (a + b + c != 0) {
            return 1
        }
    } catch (e: Exception) {
        return 1
    }
    // pong must be callable with only a BException handler (its written contract)
    try {
        let _ = pong(8)
    } catch (e: BException) {
    }
    return 0
}
