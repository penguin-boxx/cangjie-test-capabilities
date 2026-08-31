// Checked exceptions ("Unchecked types in 'throws' lists"): an entry whose type parameter
// instantiates to an unchecked exception type vanishes -- '() throws E -> R' with 'E' unchecked
// IS the clause-free '() -> R'. So the specialized function is assignable wherever the
// clause-free shape is expected, and calling it through that value demands nothing.

// EXEC: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output
// EXEC: %run %output

class ReqExc <: UncheckedException {}

func safeThrow<E>(e: E): Unit where E <: Exception
throws E {
    throw e
}

main(): Int64 {
    let g: (ReqExc) -> Unit = safeThrow<ReqExc>
    try {
        g(ReqExc())
    } catch (e: ReqExc) {
        return 0
    }
    return 1
}
