// Checked exceptions (recursion): recursion is inferred via the least fixpoint of
// the SCC's monotone equations. Covers self-recursion, mutual recursion with
// PARTIAL discharge inside the cycle (distinguishes fixpoint from naive union),
// and a mixed cycle with one authoritative explicit member.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}
class BException <: Exception {}

// self-recursion: inferred throws AException
func countdown(n: Int64): Int64 {
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
// so the fixpoint gives ping: {A, B}, pong: {B} (naive union would give pong {A, B})
func ping(n: Int64): Int64 { // inferred: throws AException, BException
    if (n < 0) {
        throw AException()
    }
    pong(n - 1)
}

func pong(n: Int64): Int64 { // inferred: throws BException only
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
    // pong must be callable with only a BException handler (fixpoint, not union)
    try {
        let _ = pong(8)
    } catch (e: BException) {
    }
    return 0
}
