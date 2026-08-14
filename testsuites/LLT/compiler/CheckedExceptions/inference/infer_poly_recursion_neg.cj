// Checked exceptions (§6.3.4): polymorphic recursion over exception-relevant type
// parameters makes the candidate universe infinite — inference is rejected with
// an error naming the growing instantiation; explicit clauses are required.

// EXEC-PIPE-1: %compiler %cmp_opt --experimental --enable-checked-exceptions %n.cj -o %output 2>&1 | compare %f
// ASSERT: scan error

class Box<T> {}
class GenericException<T> <: Exception {}

func f<T>(n: Int64): Int64 {
    if (n < 0) {
        throw GenericException<T>()
    }
    if (n == 0) {
        0
    } else {
        f<Box<T>>(n - 1) // re-enters at a growing instantiation
    }
}

main() {
    try {
        let _ = f<Int64>(3)
    } catch (e: Exception) {
    }
    return 0
}
