// Checked exceptions ("Unchecked types in 'throws' lists"): after substitution instantiates a type
// parameter to an unchecked exception type, the entry is GONE from the type -- '() throws E -> R'
// with an unchecked 'E' IS the clause-free '() -> R'. Assignability was the first half (fixed
// 2026-08-30); identity is this one: the specialized function goes into an invariant position
// declared with no clause at all.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class ReqExc <: UncheckedException {}

class Box<T> {
    Box(let v: T) {}
}

func safeThrow<E>(e: E): Unit where E <: Exception
throws E {
    throw e
}

main(): Int64 {
    let direct: (ReqExc) -> Unit = safeThrow<ReqExc>
    let boxed: Box<(ReqExc) -> Unit> = Box<(ReqExc) -> Unit>(safeThrow<ReqExc>)
    try {
        direct(ReqExc())
    } catch (e: ReqExc) {
        return 0
    }
    return 1
}
