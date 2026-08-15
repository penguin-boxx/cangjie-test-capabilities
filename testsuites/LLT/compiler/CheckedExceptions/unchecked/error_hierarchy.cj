// Checked exceptions (§1.1, §6.4): the Error hierarchy is fail-fast, not statically tracked —
// 'Error <: ToString' is a separate root from 'Exception', and throwing one never requires a
// capability. Errors cannot be constructed by user code (their constructors are internal to
// std.core), so the user-visible path is rethrowing a caught one, and the compiler-side proof
// is std.core itself compiling warning-free in warn mode (its own OutOfMemoryError throws
// warned before this rule).

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

// public, so nothing is inferred: any spurious demand would be reported
public func rethrowError(): Int64 {
    try {
        return 1
    } catch (e: Error) {
        throw e // must not demand: Error is outside both tracked roots
    }
}

// ... and through the umbrella pattern that catches everything:
public func rethrowAny(): Int64 {
    try {
        return 2
    } catch (e: Error) {
        throw e
    } catch (e: Exception) {
        return 0 // an Exception rethrow here WOULD demand; returning instead keeps this legal
    }
}

main() {
    if (rethrowError() + rethrowAny() != 3) {
        return 1
    }
    return 0
}
