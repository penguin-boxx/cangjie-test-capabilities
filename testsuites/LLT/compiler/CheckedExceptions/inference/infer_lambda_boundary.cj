// Checked exceptions (what is inferred, discharge by a function literal): a requirement raised
// inside a literal whose EXPECTED TYPE carries the corresponding capability parameter
// is discharged there and must NOT be inferred for the enclosing declaration. A literal
// whose expected type carries no capability list discharges nothing, so the requirement
// propagates out by capture (higher-order functions) and IS inferred.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class IOException <: Exception {}
class NegativeException <: Exception {}

// the literal parameter DOES declare a capability list: it handles IOException itself.
// Note the fallback: calling `f()` again from the catch block would be outside the try's
// capability scope (capability argument inference) and would make this helper itself require the capability.
func withIOException<R>(f: () throws IOException -> R, fallback: R): R {
    try {
        f()
    } catch (e: IOException) {
        fallback
    }
}

// the literal parameter declares NO capability list (a plain higher-order function)
func apply<T, R>(x: T, f: (T) -> R): R {
    f(x)
}

// inferred: EMPTY — the throw is covered by the literal's own capability parameter,
// so nothing propagates here and no clause is required of this declaration
func dischargedByLiteral(): Int64 {
    withIOException<Int64>({ => throw IOException() }, 7)
}

// inferred: NegativeException — the literal has no capability parameters, so the
// requirement is captured from the enclosing scope and propagates out
func propagatesThroughLiteral(x: Int64): Int64 {
    apply<Int64, Int64>(x) {
        v =>
        if (v < 0) {
            throw NegativeException()
        }
        v
    }
}

// a caller of the first needs NO handler; a caller of the second does
func usesDischarged(): Int64 {
    dischargedByLiteral()
}

main() {
    let a = usesDischarged()
    try {
        let b = propagatesThroughLiteral(-1)
        if (a + b == 0) {
            return 1
        }
        return 1
    } catch (e: NegativeException) {
    }
    return 0
}
