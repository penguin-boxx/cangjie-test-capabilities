// Checked exceptions (the escape hatch): 'unsafeCanThrow<E>(f)' runs 'f' with a fabricated
// capability for 'E' -- a type-level assumption with no runtime content, for migration and boundary
// code that knows an exception cannot occur. The callback takes its capability list from the
// parameter's type, so a requirement inside it is discharged; the call site itself requires nothing.
// If an E really escapes, it propagates exactly as an unchecked exception would.

// EXEC: %compiler %cmp_opt --experimental --enable-chexc %n.cj -o %output
// EXEC: %run %output

class AException <: Exception {}

func mayThrow(n: Int64): Int64 throws AException {
    if (n < 0) {
        throw AException()
    }
    n
}

// no clause of its own: the assumption removes the obligation rather than passing it on
func assumed(n: Int64): Int64 {
    unsafeCanThrow<AException, Int64>({ => mayThrow(n) })
}

main(): Int64 {
    if (assumed(3) != 3) {
        return 1
    }
    // the assumption is a lie here, and the exception propagates like an unchecked one
    try {
        assumed(-1)
        return 1
    } catch (e: AException) {
        return 0
    }
}
